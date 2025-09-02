import 'package:flutter/material.dart';
import 'package:frontend/components/cards/add_show_card.dart';
import 'package:frontend/components/cards/show_card.dart';
import 'package:frontend/models/deck_model.dart';

class DeckCard extends StatefulWidget {
  final Deck deck;

  const DeckCard({super.key, required this.deck});

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
                    widget.deck.name,
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
            itemCount: widget.deck.userShows.length + 1,
            separatorBuilder: (context, index) => SizedBox(width: 10),
            itemBuilder: (context, i) {
              if (i < widget.deck.userShows.length) {
                return ShowCard(
                  apiId: widget.deck.userShows[i].apiId,
                  imageUrl: widget.deck.userShows[i].imageUrl,
                );
              }
              return AddShowCard();
            },
          ),
        ),
      ],
    );
  }
}
