import 'dart:convert';
import 'package:frontend/models/show_model.dart';

UserShow userShowFromJson(String str) => UserShow.fromJson(json.decode(str));

String userShowToJson(UserShow data) => json.encode(data.toJson());

class UserShow {
  int? id;
  int? userRating;
  int? userId;
  int? showId;
  List<int>? selectedDeckIds;
  DateTime? updatedAt;

  Show show;

  UserShow({
    this.id,
    this.userRating,
    this.userId,
    this.showId,
    this.selectedDeckIds,
    this.updatedAt,

    required this.show,
  });

  factory UserShow.fromJson(Map<String, dynamic> json) => UserShow(
    id: json["id"] as int?,
    userRating: json["userRating"] as int?,
    userId: json["userId"] as int?,
    showId: json["showId"] as int?,
    selectedDeckIds:
        (json["selectedDeckIds"] as List<dynamic>?)
            ?.map((e) => e as int)
            .toList(),
    updatedAt:
        json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"] as String)
            : null,

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
    "selectedDeckIds": selectedDeckIds,

    "show": show.toJson(),
  };
}
