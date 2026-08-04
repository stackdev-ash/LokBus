import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:lokbus_clean/services/api_service.dart';
import 'package:geolocator/geolocator.dart';
import 'direction_page.dart';

class StationDetailPage extends StatefulWidget {
  final Map<String, dynamic> station;

  const StationDetailPage({super.key, required this.station});

  @override
  State<StationDetailPage> createState() => _StationDetailPageState();
}

class _StationDetailPageState extends State<StationDetailPage> {
  Map<String, dynamic>? _stationDetails;
  bool _loading = true;
  bool _loadingRoute = false;

  @override
  void initState() {
    super.initState();
    _fetchStationDetails();
  }

  Future<void> _fetchStationDetails() async {
    try {
      final details = await ApiService.getStationById(widget.station["_id"]);
      setState(() {
        _stationDetails = details;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠️ Failed to load station details: $e")),
        );
      }
    }
  }

  Future<void> _openDirectionsPage() async {
    try {
      setState(() => _loadingRoute = true);

      Position pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
        ),
      );

      final directions = await ApiService.getDirections(
        widget.station["_id"],
        pos.latitude, // ✅ lat first
        pos.longitude, // ✅ lng second
      );

      List<LatLng> routePoints = [];
      if (directions["route"]?["geometry"]?["coordinates"] != null) {
        final coords = directions["route"]["geometry"]["coordinates"];
        routePoints = coords
            .map<LatLng>((c) => LatLng(c[1].toDouble(), c[0].toDouble()))
            .toList();
      }

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DirectionPage(
              routeDetails: directions,
              routePoints: routePoints,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠️ Failed to fetch directions: $e")),
        );
      }
    } finally {
      setState(() => _loadingRoute = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const brandRed = Color(0xFF8C1E1D);

    return Scaffold(
      body: Stack(
        children: [
          if (_stationDetails?["location"]?["coordinates"] != null)
            FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(
                  _stationDetails!["location"]["coordinates"][1],
                  _stationDetails!["location"]["coordinates"][0],
                ),
                initialZoom: 13,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 60,
                      height: 60,
                      point: LatLng(
                        _stationDetails!["location"]["coordinates"][1],
                        _stationDetails!["location"]["coordinates"][0],
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: brandRed,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            )
          else if (_loading)
            const Center(child: CircularProgressIndicator())
          else
            const Center(child: Text("❌ No station details found")),

          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.2,
            maxChildSize: 0.8,
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
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 50,
                          height: 5,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      Text(
                        widget.station["name"] ?? "Station Detail",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: brandRed,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Address / Facilities / Hours
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_stationDetails?["address"] != null) ...[
                              const Text(
                                "📍 Address",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                [
                                      _stationDetails!["address"]["street"],
                                      _stationDetails!["address"]["area"],
                                      _stationDetails!["address"]["city"],
                                      _stationDetails!["address"]["state"],
                                      _stationDetails!["address"]["pincode"],
                                    ]
                                    .where(
                                      (e) =>
                                          e != null && e.toString().isNotEmpty,
                                    )
                                    .join(", "),
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 10),
                            ],
                            if ((_stationDetails?["facilities"] ?? [])
                                .isNotEmpty) ...[
                              const Text(
                                "🏢 Facilities",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: List<Widget>.from(
                                  (_stationDetails!["facilities"] as List).map(
                                    (f) => Chip(
                                      label: Text(
                                        f.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      backgroundColor: brandRed,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                            if (_stationDetails?["operatingHours"] != null) ...[
                              const Text(
                                "🕒 Operating Hours",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "Open: ${_stationDetails!["operatingHours"]["open"] ?? "--"} - Close: ${_stationDetails!["operatingHours"]["close"] ?? "--"}",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      Center(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: brandRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          icon: _loadingRoute
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(
                                  Icons.directions,
                                  color: Colors.white,
                                ),
                          label: Text(
                            _loadingRoute ? "Fetching..." : "Get Directions",
                            style: const TextStyle(color: Colors.white),
                          ),
                          onPressed: _loadingRoute ? null : _openDirectionsPage,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

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
