<div align="center">

# 🚌 LokBus

### 🏆 Smart India Hackathon 2025 | Problem Statement **SIH25013**

### Real-Time Public Transport Tracking Platform for Tier-2 & Tier-3 Cities

A low-bandwidth, scalable public transport platform that enables commuters to track buses in real time, view accurate arrival estimates, plan journeys, and receive live updates—even in areas with limited internet connectivity.

![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)
![Express](https://img.shields.io/badge/Express-000000?style=for-the-badge&logo=express&logoColor=white)
![MongoDB](https://img.shields.io/badge/MongoDB-47A248?style=for-the-badge&logo=mongodb&logoColor=white)
![Socket.IO](https://img.shields.io/badge/Socket.IO-010101?style=for-the-badge&logo=socketdotio&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![JWT](https://img.shields.io/badge/JWT-000000?style=for-the-badge&logo=jsonwebtokens&logoColor=white)

</div>

---

# 📖 Overview

Public transportation in many Tier-2 and Tier-3 cities lacks reliable real-time information. Commuters often wait without knowing when the next bus will arrive, while transport authorities have limited visibility into fleet operations.

**LokBus** bridges this gap by providing:

- 📍 Live bus tracking
- ⏱️ Real-time ETA prediction
- 🗺️ Route & stop management
- 📶 Low-bandwidth optimized communication
- 🔄 Live updates using WebSockets
- 📱 Mobile-first experience
- 🌐 Offline-friendly trip planning

---

# 🏆 Smart India Hackathon 2025

LokBus was developed as a solution for **Smart India Hackathon (SIH) 2025** under the official problem statement:

**Problem Statement ID:** **SIH25013**

The project aims to improve the public transportation experience by providing passengers with real-time bus tracking, accurate arrival predictions, route information, and a seamless travel experience while ensuring efficient fleet monitoring for transport authorities.

---

# 👥 Team

| Member | Role |
|---------|------|
| [Ashish Sharma](https://github.com/stackdev-ash) | Backend Development • System Architecture |
| [Utkarsh Gupta](https://github.com/Utk4rxh) | Flutter Development |
| [Pakhi Tyagi](https://github.com/username) | UI/UX Design |
| [Naman Singhal](https://github.com/username) | Research, Documentation & Testing |

---

# 🎥 Project Demo

📺 **YouTube Demo**

> https://www.youtube.com/watch?v=fAcRjDcGX7M

📑 **Project Presentation**

> https://canva.link/4eueokf1fdqem40

---

# ✨ Features

## 👥 Passenger Features

- 📍 Live Bus Tracking
- ⏱️ Accurate ETA Prediction
- 🚌 Nearby Bus Stops
- 🗺️ Route Search
- 🚏 Trip Planning
- 📡 Live Bus Status
- 🌐 Offline Route Access
- ⭐ Favorite Routes
- 📶 Low Data Usage
- 📱 Responsive Mobile UI

---

## 🚌 Driver Features

- 📍 Live GPS Location Sharing
- ▶️ Start & End Trips
- 🛣️ Route Selection
- 🔄 Trip Status Updates

---

## 🛠️ Admin Features

- 🚌 Bus Management
- 🗺️ Route Management
- 🚏 Station Management
- 👨‍✈️ Driver Management
- 📍 Live Fleet Monitoring
- 📊 Dashboard Analytics

---

# 🚀 Tech Stack

## Frontend

- Flutter
- REST APIs
- Socket.IO Client

## Backend

- Node.js
- Express.js
- MongoDB
- Mongoose
- Socket.IO
- JWT Authentication
- bcrypt

## Services

- OSRM Routing API
- Cloudinary *(Optional)*
- Render

---

# 🏗️ System Architecture

```text
                    ┌──────────────────┐
                    │   Flutter App    │
                    └────────┬─────────┘
                             │
                   REST + Socket.IO
                             │
                    ┌────────▼────────┐
                    │ Express Server  │
                    └────────┬────────┘
          ┌──────────────────┼──────────────────┐
          │                  │                  │
     Authentication      Trip Service      Live Tracking
          │                  │                  │
          └──────────────────┼──────────────────┘
                             │
                       MongoDB Database
```

---

# 🔄 How Real-Time Tracking Works

1. Driver starts a trip and begins sharing GPS coordinates.
2. The backend receives location updates.
3. Smart validation filters unnecessary updates.
4. Important location changes are stored.
5. Live locations are broadcast through Socket.IO.
6. Connected passengers instantly receive updates.
7. ETA is recalculated dynamically based on the latest location.

---

# ⚡ Low-Bandwidth Optimization

LokBus is specifically designed for regions with unstable or slow internet connectivity.

### Optimizations

- Smart location throttling
- Distance-based database updates
- Reduced network requests
- Socket.IO instead of continuous polling
- Compressed payloads
- Cached route information
- Offline trip planning
- Efficient bandwidth utilization

---

# 📡 API Modules

### Authentication

- Register
- Login
- JWT Authentication

### Bus

- Create Bus
- Update Bus
- Delete Bus
- Get Bus Details

### Routes

- Route Management
- Stops
- Timings

### Trips

- Start Trip
- End Trip
- Current Trip
- ETA Calculation

### Live Tracking

- Driver Location Updates
- Passenger Tracking
- Live ETA

---

# 🔌 Socket Events

### Driver

```text
location-update
trip-start
trip-end
```

### Passenger

```text
join-trip
leave-trip
live-location
eta-update
```

---

# 🚀 Getting Started

## Clone Repository

```bash
git clone https://github.com/stackdev-ash/LokBus.git
```

## Backend

```bash
cd backend
npm install
npm run dev
```

## Frontend

```bash
cd frontend
flutter pub get
flutter run
```

---

# 🤝 Contributing

Contributions are always welcome.

1. Fork the repository.

2. Create a feature branch.

```bash
git checkout -b feature/NewFeature
```

3. Commit your changes.

```bash
git commit -m "Add New Feature"
```

4. Push to GitHub.

```bash
git push origin feature/NewFeature
```

5. Open a Pull Request.

---

<div align="center">

## ⭐ If you found this project helpful, consider giving it a star!

**Built with ❤️ for Smart India Hackathon 2025 to make public transportation smarter, faster, and more accessible.**

</div>