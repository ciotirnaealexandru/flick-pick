import 'dart:convert';
import 'package:frontend/models/show_model.dart';

UserShow userShowFromJson(String str) => UserShow.fromJson(json.decode(str));

String userShowToJson(UserShow data) => json.encode(data.toJson());

class UserShow {
  int? id;
  int? userRating;
  int? userId;
  int? showId;
  int? deckId;

  Show show;

  UserShow({
    this.id,
    this.userRating,
    this.userId,
    this.showId,
    this.deckId,

    required this.show,
  });

  factory UserShow.fromJson(Map<String, dynamic> json) => UserShow(
    id: json["id"] as int?,
    userRating: json["userRating"] as int?,
    userId: json["userId"] as int?,
    showId: json["showId"] as int?,
    deckId: json["deckId"] as int?,

    show:
        json["show"] != null
            ? Show.fromJson(json["show"] as Map<String, dynamic>)
            : throw Exception("Missing 'show' in UserShow JSON"),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userRating": userRating,
    "userId": userId,
    "showId": showId,
    "deckId": deckId,

    "show": show.toJson(),
  };
}
