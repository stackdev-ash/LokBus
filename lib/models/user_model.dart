class UserModel {
  final String id;
  final String name;
  final String phone;
  final String role;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      phone: json["phone"] ?? "",
      role: json["role"] ?? "user",
    );
  }
}
