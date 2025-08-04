import 'package:flutter/material.dart';

class ShowCard extends StatefulWidget {
  final String imageUrl;

  const ShowCard({super.key, required this.imageUrl});

  @override
  State<ShowCard> createState() => _ShowCardState();
}

class _ShowCardState extends State<ShowCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [Image.network(widget.imageUrl, fit: BoxFit.cover)],
      ),
    );
  }
}
