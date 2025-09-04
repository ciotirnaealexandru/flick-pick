import 'dart:convert';
import 'package:frontend/models/show_model.dart';
import 'package:frontend/models/user_show_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<UserShow?> getShowInfo({int? userId, int? apiId}) async {
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

    // make sure we include an user in the service, if not, return the main info
    if (userId == null) return UserShow(show: Show.fromJson(mainInfoJson));
    ;

    // get the user info if it exists
    final userShowResponse = await http.get(
      Uri.parse('${dotenv.env['API_URL']!}/user/show/$userId/$apiId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    // if response failed return the main info
    if (userShowResponse.statusCode != 200)
      return UserShow(show: Show.fromJson(mainInfoJson));

    final userShowJson =
        json.decode(userShowResponse.body) as Map<String, dynamic>;

    return (UserShow(
      id: userShowJson['id'] as int?,
      userRating: userShowJson['userRating'] as int?,
      userId: userShowJson['userId'] as int?,
      showId: userShowJson['showId'] as int?,
      deckId: userShowJson['deckId'] as int?,
      show: Show.fromJson(mainInfoJson),
    ));
  } catch (error) {
    print("Error in show service: $error");
    return null;
  }
}
