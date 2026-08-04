class ApiConfig {
  /// Base URL (change IP if network changes)
  static const String baseUrl = "http://192.168.1.145:8000";
  static const String login = "/auth/login";
  static const String register = "/auth/register";
  static const String nearbyStations = "/query/nearby";
  static const String routes = "/query/route";
  static const String buses = "/query/buses";
  static const String trips = "/trips";
  static const String tripStart = "/trips/start";
  static const String query = "/query";
  static const String stations = "/stations";
  static const String directions = "/query/directions";

  /// Build full URI
  static Uri buildUri(String path, [Map<String, String>? params]) {
    final uri = Uri.parse("$baseUrl$path");
    return params != null ? uri.replace(queryParameters: params) : uri;
  }
}

/*cd /Users/utkarshsmac/lokbus_clean/lokbus_clean_backend
npm run dev*/
