class StationModel {
  final String id;
  final String name;
  final double lat;
  final double lng;

  StationModel({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
  });

  factory StationModel.fromJson(Map<String, dynamic> json) {
    return StationModel(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      lat: (json["location"]["coordinates"][1] as num).toDouble(),
      lng: (json["location"]["coordinates"][0] as num).toDouble(),
    );
  }
}
