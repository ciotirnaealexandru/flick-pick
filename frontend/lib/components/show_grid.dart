import 'package:flutter/material.dart';
import 'package:frontend/components/cards/show_card.dart';
import 'package:frontend/models/show_model.dart';

class ShowGrid extends StatelessWidget {
  final List<Show> shows;

  const ShowGrid({super.key, required this.shows});

  @override
  Widget build(BuildContext context) {
    if (shows.isEmpty) return SizedBox.shrink();

    return Column(
      children: [
        SizedBox(height: 20),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children:
              shows
                  .map(
                    (show) => SizedBox(
                      width: (MediaQuery.of(context).size.width - 60) / 3,
                      child: ShowCard(
                        apiId: show.apiId,
                        imageUrl: show.imageUrl,
                      ),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }
}
