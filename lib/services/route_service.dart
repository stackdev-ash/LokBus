import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class RouteService {
  static Map<String, dynamic>? _routes;

  /// Load routes.json only once (cache result)
  static Future<Map<String, dynamic>> loadRoutes() async {
    if (_routes == null) {
      final jsonStr = await rootBundle.loadString("assets/data/routes.json");
      _routes = json.decode(jsonStr);
    }
    return _routes!;
  }

  /// Find a route by source & destination
  static Map<String, dynamic>? findRoute(String source, String destination) {
    if (_routes == null) return null;

    final allRoutes = List<Map<String, dynamic>>.from(_routes!["routes"]);
    return allRoutes.firstWhere((route) {
      final stops = List<String>.from(route["stops"]);
      return stops.contains(source) && stops.contains(destination);
    }, orElse: () => {});
  }
}
