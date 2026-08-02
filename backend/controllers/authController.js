const User = require("../models/User");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const Trip = require("../models/Trip");

// Register
const register = async (req, res) => {
  try {
    const { name, phone, password } = req.body;
    if (!name || !phone || !password) {
      return res.status(400).json({
        success: false,
        error: "Name, phone, and password are required",
        code: "MISSING_FIELDS",
      });
    }
    if (!/^[6-9]\d{9}$/.test(phone)) {
      return res.status(400).json({
        success: false,
        error: "Invalid phone number format",
        code: "INVALID_PHONE",
      });
    }
    if (password.length < 8) {
      return res.status(400).json({
        success: false,
        error: "Password must be at least 8 characters long",
        code: "WEAK_PASSWORD",
      });
    }
    const existingUser = await User.findOne({ phone });
    if (existingUser) {
      return res.status(409).json({
        success: false,
        error: "Phone number already registered",
        code: "PHONE_EXISTS",
      });
    }

    const passwordHash = await bcrypt.hash(password, 14);
    const user = await User.create({
      name: name.trim(),
      phone,
      passwordHash,
      role: "user",
    });

    res.status(201).json({
      success: true,
      message: "User registered successfully",
      user: {
        id: user._id,
        name: user.name,
        phone: user.phone,
        createdAt: user.createdAt,
      },
    });
  } catch (error) {
    console.error("Registration error:", error);
    res.status(500).json({
      success: false,
      error: "Registration failed",
      code: "REGISTRATION_ERROR",
    });
  }
};

// Login with role-based payload + Cookie
const login = async (req, res) => {
  try {
    const { phone, password } = req.body;
    if (!phone || !password) {
      return res.status(400).json({
        success: false,
        error: "Phone and password are required",
        code: "MISSING_CREDENTIALS",
      });
    }
    const user = await User.findOne({ phone });
    if (!user) {
      return res.status(401).json({
        success: false,
        error: "Invalid credentials",
        code: "INVALID_CREDENTIALS",
      });
    }
    if (user.isLocked) {
      return res.status(423).json({
        success: false,
        error: "Account is temporarily locked",
        code: "ACCOUNT_LOCKED",
      });
    }
    const valid = await user.comparePassword(password);
    if (!valid) {
      await user.incLoginAttempts();
      return res.status(401).json({
        success: false,
        error: "Invalid credentials",
        code: "INVALID_CREDENTIALS",
      });
    }
    await user.resetLoginAttempts();

    const token = jwt.sign(
      { id: user._id, role: user.role, phone: user.phone },
      process.env.JWT_SECRET,
      {
        expiresIn: process.env.TOKEN_EXPIRY || "24h",
        issuer: "bus-tracking-system",
        audience: "bus-tracking-users",
      }
    );

    // Send token in secure cookie
    res.cookie("token", token, {
      httpOnly: true,
      secure: process.env.NODE_ENV === "production",
      sameSite: "strict",
      maxAge: 7 * 24 * 60 * 60 * 1000,
    });

    const base = {
      success: true,
      message: "Login successful",
      user: user.toSafeObject(),
    };

    // Driver-specific data
    if (user.role === "driver") {
      const activeTrips = await Trip.find({
        driver: user._id,
        status: "ongoing",
      })
        .select("_id route lastLocation startedAt")
        .lean();
      return res.json({ ...base, driverData: { activeTrips } });
    }

    // Admin-specific data
    if (user.role === "admin") {
      const [totalUsers, totalTrips] = await Promise.all([
        User.countDocuments(),
        Trip.countDocuments(),
      ]);
      return res.json({ ...base, adminData: { totalUsers, totalTrips } });
    }

    // Regular user
    res.json(base);
  } catch (error) {
    console.error("Login error:", error);
    res.status(500).json({
      success: false,
      error: "Login failed",
      code: "LOGIN_ERROR",
    });
  }
};

// Logout: Clear cookie
const logout = async (req, res) => {
  try {
    res.clearCookie("token", {
      httpOnly: true,
      secure: process.env.NODE_ENV === "production",
      sameSite: "strict",
    });

    res.json({ success: true, message: "Logout successful" });
  } catch (error) {
    console.error("Logout error:", error);
    res.status(500).json({
      success: false,
      error: "Logout failed",
      code: "LOGOUT_ERROR",
    });
  }
};

// Get Profile
const getProfile = async (req, res) => {
  try {
    const user = await User.findById(req.user.id).select(
      "-passwordHash -loginAttempts -lockUntil"
    );
    if (!user) {
      return res.status(404).json({
        success: false,
        error: "User not found",
        code: "USER_NOT_FOUND",
      });
    }
    res.json({ success: true, user: user.toSafeObject() });
  } catch (error) {
    console.error("Get profile error:", error);
    res.status(500).json({
      success: false,
      error: "Failed to fetch profile",
      code: "PROFILE_FETCH_ERROR",
    });
  }
};

// Change Password
const changePassword = async (req, res) => {
  try {
    const { currentPassword, newPassword } = req.body;
    if (!currentPassword || !newPassword) {
      return res.status(400).json({
        success: false,
        error: "Current and new passwords are required",
        code: "MISSING_PASSWORDS",
      });
    }
    if (newPassword.length < 8) {
      return res.status(400).json({
        success: false,
        error: "New password must be at least 8 characters long",
        code: "WEAK_PASSWORD",
      });
    }
    const user = await User.findById(req.user.id);
    if (!user) {
      return res.status(404).json({
        success: false,
        error: "User not found",
        code: "USER_NOT_FOUND",
      });
    }
    const valid = await user.comparePassword(currentPassword);
    if (!valid) {
      return res.status(401).json({
        success: false,
        error: "Current password is incorrect",
        code: "INVALID_CURRENT_PASSWORD",
      });
    }
    user.passwordHash = await bcrypt.hash(newPassword, 14);
    await user.save();
    res.json({ success: true, message: "Password changed successfully" });
  } catch (error) {
    console.error("Change password error:", error);
    res.status(500).json({
      success: false,
      error: "Failed to change password",
      code: "PASSWORD_CHANGE_ERROR",
    });
  }
};

module.exports = {
  register,
  login,
  logout,
  getProfile,
  changePassword,
};
