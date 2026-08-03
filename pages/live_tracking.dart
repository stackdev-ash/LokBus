import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LiveTrackingPage extends StatefulWidget {
  const LiveTrackingPage({super.key});

  @override
  State<LiveTrackingPage> createState() => _LiveTrackingPageState();
}

class _LiveTrackingPageState extends State<LiveTrackingPage> {
  static const Color brandRed = Color(0xFF9E1C1C);

  LatLng? _busLocation;
  int _currentIndex = 0;

  // 🔹 ABESIT Ghaziabad → Noida Sector 62 (with multiple stops)
  final List<LatLng> routePolyline = [
    LatLng(28.6570, 77.4464), // ABESIT
    LatLng(28.6560, 77.4450),
    LatLng(28.6560, 77.4440),
    LatLng(28.6545, 77.4420),
    LatLng(28.6545, 77.4400),
    LatLng(28.6530, 77.4350),
    LatLng(28.6520, 77.4330),
    LatLng(28.6500, 77.4200),
    LatLng(28.6485, 77.4250),
    LatLng(28.6450, 77.4180),
    LatLng(28.6420, 77.4100),
    LatLng(28.6400, 77.4020),
    LatLng(28.6380, 77.3950),
    LatLng(28.6360, 77.3850),
    LatLng(28.6345, 77.3785),
    LatLng(28.6339, 77.3728), // Sector 62
  ];

  @override
  void initState() {
    super.initState();
    _startDummyMovement();
  }

  void _startDummyMovement() {
    Future.doWhile(() async {
      if (_currentIndex < routePolyline.length) {
        setState(() {
          _busLocation = routePolyline[_currentIndex];
        });
        _currentIndex++;
        await Future.delayed(const Duration(seconds: 6)); // move every 3 sec
        return true;
      }
      return false; // stop when last point reached
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Live Tracking",
          style: TextStyle(
            color: brandRed,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Stack(
        children: [
          // 🔹 Map
          FlutterMap(
            options: MapOptions(
              initialCenter: routePolyline.first,
              initialZoom: 14, // closer zoom for clarity
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
                    points: routePolyline,
                    strokeWidth: 4,
                    color: Colors.blue,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: routePolyline.first,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.flag,
                      color: Colors.green,
                      size: 30,
                    ),
                  ),
                  Marker(
                    point: routePolyline.last,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_on,
                      color: brandRed,
                      size: 30,
                    ),
                  ),
                  if (_busLocation != null)
                    Marker(
                      point: _busLocation!,
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

          // 🔹 Info Card (Bottom)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Bus Info",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: brandRed,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text("🚌 Bus No: PB10-1234"),
                  const Text("👨‍✈️ Driver: Rajesh Kumar"),
                  const Text("📍 Route: ABESIT → Sector 62"),
                  Text(
                    "📡 Status: ${_busLocation != null ? "Moving..." : "Waiting to start"}",
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
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
