import 'dart:convert';

import 'package:frontend/models/show_model.dart';

Deck deckFromJson(String str) => Deck.fromJson(json.decode(str));

String deckToJson(Deck data) => json.encode(data.toJson());

class Deck {
  int id;

  String name;
  List<Show> userShows;

  Deck({required this.id, required this.name, required this.userShows});

  factory Deck.fromJson(Map<String, dynamic> json) {
    List<Show> parsedShows = [];

    if (json["userShows"] is List) {
      parsedShows =
          (json["userShows"] as List)
              .map((userShow) {
                final showJson = userShow["show"];
                if (showJson is Map<String, dynamic>) {
                  return Show.fromJson(showJson);
                }
                return null;
              })
              .whereType<Show>()
              .toList();
    }

    return Deck(
      id: json["id"] as int,
      name: json["name"] ?? '',
      userShows: parsedShows,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "userShows": userShows,
  };
}
