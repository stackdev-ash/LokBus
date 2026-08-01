const mongoose = require("mongoose");

const LocationSchema = new mongoose.Schema({
  ts: { type: Date, default: Date.now },
  coords: {
    type: { type: String, enum: ["Point"] },
    coordinates: { type: [Number] }
  },
  speed: Number,
  bearing: Number
}, { _id: false });

const TripSchema = new mongoose.Schema({
  bus:    { type: mongoose.Schema.Types.ObjectId, ref: "Bus",   required: true, index: true },
  route:  { type: mongoose.Schema.Types.ObjectId, ref: "Route", required: true, index: true },
  driver: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
  startedAt: { type: Date, default: Date.now },
  endedAt:   Date,
  status:    { type: String, enum: ["ongoing","finished"], default: "ongoing", index: true },
  
  // No defaults here—lastLocation remains undefined until set in your controller
  lastLocation: {
    type: { type: String, enum: ["Point"] },
    coordinates: { type: [Number] } // [lng, lat]
  },

  locations: [LocationSchema]
}, { timestamps: true });

// Sparse 2dsphere index: only indexes docs that have lastLocation.coordinates
TripSchema.index({ lastLocation: "2dsphere" }, { sparse: true });

module.exports = mongoose.model("Trip", TripSchema);
