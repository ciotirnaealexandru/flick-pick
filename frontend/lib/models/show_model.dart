import 'dart:convert';

Show showFromJson(String str) => Show.fromJson(json.decode(str));

String showToJson(Show data) => json.encode(data.toJson());

class Show {
  int id;
  String name;
  String image;
  String summary;
  String? premiered;
  String? ended;

  Show({
    required this.id,
    required this.name,
    required this.image,
    required this.summary,
    this.premiered,
    this.ended,
  });

  factory Show.fromJson(Map<String, dynamic> json) => Show(
    id: json["id"] ?? 0,
    name: json["name"] ?? '',
    image: json["image"] ?? '',
    summary: json["summary"] ?? '',
    premiered: json["premiered"] as String?,
    ended: json["ended"] as String?,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "summary": summary,
    "premiered": premiered,
    "ended": ended,
  };

  bool get hasAllFields =>
      name.isNotEmpty && image.isNotEmpty && summary.isNotEmpty;
}
