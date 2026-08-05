const Trip = require('../models/Trip');
const Bus  = require('../models/Bus');
const Route= require('../models/Route');
const User = require('../models/User');

class DriverController {
  static async assignBusToDriver(req, res) {
    try {
      const { driverId, busId, routeId } = req.body;
      if (!driverId||!busId||!routeId) {
        return res.status(400).json({ success:false, error:'driverId,busId,routeId required' });
      }
      const driver = await User.findById(driverId);
      if (!driver||driver.role!=='driver') {
        return res.status(404).json({ success:false, error:'Invalid driver' });
      }
      if (!await Bus.findById(busId)) {
        return res.status(404).json({ success:false, error:'Invalid bus' });
      }
      if (!await Route.findById(routeId)) {
        return res.status(404).json({ success:false, error:'Invalid route' });
      }
      if (await Trip.findOne({ driver:driverId, status:'ongoing' })) {
        return res.status(409).json({ success:false, error:'Driver busy' });
      }
      if (await Trip.findOne({ bus:busId, status:'ongoing' })) {
        return res.status(409).json({ success:false, error:'Bus in use' });
      }
      const trip = await Trip.create({ bus:busId, route:routeId, driver:driverId });
      await Bus.findByIdAndUpdate(busId,{ driver:driverId });
      const populated = await Trip.findById(trip._id)
        .populate('bus','regNo model')
        .populate('route','name code')
        .populate('driver','name phone');
      return res.status(201).json({ success:true, trip:populated });
    } catch(err) {
      console.error(err);
      return res.status(500).json({ success:false, error:'Server error' });
    }
  }

  static async getDriverAssignment(req, res) {
    try {
      const trip = await Trip.findOne({ driver:req.user.id, status:'ongoing' })
        .populate('bus','regNo model')
        .populate('route','name code stops.station');
      if (!trip) {
        return res.status(404).json({ success:false, error:'No active trip' });
      }
      return res.json({ success:true, assignment:trip });
    } catch(err) {
      console.error(err);
      return res.status(500).json({ success:false, error:'Server error' });
    }
  }

  static async endTrip(req, res) {
    try {
      const trip = await Trip.findOneAndUpdate(
        { driver:req.user.id, status:'ongoing' },
        { status:'finished', endedAt:new Date() },
        { new:true }
      );
      if (!trip) {
        return res.status(404).json({ success:false, error:'No active trip' });
      }
      await Bus.findByIdAndUpdate(trip.bus,{ $unset:{ driver:1 } });
      return res.json({ success:true, message:'Trip ended', trip });
    } catch(err) {
      console.error(err);
      return res.status(500).json({ success:false, error:'Server error' });
    }
  }

  static async listDrivers(req, res) {
    try {
      const drivers = await User.find({ role:'driver', isActive:true })
        .select('name phone createdAt');
      return res.json({ success:true, drivers });
    } catch(err) {
      console.error(err);
      return res.status(500).json({ success:false, error:'Server error' });
    }
  }
}

module.exports = DriverController;
