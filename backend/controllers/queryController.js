const Trip = require("../models/Trip");
const Route = require("../models/Route");
const BusStation = require("../models/BusStation");
const axios = require('axios')

// Get all active bus stations near a point (lng, lat) within radius meters
async function getNearby(req, res) {
  try {
    const { lng, lat, radius = 1000 } = req.query;

    if (!lng || !lat) {
      return res.status(400).json({ error: "Longitude and latitude are required" });
    }
    const stations = await BusStation.find({
      isActive: true,
      location: {
        $nearSphere: {
          $geometry: {
            type: "Point",
            coordinates: [Number(lng), Number(lat)],
          },
          $maxDistance: parseInt(radius),
        },
      },
    }).select("name code location");

    res.json({ count: stations.length, stations });
  } catch (error) {
    console.error("Error getting nearby stations:", error);
    res.status(500).json({ error: "Server error" });
  }
}

// Get route directions to a specific bus station 
async function getDirections(req, res) {
  try {
    const { stationId } = req.params;
    const { lng, lat } = req.query;

    if (!lng || !lat) {
      return res.status(400).json({ error: "User latitude and longitude are required" });
    }

    const longitude = parseFloat(lng);
    const latitude = parseFloat(lat);

    if (latitude < -90 || latitude > 90 || longitude < -180 || longitude > 180) {
      return res.status(400).json({ error: "Invalid coordinates" });
    }

    const station = await BusStation.findById(stationId).select("name code location address");
    if (!station) {
      return res.status(404).json({ error: "Bus station not found" });
    }


    const osrmUrl = `https://router.project-osrm.org/route/v1/walking/${longitude},${latitude};${station.location.coordinates[0]},${station.location.coordinates[1]}`;

    const osrmParams = {
      overview: 'full',
      geometries: 'polyline',
      steps: 'true'
    };

    const response = await axios.get(osrmUrl, { params: osrmParams });

    if (!response.data.routes || response.data.routes.length === 0) {
      return res.status(400).json({ error: 'Could not calculate route' });
    }

    const route = response.data.routes[0];
    const leg = route.legs[0];

    // OSR response format 
    const routeData = {
      station: {
        id: station._id,
        name: station.name,
        code: station.code,
        location: station.location,
        address: station.address
      },
      route: {
        polyline: route.geometry,
        bounds: {},
        distance: {
          text: `${(route.distance / 1000).toFixed(2)} km`,
          value: route.distance
        },
        duration: {
          text: `${Math.ceil(route.duration / 60)} mins`,
          value: route.duration
        },
        startLocation: leg.summary,
        endLocation: null,
        steps: leg.steps.map(step => ({
          distance: { text: `${step.distance} meters`, value: step.distance },
          duration: { text: `${Math.ceil(step.duration)} sec`, value: step.duration },
          startLocation: step.maneuver.location,
          endLocation: null,
          instructions: `${step.maneuver.type} ${step.maneuver.modifier || ''}`.trim(),
          maneuver: step.maneuver.type || null,
          polyline: null,
          travelMode: 'walking'
        }))
      },
      requestedAt: new Date().toISOString()
    };

    return res.json(routeData);

    console.log(
      `OSRM route calculated: ${routeData.route.distance.text}, ${routeData.route.duration.text}`
    );

  } catch (error) {
    console.error("Error getting directions:", error);
    res.status(500).json({ error: "Server error" });
  }
}


// Basic list of ongoing trips by route
async function getByRoute(req, res) {
  try {
    const { routeId } = req.params;
    const trips = await Trip.find({ route: routeId, status: "ongoing" }).populate("bus driver");
    res.json({ trips });
  } catch (err) {
    console.error("Error in getByRoute:", err);
    res.status(500).json({ error: "Server error" });
  }
}

module.exports = { getNearby, getByRoute, getDirections };
