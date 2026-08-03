import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class AuthorityHome extends StatefulWidget {
  const AuthorityHome({super.key});

  @override
  State<AuthorityHome> createState() => _AuthorityHomeState();
}

class _AuthorityHomeState extends State<AuthorityHome> {
  // Dummy Stats (backend se later laa sakte ho)
  int totalBuses = 3;
  int activeTrips = 1;
  int drivers = 1;
  int users = 5;

  // Dummy bus markers (backend se replace karna h)
  final List<Map<String, dynamic>> buses = [
    {"id": "B1", "location": LatLng(28.6455, 77.3163)}, // Delhi
    {"id": "B2", "location": LatLng(30.9010, 75.8573)}, // Ludhiana
    {"id": "B3", "location": LatLng(30.7867, 75.4737)}, // Jagraon
  ];

  @override
  Widget build(BuildContext context) {
    const brandRed = Color(0xFF9E1C1C);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 🔹 Map showing buses
          FlutterMap(
            options: MapOptions(
              initialCenter: const LatLng(29.5, 76.5), // Punjab/Delhi center
              initialZoom: 6.5,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: buses
                    .map(
                      (bus) => Marker(
                        point: bus["location"],
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.directions_bus,
                          color: Colors.blue,
                          size: 30,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),

          // 🔹 Admin Dashboard (Draggable Bottom Sheet)
          DraggableScrollableSheet(
            initialChildSize: 0.35,
            minChildSize: 0.25,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
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
                padding: const EdgeInsets.all(16),
                child: ListView(
                  controller: scrollController,
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const Text(
                      "Admin Dashboard",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: brandRed,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 🔹 Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatCard(
                          "Total Buses",
                          totalBuses.toString(),
                          Icons.directions_bus,
                          Colors.blue,
                        ),
                        _buildStatCard(
                          "Active Trips",
                          activeTrips.toString(),
                          Icons.route,
                          Colors.green,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatCard(
                          "Drivers",
                          drivers.toString(),
                          Icons.person,
                          Colors.orange,
                        ),
                        _buildStatCard(
                          "Users",
                          users.toString(),
                          Icons.people,
                          Colors.purple,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // 🔹 Manage Section
                    const Text(
                      "Management",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: brandRed,
                      ),
                    ),
                    const SizedBox(height: 12),

                    _buildManageTile(
                      icon: Icons.directions_bus,
                      title: "Manage Buses",
                      subtitle: "Add, update, or remove buses",
                      color: Colors.blue,
                      onTap: () {},
                    ),
                    _buildManageTile(
                      icon: Icons.person,
                      title: "Manage Drivers",
                      subtitle: "Add or monitor drivers",
                      color: Colors.orange,
                      onTap: () {},
                    ),
                    _buildManageTile(
                      icon: Icons.route,
                      title: "Manage Routes",
                      subtitle: "Define or update routes",
                      color: Colors.green,
                      onTap: () {},
                    ),
                    _buildManageTile(
                      icon: Icons.analytics,
                      title: "Reports & Analytics",
                      subtitle: "View usage statistics",
                      color: Colors.purple,
                      onTap: () {},
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 30, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget _buildManageTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
