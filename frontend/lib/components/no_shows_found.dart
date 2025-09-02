import 'package:flutter/material.dart';

class NoShowsFound extends StatelessWidget {
  const NoShowsFound({super.key});

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
