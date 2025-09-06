import 'dart:convert';

Show showFromJson(String str) => Show.fromJson(json.decode(str));

String showToJson(Show data) => json.encode(data.toJson());

class Show {
  int apiId;
  String name;
  String imageUrl;
  String summary;
  String premiered;

  String? ended;
  String? network;
  List<String>? genres;
  Show({
    required this.apiId,
    required this.name,
    required this.imageUrl,
    required this.summary,
    required this.premiered,

    this.ended,
    this.network,
    this.genres,
  });

  factory Show.fromJson(Map<String, dynamic> json) => Show(
    apiId: json["apiId"] ?? 0,
    name: json["name"] ?? '',
    imageUrl: json["imageUrl"] ?? '',
    summary: json["summary"] ?? '',
    premiered: json["premiered"] ?? '',

    ended: json["ended"] as String?,
    network: json["network"] as String?,
    genres: json["genres"] != null ? List<String>.from(json["genres"]) : [],
  );

  Map<String, dynamic> toJson() => {
    "apiId": apiId,
    "name": name,
    "imageUrl": imageUrl,
    "summary": summary,
    "premiered": premiered,

    "ended": ended,
    "network": network,
    "genres": genres,
  };

  bool get hasAllFields =>
      name.isNotEmpty &&
      imageUrl.isNotEmpty &&
      summary.isNotEmpty &&
      premiered.isNotEmpty;
}
