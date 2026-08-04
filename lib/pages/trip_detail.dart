import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class OfflineTripPlannerScreen extends StatefulWidget {
  final String source;
  final String destination;

  const OfflineTripPlannerScreen({
    super.key,
    required this.source,
    required this.destination,
  });

  @override
  State<OfflineTripPlannerScreen> createState() =>
      _OfflineTripPlannerScreenState();
}

class _OfflineTripPlannerScreenState extends State<OfflineTripPlannerScreen> {
  Map<String, dynamic>? _route;
  List<LatLng> _polyline = [];
  List<String> _stops = [];

  @override
  void initState() {
    super.initState();
    _loadRoute();
  }

  Future<void> _loadRoute() async {
    final jsonStr = await rootBundle.loadString("assets/data/routes.json");
    final data = json.decode(jsonStr);

    final allRoutes = List<Map<String, dynamic>>.from(data["routes"]);

    // Filter route that contains both source & destination
    final matched = allRoutes.firstWhere((route) {
      final stops = List<String>.from(route["stops"]);
      return stops.contains(widget.source) &&
          stops.contains(widget.destination);
    }, orElse: () => {});

    if (matched.isNotEmpty) {
      final coords = List<List<dynamic>>.from(matched["polyline"]);
      final polyline = coords
          .map((c) => LatLng(c[1].toDouble(), c[0].toDouble()))
          .toList();

      setState(() {
        _route = matched;
        _polyline = polyline;
        _stops = List<String>.from(matched["stops"]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const brandRed = Color(0xFF9E1C1C);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7EF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Trip Details",
          style: TextStyle(color: brandRed, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: _route == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 🔹 Map
                Expanded(
                  flex: 2,
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: _polyline.isNotEmpty
                          ? _polyline.first
                          : const LatLng(28.6339, 77.3728),
                      initialZoom: 7,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: const ['a', 'b', 'c'],
                      ),
                      if (_polyline.isNotEmpty)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: _polyline,
                              strokeWidth: 4,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      // 🔹 Stops Markers
                      MarkerLayer(
                        markers: [
                          for (int i = 0; i < _polyline.length; i++)
                            Marker(
                              point: _polyline[i],
                              width: 40,
                              height: 40,
                              child: Icon(
                                i == 0
                                    ? Icons.trip_origin
                                    : i == _polyline.length - 1
                                    ? Icons.flag
                                    : Icons.location_on,
                                color: i == 0
                                    ? Colors.green
                                    : i == _polyline.length - 1
                                    ? brandRed
                                    : Colors.grey,
                                size: 28,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 🔹 Info Box with Stops
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, -3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Route Name
                        Text(
                          _route!["name"] ?? "Unnamed Route",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: brandRed,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Distance, Duration, Fare
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Distance: ${_route!["distance_km"]} km"),
                            Text("Duration: ${_route!["duration_min"]} min"),
                            Text("Fare: ₹${_route!["fare"]}"),
                          ],
                        ),
                        const Divider(height: 20, thickness: 1),

                        // Stops
                        const Text(
                          "Stops",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Expanded(
                          child: ListView.builder(
                            itemCount: _stops.length,
                            itemBuilder: (context, index) {
                              final stop = _stops[index];
                              return ListTile(
                                dense: true,
                                leading: Icon(
                                  index == 0
                                      ? Icons.trip_origin
                                      : index == _stops.length - 1
                                      ? Icons.flag
                                      : Icons.location_on,
                                  color: index == 0
                                      ? Colors.green
                                      : index == _stops.length - 1
                                      ? brandRed
                                      : Colors.grey,
                                ),
                                title: Text(stop),
                              );
                            },
                          ),
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
