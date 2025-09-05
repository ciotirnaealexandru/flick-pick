import 'package:flutter/material.dart';
import 'package:frontend/components/cards/show_card.dart';
import 'package:frontend/models/show_model.dart';

class ShowGrid extends StatelessWidget {
  final List<Show>? shows;

  const ShowGrid({super.key, this.shows});
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2 / 3,
      ),
      itemCount: shows?.length,
      itemBuilder: (context, i) {
        return ShowCard(apiId: shows![i].apiId, imageUrl: shows![i].imageUrl);
      },
    );
  }
}
