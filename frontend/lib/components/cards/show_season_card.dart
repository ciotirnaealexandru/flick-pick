import 'package:flutter/material.dart';

class ShowSeasonCard extends StatelessWidget {
  final String? showId;

  const ShowSeasonCard({super.key, required this.showId});

  @override
  Widget build(BuildContext context) {
    return Column(children: [Text("$showId")]);
  }
}
