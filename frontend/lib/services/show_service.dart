import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:frontend/models/show_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<Show?> getShowInfo({String? userId, String? apiId}) async {
  try {
    // get the bearer token
    final secureStorage = FlutterSecureStorage();
    final token = await secureStorage.read(
      key: dotenv.env['SECURE_STORAGE_SECRET']!,
    );

    // get the main info of the show
    final mainInfoResponse = await http.get(
      Uri.parse('${dotenv.env['API_URL']!}/show/more/$apiId'),
      headers: {'Content-Type': 'application/json'},
    );

    // if the main info search failed return nothing
    if (mainInfoResponse.statusCode != 200) return null;

    final mainInfoJson =
        json.decode(mainInfoResponse.body) as Map<String, dynamic>;
    print("⭐ MAIN JSON: $mainInfoJson");

    // make sure we include an user in the service, if not, return the main info
    if (userId == null) return Show.fromJson(mainInfoJson);

    // get the user info if it exists
    final userShowResponse = await http.get(
      Uri.parse('${dotenv.env['API_URL']!}/user/show/$userId/$apiId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    // if response failed return the main info
    if (userShowResponse.statusCode != 200) return Show.fromJson(mainInfoJson);

    // if the user has the show or the show exists return the full json
    final userShowJson =
        json.decode(userShowResponse.body) as Map<String, dynamic>;
    ;
    final finalJson = {...mainInfoJson, ...userShowJson};

    debugPrint("🏁 FINAL JSON: $finalJson", wrapWidth: 1024);
    return Show.fromJson(finalJson);
  } catch (error) {
    print("Error in show service: $error");
    return null;
  }
}
