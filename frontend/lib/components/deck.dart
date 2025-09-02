import 'package:flutter/material.dart';
import 'package:frontend/components/cards/show_card.dart';
import 'package:frontend/models/show_model.dart';

class Deck extends StatefulWidget {
  final String name;

  final List<Show> shows;

  const Deck({super.key, required this.name, required this.shows});

  @override
  State<Deck> createState() => _DeckState();
}

class _DeckState extends State<Deck> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.name, style: Theme.of(context).textTheme.titleMedium),
              Icon(Icons.arrow_forward_rounded, size: 25),
            ],
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: widget.shows.length,
            separatorBuilder: (context, index) => SizedBox(width: 10),
            itemBuilder: (context, i) {
              return ShowCard(
                apiId: widget.shows[i].apiId,
                imageUrl: widget.shows[i].imageUrl,
              );
            },
          ),
        ),
      ],
    );
  }
}
