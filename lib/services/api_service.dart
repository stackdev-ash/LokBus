import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lokbus_clean/services/api_config.dart';
import 'package:lokbus_clean/utils/storage.dart';

class ApiService {
  /// -------------------------
  /// AUTH
  /// -------------------------

  static Future<Map<String, dynamic>> login(
    String phone,
    String password,
  ) async {
    final uri = ApiConfig.buildUri(ApiConfig.login);
    final body = jsonEncode({'phone': phone, 'password': password});

    final resp = await http
        .post(uri, headers: {'Content-Type': 'application/json'}, body: body)
        .timeout(const Duration(seconds: 30));

    if (_isSuccess(resp.statusCode)) {
      final decoded = jsonDecode(resp.body);

      if (decoded['token'] != null) {
        await SecureStorage.writeToken(decoded['token']);
      }
      if (decoded['user']?['role'] != null) {
        await SecureStorage.writeRole(decoded['user']['role']);
      }
      return decoded;
    } else {
      throw Exception(_errorMessage(resp, 'Login failed'));
    }
  }

  static Future<Map<String, dynamic>> registerPassenger(
    String name,
    String phone,
    String password,
  ) async {
    final uri = ApiConfig.buildUri(ApiConfig.register);
    final body = jsonEncode({
      'name': name,
      'phone': phone,
      'password': password,
      'role': 'user',
    });

    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (_isSuccess(resp.statusCode)) {
      return jsonDecode(resp.body);
    } else {
      throw Exception(_errorMessage(resp, 'Registration failed'));
    }
  }

  /// -------------------------
  /// TRIP MANAGEMENT
  /// -------------------------

  static Future<String> startTrip({
    required String busId,
    required String routeId,
    String? driverId,
  }) async {
    final token = await _getTokenOrThrow();
    final uri = ApiConfig.buildUri(ApiConfig.tripStart);

    final payload = {
      'busId': busId,
      'routeId': routeId,
      if (driverId != null) 'driverId': driverId,
    };

    final resp = await http.post(
      uri,
      headers: _authHeaders(token),
      body: jsonEncode(payload),
    );

    if (_isSuccess(resp.statusCode)) {
      final decoded = jsonDecode(resp.body);
      final tripId = decoded['tripId']?.toString();
      if (tripId == null || tripId.isEmpty) {
        throw Exception('Trip ID missing from response');
      }
      return tripId;
    } else {
      throw Exception(_errorMessage(resp, 'Failed to start trip'));
    }
  }

  static Future<void> endTrip(String tripId) async {
    final token = await _getTokenOrThrow();
    final uri = ApiConfig.buildUri("${ApiConfig.trips}/$tripId/end");

    final resp = await http.post(uri, headers: _authHeaders(token));

    if (!_isSuccess(resp.statusCode)) {
      throw Exception(_errorMessage(resp, 'Failed to end trip'));
    }
  }

  static Future<void> sendLocation(
    String tripId,
    double lat,
    double lng,
  ) async {
    final token = await _getTokenOrThrow();
    final uri = ApiConfig.buildUri("${ApiConfig.trips}/$tripId/location");

    final body = jsonEncode({
      'lat': lat,
      'lng': lng,
      'ts': DateTime.now().toIso8601String(),
    });

    final resp = await http.post(uri, headers: _authHeaders(token), body: body);

    if (!_isSuccess(resp.statusCode)) {
      throw Exception("Failed to send location: ${resp.body}");
    }
  }

  /// -------------------------
  /// PASSENGER FEATURES
  /// -------------------------

  static Future<List<Map<String, dynamic>>> getNearbyStations(
    double lat,
    double lng, {
    int radius = 20000,
  }) async {
    final token = await _getTokenOrThrow();
    final uri = ApiConfig.buildUri("${ApiConfig.query}/nearby", {
      "lng": "$lng", // backend expects lng first
      "lat": "$lat",
      "radius": "$radius",
    });

    final resp = await http.get(uri, headers: _authHeaders(token));

    if (_isSuccess(resp.statusCode)) {
      final decoded = jsonDecode(resp.body);
      if (decoded is Map && decoded['stations'] is List) {
        return List<Map<String, dynamic>>.from(decoded['stations']);
      }
      throw Exception("Invalid response format for nearby stations");
    } else {
      throw Exception(_errorMessage(resp, 'Failed to fetch nearby stations'));
    }
  }

