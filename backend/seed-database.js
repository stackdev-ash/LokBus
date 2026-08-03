const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
require('dotenv').config();

// Import models
const BusStation = require('./models/BusStation');
const Route = require('./models/Route');
const Bus = require('./models/Bus');
const User = require('./models/User');
const Trip = require('./models/Trip');

async function seedLudhianaDatabase() {
  try {
    await mongoose.connect(process.env.MONGO_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true
    });

    console.log('🔗 Connected to MongoDB');

    // Clear existing data
    console.log('🗑️  Clearing existing data...');
    await Promise.all([
      BusStation.deleteMany({}),
      Route.deleteMany({}),
      Bus.deleteMany({}),
      User.deleteMany({}),
      Trip.deleteMany({})
    ]);

    // Create Bus Stations in Ludhiana
    console.log('🚏 Creating bus stations...');
    const busStationsData = [
      {
        name: "Amar Shaheed Sukhdev Interstate Bus Terminal",
        code: "ASBT001",
        location: {
          type: "Point",
          coordinates: [75.8573, 30.9010]
        },
        address: {
          street: "NH 95, Jawahar Nagar",
          area: "Sham Nagar",
          city: "Ludhiana",
          state: "Punjab",
          pincode: "141003"
        },
        facilities: ["restroom", "food_court", "parking", "wifi", "waiting_area", "ticket_counter", "ATM"],
        operatingHours: { open: "05:00", close: "23:30" }
      },
      {
        name: "Ludhiana City Bus Stand",
        code: "LCBS002",
        location: {
          type: "Point",
          coordinates: [75.8520, 30.9050]
        },
        address: {
          street: "Sham Nagar Road",
          area: "Sham Nagar",
          city: "Ludhiana",
          state: "Punjab",
          pincode: "141003"
        },
        facilities: ["restroom", "parking", "waiting_area", "ticket_counter"],
        operatingHours: { open: "05:30", close: "22:30" }
      },
      {
        name: "Clock Tower Chowk",
        code: "CTC003",
        location: {
          type: "Point",
          coordinates: [75.8463, 30.9010]
        },
        address: {
          street: "Mall Road",
          area: "Civil Lines",
          city: "Ludhiana",
          state: "Punjab",
          pincode: "141001"
        },
        facilities: ["parking", "waiting_area"],
        operatingHours: { open: "06:00", close: "22:00" }
      },
      {
        name: "Sherpur Chowk",
        code: "SPC004",
        location: {
          type: "Point",
          coordinates: [75.8423, 30.9180]
        },
        address: {
          street: "Dhandari Kalan Road",
          area: "Dhandari Kalan",
          city: "Ludhiana",
          state: "Punjab",
          pincode: "141014"
        },
        facilities: ["restroom", "parking", "waiting_area"],
        operatingHours: { open: "05:45", close: "22:15" }
      },
      {
        name: "PAU Gate",
        code: "PAU005",
        location: {
          type: "Point",
          coordinates: [75.8047, 30.9030]
        },
        address: {
          street: "Ferozepur Road",
          area: "Punjab Agricultural University",
          city: "Ludhiana",
          state: "Punjab",
          pincode: "141004"
        },
        facilities: ["restroom", "parking", "waiting_area", "wifi"],
        operatingHours: { open: "05:30", close: "23:00" }
      },
      {
        name: "Ghumar Mandi",
        code: "GM006",
        location: {
          type: "Point",
          coordinates: [75.8542, 30.9080]
        },
        address: {
          street: "Ghumar Mandi Road",
          area: "Ghumar Mandi",
          city: "Ludhiana",
          state: "Punjab",
          pincode: "141008"
        },
        facilities: ["restroom", "waiting_area"],
        operatingHours: { open: "06:00", close: "21:30" }
      },
      {
        name: "Samrala Chowk",
        code: "SC007",
        location: {
          type: "Point",
          coordinates: [75.9120, 30.8350]
        },
        address: {
          street: "Ludhiana-Samrala Road",
          area: "Samrala",
          city: "Ludhiana",
          state: "Punjab",
          pincode: "141114"
        },
        facilities: ["restroom", "parking", "waiting_area", "food_court"],
        operatingHours: { open: "05:30", close: "22:45" }
      },
      {
        name: "Khanna Bus Stand",
        code: "KBS008",
        location: {
          type: "Point",
          coordinates: [76.2220, 30.7058]
        },
        address: {
          street: "Grand Trunk Road",
          area: "Khanna",
          city: "Ludhiana",
          state: "Punjab",
          pincode: "141401"
        },
        facilities: ["restroom", "food_court", "parking", "waiting_area", "ticket_counter"],
        operatingHours: { open: "05:00", close: "23:15" }
      },
      {
        name: "Jagraon Bus Stand",
        code: "JBS009",
        location: {
          type: "Point",
          coordinates: [75.4737, 30.7867]
        },
        address: {
          street: "Jagraon-Ludhiana Road",
          area: "Jagraon",
          city: "Ludhiana",
          state: "Punjab",
          pincode: "142026"
        },
        facilities: ["restroom", "parking", "waiting_area", "ticket_counter"],
        operatingHours: { open: "05:15", close: "22:30" }
      },
      {
        name: "Doraha Bus Stand",
        code: "DBS010",
        location: {
          type: "Point",
          coordinates: [76.0220, 30.8020]
        },
        address: {
          street: "Doraha Main Road",
          area: "Doraha",
          city: "Ludhiana",
          state: "Punjab",
          pincode: "141421"
        },
        facilities: ["restroom", "parking", "waiting_area"],
        operatingHours: { open: "05:45", close: "22:00" }
      },
      {
        name: "Raikot Bus Stand",
        code: "RBS011",
        location: {
          type: "Point",
          coordinates: [75.5970, 30.6520]
        },
        address: {
          street: "Raikot Main Road",
          area: "Raikot",
          city: "Ludhiana",
          state: "Punjab",
          pincode: "142050"
        },
        facilities: ["restroom", "parking", "waiting_area", "food_court"],
        operatingHours: { open: "05:30", close: "22:15" }
      },
      {
        name: "Payal Bus Stand",
        code: "PBS012",
        location: {
          type: "Point",
          coordinates: [75.5665, 30.9030]
        },
        address: {
          street: "Payal Main Road",
          area: "Payal",
          city: "Ludhiana",
          state: "Punjab",
          pincode: "142022"
        },
        facilities: ["restroom", "parking", "waiting_area"],
        operatingHours: { open: "05:45", close: "21:45" }
      },
      {
        name: "BRS Nagar",
        code: "BRS013",
        location: {
          type: "Point",
          coordinates: [75.8380, 30.8820]
        },
        address: {
          street: "BRS Nagar Road",
          area: "BRS Nagar",
          city: "Ludhiana",
          state: "Punjab",
          pincode: "141012"
        },
        facilities: ["parking", "waiting_area"],
        operatingHours: { open: "06:00", close: "22:00" }
      },
      {
        name: "Dugri Phase 1",
        code: "DGR014",
        location: {
          type: "Point",
          coordinates: [75.8680, 30.8750]
        },
        address: {
          street: "Dugri Road",
          area: "Dugri",
          city: "Ludhiana",
          state: "Punjab",
          pincode: "141013"
        },
        facilities: ["parking", "waiting_area"],
        operatingHours: { open: "06:00", close: "21:30" }
      },
      {
        name: "Model Town Extension",
        code: "MTE015",
        location: {
          type: "Point",
          coordinates: [75.8420, 30.9120]
        },
        address: {
          street: "Model Town Road",
          area: "Model Town",
          city: "Ludhiana",
          state: "Punjab",
          pincode: "141002"
        },
        facilities: ["parking", "waiting_area"],
        operatingHours: { open: "06:00", close: "21:45" }
      },
      // New: Noida Sector-62
      {
        name: "Noida Sector-62 Bus Station",
        code: "NS62001",
        location: { type: "Point", coordinates: [77.3728, 28.6339] },
        address: {
          street: "Sector 62 Road",
          area: "Sector 62",
          city: "Noida",
          state: "Uttar Pradesh",
          pincode: "201307"
        },
        facilities: ["restroom", "parking", "waiting_area", "ticket_counter", "food_court"],
        operatingHours: { open: "05:30", close: "23:00" }
      },
      // New: Anand Vihar Bus Adda
      {
        name: "Anand Vihar ISBT",
        code: "AVB002",
        location: { type: "Point", coordinates: [77.3163, 28.6455] },
        address: {
          street: "NH 24",
          area: "Anand Vihar",
          city: "Delhi",
          state: "Delhi",
          pincode: "110092"
        },
        facilities: ["restroom", "parking", "waiting_area", "ticket_counter", "ATM", "food_court"],
        operatingHours: { open: "05:00", close: "00:00" }
      },
      // New: ABESIT Ghaziabad
      {
        name: "ABESIT Ghaziabad Bus Stop",
        code: "AGB003",
        location: { type: "Point", coordinates: [77.4464, 28.6570] },
        address: {
          street: "NH 9",
          area: "Ghaziabad",
          city: "Ghaziabad",
          state: "Uttar Pradesh",
          pincode: "201009"
        },
        facilities: ["restroom", "parking", "waiting_area"],
        operatingHours: { open: "06:00", close: "22:00" }
      }
    ];

    const createdStations = await BusStation.insertMany(busStationsData);
    console.log(`✅ Created ${createdStations.length} bus stations`);

    // Create Users (Admin, Drivers, Regular Users)
    console.log('👥 Creating users...');
    const users = [
      {
        name: "Harpreet Singh",
        phone: "9876543210",
        passwordHash: await bcrypt.hash("Admin@2024", 14),
        role: "admin"
      },
      {
        name: "Rajinder Kaur",
        phone: "9876543211",
        passwordHash: await bcrypt.hash("Driver@123", 14),
        role: "driver"
      },
      {
        name: "Manpreet Singh",
        phone: "9876543212",
        passwordHash: await bcrypt.hash("Driver@123", 14),
        role: "driver"
      },
      {
        name: "Simran Kaur",
        phone: "9876543213",
        passwordHash: await bcrypt.hash("Driver@123", 14),
        role: "driver"
      },
      {
        name: "Jasbir Singh",
        phone: "9876543214",
        passwordHash: await bcrypt.hash("Driver@123", 14),
        role: "driver"
      },
      {
        name: "Priya Sharma",
        phone: "9876543215",
        passwordHash: await bcrypt.hash("User@123", 14),
        role: "user"
      },
      {
        name: "Rahul Kumar",
        phone: "9876543216",
        passwordHash: await bcrypt.hash("User@123", 14),
        role: "user"
      },
      {
        name: "Neha Gupta",
        phone: "9876543217",
        passwordHash: await bcrypt.hash("User@123", 14),
        role: "user"
      },
      {
        name: "Amit Singh",
        phone: "9876543218",
        passwordHash: await bcrypt.hash("User@123", 14),
        role: "user"
      },
      {
        name: "Pooja Kumari",
        phone: "9876543219",
        passwordHash: await bcrypt.hash("User@123", 14),
        role: "user"
      }
    ];

    const createdUsers = await User.insertMany(users);
    console.log(`✅ Created ${createdUsers.length} users`);

    // Create Bus Fleet
    console.log('🚌 Creating bus fleet...');
    const drivers = createdUsers.filter(user => user.role === 'driver');
    const busModels = ["Ashok Leyland Viking", "Tata Starbus", "Eicher Skyline", "Mahindra Tourister", "Force Traveller"];
    const pbCodes = ["PB10", "PB91", "PB55"]; // Ludhiana RTO codes

    const buses = [];
    for (let i = 0; i < 25; i++) {
      const pbCode = pbCodes[i % pbCodes.length];
      const regNumber = `${pbCode} ${1000 + i} A`;

      buses.push({
        regNo: regNumber,
        model: busModels[i % busModels.length],
        capacity: [30, 35, 40, 45, 50][i % 5],
        driver: i < drivers.length ? drivers[i]._id : null
      });
    }

    const createdBuses = await Bus.insertMany(buses);
    console.log(`✅ Created ${createdBuses.length} buses`);

    // Create Routes
    console.log('🛣️  Creating routes...');
    const routesData = [
      {
        name: "City Center Circuit",
        code: "CCC001",
        description: "Connects major city center locations including Clock Tower and PAU",
        routeType: "city",
        operatingDays: ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"],
        firstBus: "05:30",
        lastBus: "23:00",
        frequency: { peakHours: 10, offPeakHours: 15 },
        baseFare: { regular: 15, student: 10, senior: 8 },
        farePerKm: { regular: 3, student: 2, senior: 2 },
        totalDistance: 12.5,
        estimatedDuration: 45,
        stops: [
          {
            station: createdStations.find(s => s.code === 'CTC003')._id,
            sequence: 1,
            distanceFromStart: 0,
            estimatedTravelTime: 0,
            fare: { regular: 0, student: 0, senior: 0 }
          },
          {
            station: createdStations.find(s => s.code === 'GM006')._id,
            sequence: 2,
            distanceFromStart: 2.1,
            estimatedTravelTime: 8,
            fare: { regular: 15, student: 10, senior: 8 }
          },
          {
            station: createdStations.find(s => s.code === 'ASBT001')._id,
            sequence: 3,
            distanceFromStart: 4.5,
            estimatedTravelTime: 15,
            fare: { regular: 20, student: 12, senior: 10 }
          },
          {
            station: createdStations.find(s => s.code === 'PAU005')._id,
            sequence: 4,
            distanceFromStart: 8.2,
            estimatedTravelTime: 28,
            fare: { regular: 30, student: 20, senior: 15 }
          },
          {
            station: createdStations.find(s => s.code === 'DGR014')._id,
            sequence: 5,
            distanceFromStart: 10.8,
            estimatedTravelTime: 38,
            fare: { regular: 35, student: 25, senior: 18 }
          },
          {
            station: createdStations.find(s => s.code === 'BRS013')._id,
            sequence: 6,
            distanceFromStart: 12.5,
            estimatedTravelTime: 45,
            fare: { regular: 40, student: 28, senior: 20 }
          }
        ]
      },
      {
        name: "ISBT to Mall Road Express",
        code: "IME002",
        description: "Direct route from Interstate Bus Terminal to Mall Road area",
        routeType: "express",
        operatingDays: ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"],
        firstBus: "06:00",
        lastBus: "22:30",
        frequency: { peakHours: 12, offPeakHours: 20 },
        baseFare: { regular: 12, student: 8, senior: 6 },
        farePerKm: { regular: 2.5, student: 1.5, senior: 1.5 },
        totalDistance: 8.2,
        estimatedDuration: 30,
        stops: [
          {
            station: createdStations.find(s => s.code === 'ASBT001')._id,
            sequence: 1,
            distanceFromStart: 0,
            estimatedTravelTime: 0,
            fare: { regular: 0, student: 0, senior: 0 }
          },
          {
            station: createdStations.find(s => s.code === 'GM006')._id,
            sequence: 2,
            distanceFromStart: 2.8,
            estimatedTravelTime: 10,
            fare: { regular: 12, student: 8, senior: 6 }
          },
          {
            station: createdStations.find(s => s.code === 'CTC003')._id,
            sequence: 3,
            distanceFromStart: 5.5,
            estimatedTravelTime: 20,
            fare: { regular: 18, student: 12, senior: 9 }
          },
          {
            station: createdStations.find(s => s.code === 'MTE015')._id,
            sequence: 4,
            distanceFromStart: 8.2,
            estimatedTravelTime: 30,
            fare: { regular: 25, student: 15, senior: 12 }
          }
        ]
      },
      {
        name: "Outer Ring Route",
        code: "ORR003",
        description: "Covers outer areas including Samrala, Khanna, and Doraha",
        routeType: "city",
        operatingDays: ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"],
        firstBus: "05:45",
        lastBus: "22:45",
        frequency: { peakHours: 15, offPeakHours: 25 },
        baseFare: { regular: 20, student: 15, senior: 12 },
        farePerKm: { regular: 4, student: 3, senior: 2.5 },
        totalDistance: 35.8,
        estimatedDuration: 90,
        stops: [
          {
            station: createdStations.find(s => s.code === 'ASBT001')._id,
            sequence: 1,
            distanceFromStart: 0,
            estimatedTravelTime: 0,
            fare: { regular: 0, student: 0, senior: 0 }
          },
          {
            station: createdStations.find(s => s.code === 'SC007')._id,
            sequence: 2,
            distanceFromStart: 8.5,
            estimatedTravelTime: 25,
            fare: { regular: 25, student: 18, senior: 15 }
          },
          {
            station: createdStations.find(s => s.code === 'DBS010')._id,
            sequence: 3,
            distanceFromStart: 18.2,
            estimatedTravelTime: 45,
            fare: { regular: 40, student: 30, senior: 25 }
          },
          {
            station: createdStations.find(s => s.code === 'KBS008')._id,
            sequence: 4,
            distanceFromStart: 28.5,
            estimatedTravelTime: 70,
            fare: { regular: 55, student: 40, senior: 32 }
          },
          {
            station: createdStations.find(s => s.code === 'JBS009')._id,
            sequence: 5,
            distanceFromStart: 35.8,
            estimatedTravelTime: 90,
            fare: { regular: 70, student: 50, senior: 40 }
          }
        ]
      },
      {
        name: "Industrial Area Shuttle",
        code: "IAS004",
        description: "Connects industrial areas with residential zones",
        routeType: "local",
        operatingDays: ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday"],
        firstBus: "06:00",
        lastBus: "21:00",
        frequency: { peakHours: 20, offPeakHours: 30 },
        baseFare: { regular: 10, student: 7, senior: 5 },
        farePerKm: { regular: 2, student: 1.5, senior: 1 },
        totalDistance: 15.3,
        estimatedDuration: 50,
        stops: [
          {
            station: createdStations.find(s => s.code === 'SPC004')._id,
            sequence: 1,
            distanceFromStart: 0,
            estimatedTravelTime: 0,
            fare: { regular: 0, student: 0, senior: 0 }
          },
          {
            station: createdStations.find(s => s.code === 'GM006')._id,
            sequence: 2,
            distanceFromStart: 4.2,
            estimatedTravelTime: 15,
            fare: { regular: 10, student: 7, senior: 5 }
          },
          {
            station: createdStations.find(s => s.code === 'LCBS002')._id,
            sequence: 3,
            distanceFromStart: 8.8,
            estimatedTravelTime: 30,
            fare: { regular: 18, student: 12, senior: 9 }
          },
          {
            station: createdStations.find(s => s.code === 'PBS012')._id,
            sequence: 4,
            distanceFromStart: 15.3,
            estimatedTravelTime: 50,
            fare: { regular: 25, student: 18, senior: 15 }
          }
        ]
      },
      {
        name: "University Connect",
        code: "UC005",
        description: "Connects PAU with various city points",
        routeType: "city",
        operatingDays: ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"],
        firstBus: "05:30",
        lastBus: "23:30",
        frequency: { peakHours: 8, offPeakHours: 12 },
        baseFare: { regular: 8, student: 5, senior: 4 },
        farePerKm: { regular: 2, student: 1, senior: 1 },
        totalDistance: 18.7,
        estimatedDuration: 55,
        stops: [
          {
            station: createdStations.find(s => s.code === 'PAU005')._id,
            sequence: 1,
            distanceFromStart: 0,
            estimatedTravelTime: 0,
            fare: { regular: 0, student: 0, senior: 0 }
          },
          {
            station: createdStations.find(s => s.code === 'CTC003')._id,
            sequence: 2,
            distanceFromStart: 5.2,
            estimatedTravelTime: 18,
            fare: { regular: 12, student: 8, senior: 6 }
          },
          {
            station: createdStations.find(s => s.code === 'BRS013')._id,
            sequence: 3,
            distanceFromStart: 9.8,
            estimatedTravelTime: 32,
            fare: { regular: 18, student: 12, senior: 9 }
          },
          {
            station: createdStations.find(s => s.code === 'DGR014')._id,
            sequence: 4,
            distanceFromStart: 12.5,
            estimatedTravelTime: 42,
            fare: { regular: 22, student: 15, senior: 12 }
          },
          {
            station: createdStations.find(s => s.code === 'RBS011')._id,
            sequence: 5,
            distanceFromStart: 18.7,
            estimatedTravelTime: 55,
            fare: { regular: 30, student: 20, senior: 15 }
          }
        ]
      }
    ];

    const createdRoutes = await Route.insertMany(routesData);
    console.log(`✅ Created ${createdRoutes.length} routes`);

    // Create some active trips
    console.log('🚌 Creating active trips...');
    const activeTrips = [
      {
        bus: createdBuses[0]._id,
        route: createdRoutes[0]._id,
        driver: drivers[0]._id,
        status: "ongoing",
        startedAt: new Date(Date.now() - 30 * 60 * 1000), // Started 30 minutes ago
        lastLocation: {
          type: "Point",
          coordinates: [75.8500, 30.9020] // Somewhere along the route
        },
        locations: [
          {
            ts: new Date(Date.now() - 30 * 60 * 1000),
            coords: { type: "Point", coordinates: [75.8463, 30.9010] },
            speed: 0,
            bearing: 90
          },
          {
            ts: new Date(Date.now() - 25 * 60 * 1000),
            coords: { type: "Point", coordinates: [75.8480, 30.9015] },
            speed: 25,
            bearing: 95
          },
          {
            ts: new Date(Date.now() - 20 * 60 * 1000),
            coords: { type: "Point", coordinates: [75.8500, 30.9020] },
            speed: 30,
            bearing: 90
          }
        ]
      },
      {
        bus: createdBuses[1]._id,
        route: createdRoutes[1]._id,
        driver: drivers[1]._id,
        status: "ongoing",
        startedAt: new Date(Date.now() - 45 * 60 * 1000), // Started 45 minutes ago
        lastLocation: {
          type: "Point",
          coordinates: [75.8550, 30.9070]
        },
        locations: [
          {
            ts: new Date(Date.now() - 45 * 60 * 1000),
            coords: { type: "Point", coordinates: [75.8573, 30.9010] },
            speed: 0,
            bearing: 270
          },
          {
            ts: new Date(Date.now() - 40 * 60 * 1000),
            coords: { type: "Point", coordinates: [75.8555, 30.9040] },
            speed: 28,
            bearing: 275
          },
          {
            ts: new Date(Date.now() - 35 * 60 * 1000),
            coords: { type: "Point", coordinates: [75.8550, 30.9070] },
            speed: 22,
            bearing: 280
          }
        ]
      }
    ];

    const createdTrips = await Trip.insertMany(activeTrips);
    console.log(`✅ Created ${createdTrips.length} active trips`);

    console.log('\n🎉 Database seeding completed successfully!');
    console.log('\n📊 Summary:');
    console.log(`   • ${createdStations.length} Bus Stations in Ludhiana`);
    console.log(`   • ${createdRoutes.length} Bus Routes`);
    console.log(`   • ${createdBuses.length} Buses with Punjab registration`);
    console.log(`   • ${createdUsers.length} Users (1 Admin, 4 Drivers, 5 Regular Users)`);
    console.log(`   • ${createdTrips.length} Active Trips`);
    console.log('\n🔑 Test Credentials:');
    console.log('   Admin: Phone: 9876543210, Password: Admin@2024');
    console.log('   Driver: Phone: 9876543211, Password: Driver@123');
    console.log('   User: Phone: 9876543215, Password: User@123');

    await mongoose.connection.close();
    console.log('\n🔐 Database connection closed');

  } catch (error) {
    console.error('❌ Error seeding database:', error);
    await mongoose.connection.close();
    process.exit(1);
  }
}

// Run the seeding function
seedLudhianaDatabase();