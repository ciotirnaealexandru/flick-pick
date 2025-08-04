import 'package:flutter/material.dart';

class ShowCard extends StatefulWidget {
  const ShowCard({super.key});

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
        children: [
          Image.network(
            'https://static.tvmaze.com/uploads/images/medium_portrait/81/202627.jpg',
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
