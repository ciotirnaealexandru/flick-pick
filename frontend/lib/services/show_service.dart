import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:frontend/models/show_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<Show?> getShowInfo({String? userId, required String apiId}) async {
  try {
    // get the bearer token
    final secureStorage = FlutterSecureStorage();
    final token = await secureStorage.read(
      key: dotenv.env['SECURE_STORAGE_SECRET']!,
    );

    // get the main info of the show
    final mainInfoResponse = await http.get(
      Uri.parse('${dotenv.env['API_URL']!}/show/external/$apiId'),
      headers: {'Content-Type': 'application/json'},
    );

    // if the main info search failed return nothing
    if (mainInfoResponse.statusCode != 200) return null;

    // see if the show exists in my database
    final mainInfoJson =
        json.decode(mainInfoResponse.body) as Map<String, dynamic>;
    print("⭐ MAIN JSON: $mainInfoJson");

    final showRespose = await http.get(
      Uri.parse('${dotenv.env['API_URL']!}/show/$apiId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    // if the show does not exist return the main info
    if (showRespose.statusCode != 200) return Show.fromJson(mainInfoJson);

    // make sure we include an user in the service, if not, return the main info
    if (userId == null) return Show.fromJson(mainInfoJson);

    // if the show exists in the database check if the current user has it
    final showJson = json.decode(showRespose.body);
    print("🎬 SHOW JSON: $showJson");
    final showId = showJson['id'] as int;
    final userShowResponse = await http.get(
      Uri.parse('${dotenv.env['API_URL']!}/user/show/$userId/$showId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    // if the current user does not have it return the main info
    if (userShowResponse.statusCode != 200) return Show.fromJson(mainInfoJson);

    // if the user has it concatenate the info to the main and return that
    final userShowJson =
        json.decode(userShowResponse.body) as Map<String, dynamic>;
    print("🙋 USER SHOW JSON: $userShowJson");
    final mergedJson = {...mainInfoJson, ...userShowJson};

    // remove createdAt, updatedAt, and the id (of userShow)
    final finalJson =
        Map.from(mergedJson)
          ..remove('createdAt')
          ..remove('updatedAt')
          ..remove('id');
    debugPrint("🏁 FINAL JSON: $finalJson", wrapWidth: 1024);
    return Show.fromJson(mergedJson);
  } catch (error) {
    print("Error in show service: $error");
    return null;
  }
}
