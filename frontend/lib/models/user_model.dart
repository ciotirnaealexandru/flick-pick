import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  int id;
  String firstName;
  String lastName;
  String email;
  String? phone;
  String role;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phone,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    email: json["email"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    phone: json["phone"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "firstName": firstName,
    "lastName": lastName,
    "phone": phone,
    "role": role,
  };
}
