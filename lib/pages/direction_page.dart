import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DirectionPage extends StatelessWidget {
  final Map<String, dynamic> routeDetails;
  final List<LatLng> routePoints;

  const DirectionPage({
    super.key,
    required this.routeDetails,
    required this.routePoints,
  });

  @override
  Widget build(BuildContext context) {
    const brandRed = Color(0xFF8C1E1D);

    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Full screen map
          FlutterMap(
            options: MapOptions(
              initialCenter: routePoints.isNotEmpty
                  ? routePoints.first
                  : const LatLng(0, 0),
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
              ),
              if (routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: routePoints,
                      strokeWidth: 4,
                      color: Colors.blue,
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  if (routePoints.isNotEmpty)
                    Marker(
                      point: routePoints.first,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.green,
                        size: 30,
                      ),
                    ),
                  if (routePoints.isNotEmpty)
                    Marker(
                      point: routePoints.last,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_on,
                        color: brandRed,
                        size: 30,
                      ),
                    ),
                ],
              ),
            ],
          ),

          // 🔹 Bottom Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.25,
            minChildSize: 0.2,
            maxChildSize: 0.4,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: ListView(
                  controller: scrollController,
                  children: [
                    // Drag handle
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    // 🔹 Route Info Box
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Route Info",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: brandRed,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Distance: ${routeDetails["route"]["distance"]["text"]}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              "Duration: ${routeDetails["route"]["duration"]["text"]}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // 🔹 Back button overlay
          SafeArea(
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
