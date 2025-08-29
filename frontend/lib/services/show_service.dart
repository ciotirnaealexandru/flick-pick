import 'dart:convert';
import 'package:frontend/models/show_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<Show?> getShowInfo(showId) async {
  final response = await http.get(
    Uri.parse('${dotenv.env['API_URL']!}/show/$showId'),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    final userJson = json.decode(response.body);
    return Show.fromJson(userJson);
  } else {
    return null;
  }
}
