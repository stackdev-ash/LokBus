import 'package:flutter/material.dart';
import 'package:lokbus_clean/pages/bus_schedule.dart';
import 'package:lokbus_clean/pages/live_tracking.dart';
import 'package:lokbus_clean/pages/nearby_station.dart';
import 'package:lokbus_clean/pages/trip_planner.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(60, 60),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/images/LokBus7.png'),
                backgroundColor: Colors.transparent,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "LokBus",
                    style: TextStyle(
                      color: Color(0xFF8C1E1D),
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  Text(
                    "Ride Easy, Arrive Happy",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          actions: const [
            Icon(Icons.settings, color: Colors.black87),
            SizedBox(width: 22),
            Icon(Icons.person, color: Colors.black87),
            SizedBox(width: 22),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_bus.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Welcome Card
                _buildWelcomeCard(),
          
                const SizedBox(height: 20),
          
                // Features List
                buildFeatureCard(
                  icon: Icons.location_pin,
                  title: "Trip Planner",
                  subtitle: "Plan your journey with multiple routes",
                  color: const Color(0xFF8C1E1D),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=> TripPlannerScreen())
                      );
                  },
                ),
                buildFeatureCard(
                  icon: Icons.near_me_outlined,
                  title: "Live Tracking",
                  subtitle: "Track your bus in real-time",
                  color: const Color(0xFF8C1E1D),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LiveTrackingPage(),
                      ),
                    );
                  },
                ),
                buildFeatureCard(
                  icon: Icons.event_note_outlined,
                  title: "Bus Schedule",
                  subtitle: "View timetables and schedules",
                  color: const Color(0xFF8C1E1D),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BusSchedulePage(),
                      ),
                    );
                  },
                ),
                buildFeatureCard(
                  icon: Icons.tune_outlined,
                  title: "Nearby Stations",
                  subtitle: "Find bus stops around you",
                  color: const Color(0xFF8C1E1D),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NearbyStationsPage(),
                      ),
                    );
                  },
                ),
          
                const SizedBox(height: 30),
          
                // Quick Actions
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8C1E1D),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TripPlannerScreen(),
                            ),
                          );
                        },
                        child: const Text("Plan Trip"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF8C1E1D),
                          side: const BorderSide(color: Color(0xFF8C1E1D)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {},
                        child: const Text("Track Bus"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 Welcome Card
  static Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26.withAlpha(40),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: const [
          Text(
            "Welcome to LokBus",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF8C1E1D),
              fontSize: 18,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "Your smart companion for bus travel. Track, plan, and travel with confidence.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  /// 🔹 Feature Card
  static Widget buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withAlpha(30),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withAlpha(30),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black45,
            ),
          ],
        ),
      ),
    );
  }
}
