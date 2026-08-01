const mongoose = require("mongoose");

const RouteStopSchema = new mongoose.Schema({
  station: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: "BusStation", 
    required: true 
  },
  sequence: { 
    type: Number, 
    required: true 
  },
  distanceFromStart: { 
    type: Number, 
    default: 0 
  },
  estimatedTravelTime: { 
    type: Number, 
    default: 0 
  }, 
  fare: {
    regular: { type: Number, default: 0 },
    student: { type: Number, default: 0 },
    senior: { type: Number, default: 0 }
  }
}, { _id: false });

const RouteSchema = new mongoose.Schema({
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
  description: String,
  
  stops: [RouteStopSchema],
  
 
  totalDistance: { 
    type: Number, 
    required: true 
  }, 
  estimatedDuration: { 
    type: Number, 
    required: true 
  }, 
  
  
  operatingDays: [{
    type: String,
    enum: ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"],
    default: ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
  }],
  
  frequency: {
    peakHours: { 
      type: Number, 
      default: 15 
    }, 
    offPeakHours: { 
      type: Number, 
      default: 30 
    }
  },
  
  firstBus: { 
    type: String, 
    default: "06:00" 
  }, 
  lastBus: { 
    type: String, 
    default: "22:00" 
  },
  
  
  baseFare: {
    regular: { type: Number, required: true },
    student: { type: Number, required: true },
    senior: { type: Number, required: true }
  },
  
  farePerKm: {
    regular: { type: Number, default: 2 },
    student: { type: Number, default: 1 },
    senior: { type: Number, default: 1 }
  },
  
  polyline: String,
  
  // Status and metadata
  isActive: { type: Boolean, default: true },
  routeType: {
    type: String,
    enum: ["city", "intercity", "express", "local"],
    default: "city"
  },
  
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now }
});


RouteSchema.index({ name: "text", code: "text" });
RouteSchema.index({ "stops.station": 1 });
RouteSchema.index({ isActive: 1, routeType: 1 });

// Method to calculate fare between two stops
RouteSchema.methods.calculateFare = function(fromStopIndex, toStopIndex, passengerType = "regular") {
  if (fromStopIndex >= toStopIndex || fromStopIndex < 0 || toStopIndex >= this.stops.length) {
    throw new Error("Invalid stop indices");
  }
  
  const distance = this.stops[toStopIndex].distanceFromStart - this.stops[fromStopIndex].distanceFromStart;
  const baseFare = this.baseFare[passengerType] || this.baseFare.regular;
  const farePerKm = this.farePerKm[passengerType] || this.farePerKm.regular;
  
  return Math.max(baseFare, baseFare + (distance * farePerKm));
};

// Method to calculate ETA between two stops
RouteSchema.methods.calculateETA = function(fromStopIndex, toStopIndex) {
  if (fromStopIndex >= toStopIndex || fromStopIndex < 0 || toStopIndex >= this.stops.length) {
    throw new Error("Invalid stop indices");
  }
  
  return this.stops[toStopIndex].estimatedTravelTime - this.stops[fromStopIndex].estimatedTravelTime;
};

module.exports = mongoose.model("Route", RouteSchema);