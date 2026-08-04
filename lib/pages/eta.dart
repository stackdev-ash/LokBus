import 'package:flutter/material.dart';

class EtaPage extends StatelessWidget {
  const EtaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7EF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "ETA Tracker",
          style: TextStyle(
            color: Color(0xFF8C1E1D),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(20),
          child: Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Real-time bus tracking",
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _infoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "🚌  LB-101 - Express Route",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8C1E1D),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("From: Chandigarh"), Text("To: Ludhiana")],
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Next Stop: Mohali Bus Stand",
                    style: TextStyle(color: Color(0xFF8C1E1D)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            _infoCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("⏰ Estimated Arrival"),
                  Text(
                    "1 mins",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF8C1E1D),
                    ),
                  ),
                ],
              ),
              footer: "Last updated: 12:10:36",
            ),

            const SizedBox(height: 16),
            _infoCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("🚦 Current Speed"),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Text(
                        "33 km/h",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Moderate", style: TextStyle(color: Colors.orange)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            _infoCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [Text("📏 Distance Remaining"), Text("0.0 km")],
              ),
              footer: "Total Distance: 24.3 km",
            ),

            const SizedBox(height: 16),
            _infoCard(
              child: Row(
                children: const [
                  Icon(Icons.location_on, color: Color(0xFF8C1E1D)),
                  SizedBox(width: 10),
                  Expanded(child: Text("Approaching Mohali Bus Stand")),
                  Icon(Icons.circle, size: 12, color: Colors.green),
                ],
              ),
              footer: "Bus is on schedule",
            ),

            const SizedBox(height: 16),
            _infoCard(
              child: Row(
                children: const [
                  Icon(Icons.warning_amber_rounded, color: Colors.orange),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Traffic Alert: Moderate traffic ahead may add 2-3 minutes to ETA",
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable card widget
  static Widget _infoCard({required Widget child, String? footer}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          child,
          if (footer != null) ...[
            const SizedBox(height: 6),
            Text(
              footer,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ],
      ),
    );
  }
}
