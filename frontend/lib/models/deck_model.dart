import 'dart:convert';
import 'package:frontend/models/user_show_model.dart';

Deck deckFromJson(String str) => Deck.fromJson(json.decode(str));

String deckToJson(Deck data) => json.encode(data.toJson());

class Deck {
  int id;
  String name;
  int userId;
  List<UserShow> userShows;

  Deck({
    required this.id,
    required this.name,
    required this.userId,
    required this.userShows,
  });

  factory Deck.fromJson(Map<String, dynamic> json) {
    List<UserShow> parsedShows = [];

    if (json["userShows"] is List) {
      parsedShows =
          (json["userShows"] as List)
              .map((userShowJson) => UserShow.fromJson(userShowJson))
              .toList();
    }

    return Deck(
      id: json["id"] as int,
      name: json["name"] ?? '',
      userId: json["id"] as int,
      userShows: parsedShows,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "userId": userId,
    "userShows": userShows,
  };
}
