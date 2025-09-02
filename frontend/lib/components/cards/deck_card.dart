import 'package:flutter/material.dart';
import 'package:frontend/components/cards/show_card.dart';
import 'package:frontend/models/show_model.dart';

class DeckCard extends StatefulWidget {
  final String name;

  final List<Show> shows;

  const DeckCard({super.key, required this.name, required this.shows});

  @override
  State<DeckCard> createState() => _DeckCardState();
}

class _DeckCardState extends State<DeckCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
          child: Theme(
            data: Theme.of(context).copyWith(
              splashFactory: NoSplash.splashFactory,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
            ),
            child: ElevatedButton(
              onPressed: () => {Navigator.pushNamed(context, "/deck_info")},
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                overlayColor: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Icon(Icons.arrow_forward_rounded, size: 25),
                ],
              ),
            ),
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
