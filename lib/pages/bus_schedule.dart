import 'package:flutter/material.dart';

class BusSchedulePage extends StatelessWidget {
  const BusSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    const brandCardColor = Color(0xFFFBFCF3); 

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7EF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Bus Schedule",
          style: TextStyle(
            color: Color(0xFF8C1E1D),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildScheduleCard(
              busName: "Bus 101",
              route: "Ludhiana - Ambala - ISBT Delhi",
              time: "12:30 AM",
              color: brandCardColor,
            ),
            _buildScheduleCard(
              busName: "Bus 205",
              route: "Railway Station → Tech Park",
              time: "09:30 AM - 10:30 AM",
              color: brandCardColor,
            ),
            _buildScheduleCard(
              busName: "Bus 330",
              route: "Airport → Downtown",
              time: "11:00 AM - 12:15 PM",
              color: brandCardColor,
            ),
            _buildScheduleCard(
              busName: "Bus 410",
              route: "Market Road → Hospital",
              time: "12:30 PM - 01:15 PM",
              color: brandCardColor,
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Reusable Card
  Widget _buildScheduleCard({
    required String busName,
    required String route,
    required String time,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color, // 👈 same card color everywhere
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            busName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF8C1E1D),
            ),
          ),
          const SizedBox(height: 6),
          Text(route, style: const TextStyle(color: Colors.black87)),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.access_time, size: 18, color: Colors.black54),
              const SizedBox(width: 6),
              Text(time, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ],
      ),
    );
  }
}
