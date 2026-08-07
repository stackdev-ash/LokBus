const { Router } = require("express");
const router = Router();
const { getNearby, getByRoute , getDirections } = require("../controllers/queryController");

// Keep existing query routes for backward compatibility
router.get("/nearby", getNearby);
router.get("/route/:routeId", getByRoute);

// New route for getting directions to a bus station
router.get("/directions/:stationId", getDirections);

module.exports = router;