import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class TripPlannerScreen extends StatefulWidget {
  const TripPlannerScreen({super.key});

  @override
  State<TripPlannerScreen> createState() => _TripPlannerScreenState();
}

class _TripPlannerScreenState extends State<TripPlannerScreen> {
  static const Color brandRed = Color(0xFF9E1C1C);
  static const Color offWhite = Color(0xFFF8F3E9);

  bool _loading = false;
  List<Map<String, dynamic>> _routes = [];
  List<Map<String, dynamic>> _stations = [];

  String? _selectedStart;
  String? _selectedDest;

  @override
  void initState() {
    super.initState();
    _loadStations();
  }

  Future<void> _loadStations() async {
    try {
      final jsonStr = await rootBundle.loadString("assets/data/stations.json");
      final data = json.decode(jsonStr);
      setState(() {
        _stations = List<Map<String, dynamic>>.from(data["stations"]);
      });
    } catch (e) {
      debugPrint("⚠️ Error loading stations.json: $e");
    }
  }

  Future<void> _searchRoutes() async {
    if (_selectedStart == null || _selectedDest == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select both start and destination stations"),
        ),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final jsonStr = await rootBundle.loadString("assets/data/routes.json");
      final data = json.decode(jsonStr);
      final allRoutes = List<Map<String, dynamic>>.from(data["routes"]);

      final filtered = allRoutes.where((route) {
        final stops = List<String>.from(route["stops"]);
        return stops.contains(_selectedStart) && stops.contains(_selectedDest);
      }).toList();

      setState(() => _routes = filtered);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: offWhite,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Trip Planner (Offline)',
          style: TextStyle(
            color: brandRed,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg_bus.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Search Box
                Container(
                  width: 420,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 18,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.location_on, color: brandRed),
                          SizedBox(width: 8),
                          Text(
                            'Plan Your Trip',
                            style: TextStyle(
                              color: brandRed,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Select stations to find routes (offline)',
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                      const SizedBox(height: 22),

                      // 🔹 Start Dropdown
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        initialValue: _selectedStart,
                        hint: const Text("Select starting station"),
                        items: _stations
                            .map(
                              (s) => DropdownMenuItem<String>(
                                value: s["code"],
                                child: Text(
                                  "${s["name"]} (${s["code"]})",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (val) =>
                            setState(() => _selectedStart = val),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.location_on_outlined),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 🔹 Destination Dropdown
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        initialValue: _selectedDest,
                        hint: const Text("Select destination station"),
                        items: _stations
                            .map(
                              (s) => DropdownMenuItem<String>(
                                value: s["code"],
                                child: Text(
                                  "${s["name"]} (${s["code"]})",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (val) => setState(() => _selectedDest = val),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.flag_outlined),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 🔹 Search Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: brandRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          onPressed: _loading ? null : _searchRoutes,
                          icon: _loading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.search, color: Colors.white),
                          label: const Text(
                            'Search Routes',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // 🔹 Results inline render
                if (_routes.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _routes.map((route) {
                      final stops = List<String>.from(route["stops"]);
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Colors.white,
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                route["name"] ?? "Unnamed Route",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: brandRed,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Distance: ${route["distance_km"]} km",
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                "Duration: ${route["duration_min"]} min",
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                "Fare: ₹${route["fare"]}",
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "Stops:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // ✅ Improved timeline using IntrinsicHeight so lines align
                              Column(
                                children: List.generate(stops.length, (index) {
                                  final stop = stops[index];
                                  final isFirst = index == 0;
                                  final isLast = index == stops.length - 1;

                                  return IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        // timeline column (fixed width)
                                        SizedBox(
                                          width: 36,
                                          child: Column(
                                            children: [
                                              // top connector
                                              Expanded(
                                                child: Container(
                                                  width: 2,
                                                  color: isFirst
                                                      ? Colors.transparent
                                                      : Colors.grey.shade400,
                                                ),
                                              ),

                                              // icon (centered)
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 4,
                                                    ),
                                                child: Icon(
                                                  isFirst
                                                      ? Icons.location_on
                                                      : isLast
                                                      ? Icons.flag
                                                      : Icons.circle,
                                                  color: isFirst
                                                      ? Colors.green
                                                      : isLast
                                                      ? Colors.red
                                                      : Colors.grey,
                                                  size: isFirst || isLast
                                                      ? 20
                                                      : 8,
                                                ),
                                              ),

                                              // bottom connector
                                              Expanded(
                                                child: Container(
                                                  width: 2,
                                                  color: isLast
                                                      ? Colors.transparent
                                                      : Colors.grey.shade400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(width: 12),

                                        // stop text
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              top: 4.0,
                                            ),
                                            child: Text(
                                              stop,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
