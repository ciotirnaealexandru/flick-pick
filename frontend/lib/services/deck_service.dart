import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/models/deck_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/services/env_service.dart';
import 'package:frontend/services/user_service.dart';
import 'package:http/http.dart' as http;

Future<List<Deck>?> getDecksInfo({int? userId}) async {
  final secureStorage = FlutterSecureStorage();
  final token = await secureStorage.read(key: "auth_token");

  // get the deck info if it exists
  final decksResponse = await http.get(
    Uri.parse('${EnvConfig.apiUrl}/user/deck/all/$userId'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (decksResponse.statusCode == 200) {
    final List<dynamic> decksJson = json.decode(decksResponse.body);
    final List<Deck> decks =
        decksJson.map((json) => Deck.fromJson(json)).toList();

    return decks;
  } else {
    return null;
  }
}

/*
Future<Deck?> getFullDeckInfo({required int userId}) async {
  try {
    final secureStorage = FlutterSecureStorage();
    final token = await secureStorage.read(key: "auth_token");

    final showsResponse = await http.get(
      Uri.parse('${EnvConfig.apiUrl}/user/show/all/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (showsResponse.statusCode != 200) {
      return Deck(
        id: 0,
        name: "All Shows",
        userId: userId,
        userShows: [],
        createdAt: DateTime(2025, 1, 1),
      );
    }

    final List<dynamic> showsJson = jsonDecode(showsResponse.body);
    final List<UserShow> shows =
        showsJson
            .map((json) => UserShow.fromJson(json as Map<String, dynamic>))
            .toList();

    return Deck(
      id: 0,
      name: "All Shows",
      userId: userId,
      userShows: shows,
      createdAt: DateTime(2025, 1, 1),
    );
  } catch (error) {
    print("Error fetching full deck: $error");
    return null;
  }
}
*/

Future<void> createDefaultDecks() async {
  try {
    final secureStorage = FlutterSecureStorage();
    final token = await secureStorage.read(key: "auth_token");

    User? userInfo = await getUserInfo();

    final createWatchedDeckResponse = await http.post(
      Uri.parse('${EnvConfig.apiUrl}/user/deck/${userInfo?.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'deckName': "Watched"}),
    );

    if (createWatchedDeckResponse.statusCode != 200) {
      print("Response body: ${createWatchedDeckResponse.body}");
    }

    final createWantToWatchDeckResponse = await http.post(
      Uri.parse('${EnvConfig.apiUrl}/user/deck/${userInfo?.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'deckName': "Want to Watch"}),
    );

    if (createWantToWatchDeckResponse.statusCode != 200) {
      print("Response body: ${createWantToWatchDeckResponse.body}");
    }
  } catch (error) {
    print("Error fetching full deck: $error");
  }
}
