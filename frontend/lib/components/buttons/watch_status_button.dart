import 'package:flutter/material.dart';

class WatchStatusButton extends StatefulWidget {
  const WatchStatusButton({super.key});

  @override
  State<WatchStatusButton> createState() => _WatchStatusButtonState();
}

class _WatchStatusButtonState extends State<WatchStatusButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => {Navigator.pushNamed(context, '/add_to_watchlist')},
      child: Text(
        "Add to Watchlist",
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
