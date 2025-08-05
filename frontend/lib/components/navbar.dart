import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            // use this temporarily to return to login
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: Text("SEARCH"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/search');
          },
          child: Text("WATCHLIST"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/search');
          },
          child: Text("SETTINGS"),
        ),
      ],
    );
  }
}
