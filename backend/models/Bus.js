const mongoose = require("mongoose");

const BusSchema = new mongoose.Schema({
    regNo: { type: String, required: true, unique: true },
    capacity: { type: Number, default: 30 },
    driver: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
    model: String,
    createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model("Bus", BusSchema);
