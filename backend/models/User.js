const mongoose = require("mongoose");
const bcrypt = require("bcryptjs");

const UserSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true,
    maxlength: 50,
    match: /^[a-zA-Z\s]+$/ 
  },
  phone: {
    type: String,
    required: true,
    unique: true,
    match: /^[6-9]\d{9}$/, 
    index: true
  },
  passwordHash: {
    type: String,
    required: true,
    minlength: 60
  },
  role: {
    type: String,
    enum: ["driver", "user", "admin"],
    default: "user",
    index: true
  },
  isActive: {
    type: Boolean,
    default: true,
    index: true
  },
  lastLogin: {
    type: Date,
    default: null
  },
  loginAttempts: {
    type: Number,
    default: 0
  },
  lockUntil: {
    type: Date,
    default: null
  },
  createdAt: {
    type: Date,
    default: Date.now,
    index: true
  },
  updatedAt: {
    type: Date,
    default: Date.now
  }
}, {
  timestamps: true
});

UserSchema.virtual("isLocked").get(function() {
  return !!(this.lockUntil && this.lockUntil > Date.now());
});


UserSchema.pre("save", function(next) {
  this.updatedAt = new Date();
  next();
});


UserSchema.methods.comparePassword = function(password) {
  return bcrypt.compare(password, this.passwordHash);
};


UserSchema.methods.incLoginAttempts = function() {
  const MAX_ATTEMPTS = 5;
  const LOCK_DURATION = 10 * 60 * 1000;

  if (this.lockUntil && this.lockUntil < Date.now()) {
    return this.updateOne({
      $unset: { loginAttempts: 1, lockUntil: 1 }
    });
  }

  const updateOps = { $inc: { loginAttempts: 1 } };
  if (this.loginAttempts + 1 >= MAX_ATTEMPTS && !this.isLocked) {
    updateOps.$set = { lockUntil: Date.now() + LOCK_DURATION };
  }
  return this.updateOne(updateOps);
};

UserSchema.methods.resetLoginAttempts = function() {
  return this.updateOne({
    $unset: { loginAttempts: 1, lockUntil: 1 },
    $set: { lastLogin: new Date() }
  });
};


UserSchema.statics.findActive = function() {
  return this.find({ isActive: true });
};

UserSchema.statics.findByRole = function(role) {
  return this.find({ role, isActive: true });
};


UserSchema.methods.toSafeObject = function() {
  const obj = this.toObject();
  delete obj.passwordHash;
  delete obj.loginAttempts;
  delete obj.lockUntil;
  return obj;
};

UserSchema.statics.cleanupExpiredLocks = function() {
  return this.updateMany(
    { lockUntil: { $lt: Date.now() } },
    { $unset: { loginAttempts: 1, lockUntil: 1 } }
  );
};

module.exports = mongoose.model("User", UserSchema);
