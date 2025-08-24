import 'package:flutter/material.dart';
import 'package:frontend/components/navbar.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(children: [Navbar()]),
        backgroundColor: const Color.fromARGB(255, 5, 12, 28),
      ),
      body: Placeholder(),
      backgroundColor: const Color.fromARGB(255, 5, 12, 28),
    );
  }
}
