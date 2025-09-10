import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/services/env_service.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

Future<User?> getUserInfo() async {
  final secureStorage = FlutterSecureStorage();
  final token = await secureStorage.read(key: "auth_token");

  final response = await http.get(
    Uri.parse('${EnvConfig.apiUrl}/user/me'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final userJson = json.decode(response.body);
    return User.fromJson(userJson);
  } else {
    return null;
  }
}
