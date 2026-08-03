import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:lokbus_clean/services/api_service.dart';

class RouteDetailPage extends StatefulWidget {
  final String routeId;
  final String routeName;

  const RouteDetailPage({
    super.key,
    required this.routeId,
    required this.routeName,
  });

  @override
  State<RouteDetailPage> createState() => _RouteDetailPageState();
}

class _RouteDetailPageState extends State<RouteDetailPage> {
  late Future<Map<String, dynamic>> _routeFuture;

  @override
  void initState() {
    super.initState();
    _routeFuture = ApiService.getTripsByRoute(widget.routeId);
  }

  @override
  Widget build(BuildContext context) {
    const brandRed = Color(0xFF8C1E1D);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7EF),
      appBar: AppBar(
        title: Text(
          widget.routeName,
          style: const TextStyle(color: brandRed, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _routeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final data = snapshot.data!;
          final stations = List<Map<String, dynamic>>.from(
            data['stations'] ?? [],
          );
          final points = stations
              .map(
                (s) => LatLng(
                  (s['lat'] as num).toDouble(),
                  (s['lng'] as num).toDouble(),
                ),
              )
              .toList();

          return Column(
            children: [
              /// 🔹 Map Section
              Expanded(
                flex: 2,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: points.isNotEmpty
                        ? points.first
                        : LatLng(30.9, 75.85),
                    initialZoom: 13,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      userAgentPackageName: "com.example.lokbus_clean",
                    ),
                    if (points.isNotEmpty)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: points,
                            color: brandRed,
                            strokeWidth: 4,
                          ),
                        ],
                      ),
                    MarkerLayer(
                      markers: stations.map((s) {
                        final lat = (s['lat'] as num).toDouble();
                        final lng = (s['lng'] as num).toDouble();
                        return Marker(
                          width: 40,
                          height: 40,
                          point: LatLng(lat, lng),
                          child: const Icon(
                            Icons.location_on,
                            color: brandRed,
                            size: 36,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              /// 🔹 Station List Section
              Expanded(
                flex: 1,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: ListView.separated(
                    itemCount: stations.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final station = stations[index];
                      return ListTile(
                        leading: const Icon(
                          Icons.directions_bus,
                          color: brandRed,
                        ),
                        title: Text(station['name'] ?? "Station"),
                        subtitle: Text(
                          "Lat: ${station['lat']}, Lng: ${station['lng']}",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
