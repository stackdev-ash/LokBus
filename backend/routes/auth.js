// routes/auth.js
const express = require("express");
const router = express.Router();
const {
  register,
  login,
  logout,
  getProfile,
  changePassword
} = require("../controllers/authController");
const {
  authenticateToken,
} = require("../middlewares/auth");

// Public signup & login
router.post("/register", register);
router.post("/login", login);

// Protected logout, profile, change-password (any authenticated user)
router.post("/logout", authenticateToken, logout);
router.get("/profile", authenticateToken, getProfile);
router.put("/change-password", authenticateToken, changePassword);


module.exports = router;