  static Future<Map<String, dynamic>> getStationById(String stationId) async {
    final token = await _getTokenOrThrow();
    final uri = ApiConfig.buildUri("${ApiConfig.stations}/$stationId");

    final resp = await http.get(uri, headers: _authHeaders(token));

    if (_isSuccess(resp.statusCode)) {
      return jsonDecode(resp.body);
    } else {
      throw Exception("Failed to fetch station details: ${resp.body}");
    }
  }

  /// -------------------------
  /// ROUTES
  /// -------------------------

  static Future<Map<String, dynamic>> getTripsByRoute(String routeId) async {
    final token = await _getTokenOrThrow();
    final uri = ApiConfig.buildUri("${ApiConfig.query}/route/$routeId");

    final resp = await http.get(uri, headers: _authHeaders(token));

    if (_isSuccess(resp.statusCode)) {
      return jsonDecode(resp.body);
    } else {
      throw Exception(_errorMessage(resp, 'Failed to fetch trips by route'));
    }
  }

  static Future<List<Map<String, dynamic>>> planTrip({
    required String source,
    required String destination,
    required String date,
  }) async {
    final token = await _getTokenOrThrow();
    final uri = ApiConfig.buildUri("${ApiConfig.query}/plan", {
      "source": source,
      "destination": destination,
      "date": date,
    });

    final resp = await http.get(uri, headers: _authHeaders(token));

    if (_isSuccess(resp.statusCode)) {
      final decoded = jsonDecode(resp.body);
      if (decoded is List) {
        return List<Map<String, dynamic>>.from(decoded);
      }
      if (decoded is Map && decoded['routes'] is List) {
        return List<Map<String, dynamic>>.from(decoded['routes']);
      }
      throw Exception("Invalid response format for planTrip");
    } else {
      throw Exception(_errorMessage(resp, 'Failed to plan trip'));
    }
  }

  /// -------------------------
  /// DIRECTIONS (OSRM)
  /// -------------------------

  static Future<Map<String, dynamic>> getDirections(
    String stationId,
    double lat,
    double lng,
  ) async {
    final token = await _getTokenOrThrow();
    final uri = ApiConfig.buildUri("${ApiConfig.query}/directions/$stationId", {
      "lng": "$lng", // backend expects lng first
      "lat": "$lat",
    });

    final resp = await http.get(uri, headers: _authHeaders(token));

    if (_isSuccess(resp.statusCode)) {
      return jsonDecode(resp.body);
    } else {
      throw Exception(_errorMessage(resp, 'Failed to fetch directions'));
    }
  }

  /// -------------------------
  /// BUSES
  /// -------------------------

  static Future<List<Map<String, dynamic>>> getAvailableBuses() async {
    final token = await _getTokenOrThrow();
    final uri = ApiConfig.buildUri(ApiConfig.buses);

    final resp = await http.get(uri, headers: _authHeaders(token));

    if (_isSuccess(resp.statusCode)) {
      final decoded = jsonDecode(resp.body);
      return List<Map<String, dynamic>>.from(decoded['buses'] ?? []);
    } else {
      throw Exception(_errorMessage(resp, 'Failed to fetch buses'));
    }
  }

  /// -------------------------
  /// HELPERS
  /// -------------------------

  static Map<String, String> _authHeaders(String token) => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  static bool _isSuccess(int status) => status >= 200 && status < 300;

  static String _errorMessage(http.Response resp, String defaultMsg) {
    try {
      final decoded = jsonDecode(resp.body);
      if (decoded is Map && decoded['error'] != null) {
        return decoded['error'].toString();
      }
    } catch (_) {}
    return defaultMsg;
  }

  static Future<String> _getTokenOrThrow() async {
    final token = await SecureStorage.readToken();
    if (token == null || token.isEmpty) {
      throw Exception("No auth token found. Please login again.");
    }
    return token;
  }
}
