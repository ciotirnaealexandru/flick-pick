import 'package:flutter/material.dart';
import 'package:frontend/components/buttons/button_models/custom_transparent_button.dart';
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomTransparentButton(
            onPressed:
                () => {
                  Navigator.pushNamed(
                    context,
                    "/deck_info",
                    arguments: {"deckId": widget.deck.id},
                  ),
                },
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
        SizedBox(height: 10),
        SizedBox(
          height: 150,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: widget.deck.userShows.length + 1,
            separatorBuilder: (context, index) => SizedBox(width: 10),
            itemBuilder: (context, i) {
              if (i < widget.deck.userShows.length) {
                return ShowCard(
                  apiId: widget.deck.userShows[i].show.apiId,
                  imageUrl: widget.deck.userShows[i].show.imageUrl,
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
