const express = require('express');
const { authenticateToken, authorize } = require('../middlewares/auth');
const DriverController = require('../controllers/drivercontroller');
const router = express.Router();

// Admin-only
router.post('/assign', authenticateToken, authorize(['admin']), DriverController.assignBusToDriver);
router.get('/all',    authenticateToken, authorize(['admin']), DriverController.listDrivers);

// Driver-only
router.get('/assignment', authenticateToken, authorize(['driver']), DriverController.getDriverAssignment);
router.post('/end-trip',   authenticateToken, authorize(['driver']), DriverController.endTrip);

module.exports = router;
