const mongoose = require("mongoose");

const BusStationSchema = new mongoose.Schema({
  name: { 
    type: String, 
    required: true,
    index: true 
  },
  code: { 
    type: String, 
    unique: true, 
    required: true,
    uppercase: true
  },
  location: {
    type: { type: String, default: "Point" },
    coordinates: { 
      type: [Number], 
      required: true,
      index: "2dsphere" 
    } 
  },
  address: {
    street: String,
    area: String,
    city: { type: String, required: true },
    state: String,
    pincode: String
  },
  facilities: [{
    type: String,
    enum: ["restroom", "food_court", "parking", "wifi", "waiting_area", "ticket_counter", "ATM"]
  }],
  operatingHours: {
    open: { type: String, default: "05:00" }, // 24-hour format
    close: { type: String, default: "23:00" }
  },
  isActive: { type: Boolean, default: true },
  routes: [{ 
    type: mongoose.Schema.Types.ObjectId, 
    ref: "Route" 
  }],
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now }
});

// Index for location-based queries
BusStationSchema.index({ location: "2dsphere" });

// Index for searching by name and city
BusStationSchema.index({ name: "text", "address.city": "text" });

module.exports = mongoose.model("BusStation", BusStationSchema);