class RouteModel {
  final String id;
  final String name;
  final String description;

  RouteModel({required this.id, required this.name, required this.description});

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      description: json["description"] ?? "",
    );
  }
}
