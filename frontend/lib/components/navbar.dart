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
            backgroundColor: WidgetStatePropertyAll(
              Color.fromARGB(255, 28, 37, 51),
            ),
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
          onPressed: () {
            // use this temporarily to return to login
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: Text(
            "SEARCH",
            style: TextStyle(
              color: const Color.fromARGB(255, 178, 166, 255),
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              Color.fromARGB(255, 28, 37, 51),
            ),
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/search');
          },
          child: Text(
            "WATCHLIST",
            style: TextStyle(
              color: const Color.fromARGB(255, 178, 166, 255),
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              Color.fromARGB(255, 28, 37, 51),
            ),
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/profile');
          },
          child: Text(
            "PROFILE",
            style: TextStyle(
              color: const Color.fromARGB(255, 178, 166, 255),
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}
