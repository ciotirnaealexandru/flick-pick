import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          style: ButtonStyle(
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/search');
          },
          child: Text("SEARCH", style: Theme.of(context).textTheme.bodySmall),
        ),
        ElevatedButton(
          style: ButtonStyle(
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
          onPressed: () {
            // use this temporarily to return to login
            Navigator.pushReplacementNamed(context, '/watchlist');
          },
          child: Text(
            "WATCHLIST",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        ElevatedButton(
          style: ButtonStyle(
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/profile');
          },
          child: Text("PROFILE", style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    );
  }
}
