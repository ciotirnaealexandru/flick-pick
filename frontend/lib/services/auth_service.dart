import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/user_model.dart';

Future<User?> getUserInfo() async {
  final secureStorage = FlutterSecureStorage();
  final token = await secureStorage.read(
    key: dotenv.env['SECURE_STORAGE_SECRET']!,
  );

  final response = await http.get(
    Uri.parse('${dotenv.env['API_URL']!}/user/me'),
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
