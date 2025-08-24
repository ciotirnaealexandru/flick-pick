import 'package:flutter/material.dart';
import 'package:frontend/components/navbar.dart';
import 'package:frontend/services/auth_service.dart';
import '../models/user_model.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  User? userInfo;

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    final user = await getUserInfo();
    setState(() {
      userInfo = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userInfo == null) {
      return Center(
        child: CircularProgressIndicator(
          color: Color.fromARGB(255, 178, 166, 255),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(children: [Navbar()]),
        backgroundColor: const Color.fromARGB(255, 5, 12, 28),
      ),
      body: Container(
        color: const Color.fromARGB(255, 5, 12, 28),
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "EDIT PROFILE",
              style: TextStyle(
                color: Color.fromARGB(255, 178, 166, 255),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              children: [
                Text("Id: ${userInfo!.id}"),
                Text("First Name: ${userInfo!.firstName}"),
                Text("Last Name: ${userInfo!.lastName}"),
                Text("Email Name: ${userInfo!.email}"),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 5, 12, 28),
    );
  }
}
