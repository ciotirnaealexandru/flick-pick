import 'package:flutter/material.dart';

class NoShowsFoundCard extends StatelessWidget {
  const NoShowsFoundCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "No shows found.",
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
