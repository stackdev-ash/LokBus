import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DriverHome extends StatefulWidget {
  const DriverHome({super.key});

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  static const brandRed = Color(0xFF9E1C1C);

  LatLng? _driverLocation;
  int _currentIndex = 0;
  Timer? _ticker;
  bool _tripActive = false;

  final String busId = "BUS101";

  // 🔹 Same route as Passenger side
  final List<LatLng> demoRoute = [
    LatLng(28.6570, 77.4464), // ABESIT
    LatLng(28.6545, 77.4400),
    LatLng(28.6520, 77.4330),
    LatLng(28.6485, 77.4250),
    LatLng(28.6450, 77.4180),
    LatLng(28.6420, 77.4100),
    LatLng(28.6400, 77.4020),
    LatLng(28.6380, 77.3950),
    LatLng(28.6360, 77.3850),
    LatLng(28.6345, 77.3785),
    LatLng(28.6339, 77.3728), // Sector 62
  ];

  void _startTrip() {
    if (_tripActive) return;
    setState(() {
      _tripActive = true;
      _currentIndex = 0;
    });

    _ticker = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentIndex >= demoRoute.length) {
        _stopTrip();
        return;
      }
      setState(() {
        _driverLocation = demoRoute[_currentIndex];
      });
      _currentIndex++;
    });
  }

  void _stopTrip() {
    _ticker?.cancel();
    _ticker = null;
    setState(() {
      _tripActive = false;
      _driverLocation = null; // reset bus marker
    });
  }

  @override
  void dispose() {
    _stopTrip();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 🔹 Map
          FlutterMap(
            options: MapOptions(
              initialCenter: demoRoute.first,
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: demoRoute,
                    strokeWidth: 4,
                    color: Colors.blue,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: demoRoute.first,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_on,
                      color: brandRed,
                      size: 30,
                    ),
                  ),
                  Marker(
                    point: demoRoute.last,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.flag,
                      color: Colors.green,
                      size: 30,
                    ),
                  ),
                  if (_driverLocation != null)
                    Marker(
                      point: _driverLocation!,
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.directions_bus,
                        color: Colors.orange,
                        size: 35,
                      ),
                    ),
                ],
              ),
            ],
          ),

          // 🔹 Bottom sheet
          DraggableScrollableSheet(
            initialChildSize: 0.25,
            minChildSize: 0.2,
            maxChildSize: 0.6,
            builder: (_, controller) => Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: ListView(
                controller: controller,
                children: [
                  const Text(
                    "Driver Dashboard",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: brandRed,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    leading: const Icon(Icons.directions_bus, color: brandRed),
                    title: Text("Bus No: $busId"),
                    subtitle: const Text("Route: ABESIT → Sector 62"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _tripActive ? null : _startTrip,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        icon: const Icon(Icons.play_arrow, color: Colors.white),
                        label: const Text(
                          "Start",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _tripActive ? _stopTrip : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        icon: const Icon(Icons.stop, color: Colors.white),
                        label: const Text(
                          "Stop",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
