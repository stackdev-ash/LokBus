const jwt = require('jsonwebtoken');
const User = require('../models/User');

const authenticateToken = async (req, res, next) => {
  try {
    // Check token in cookie first
    const token = req.cookies?.token || (req.headers.authorization?.split(' ')[1]);

    if (!token) {
      return res.status(401).json({ 
        success: false, 
        error: 'Access token required', 
        code: 'TOKEN_MISSING' 
      });
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const user = await User.findById(decoded.id).select('-passwordHash');
    if (!user) {
      return res.status(401).json({ 
        success: false, 
        error: 'Invalid token - user not found',
        code: 'USER_NOT_FOUND' 
      });
    }

    req.user = user;
    next();
  } catch (error) {
    if (error.name === 'TokenExpiredError') {
      return res.status(401).json({ success: false, error: 'Token expired', code: 'TOKEN_EXPIRED' });
    }
    if (error.name === 'JsonWebTokenError') {
      return res.status(401).json({ success: false, error: 'Invalid token', code: 'TOKEN_INVALID' });
    }
    return res.status(500).json({ success: false, error: 'Authentication failed', code: 'AUTH_ERROR' });
  }
};

// Role-based authorization
const authorize = (roles = []) => (req, res, next) => {
  if (!req.user) {
    return res.status(401).json({ success: false, error: 'Authentication required', code: 'AUTH_REQUIRED' });
  }
  if (roles.length && !roles.includes(req.user.role)) {
    return res.status(403).json({
      success: false,
      error: `Access denied. Required roles: ${roles.join(', ')}`,
      code: 'INSUFFICIENT_PERMISSIONS'
    });
  }
  next();
};

const adminOnly = authorize(['admin']);
const driverOrAdmin = authorize(['driver', 'admin']);

module.exports = {
  authenticateToken,
  authorize,
  adminOnly,
  driverOrAdmin
};
