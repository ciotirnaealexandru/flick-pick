import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/user_model.dart';
import 'dart:convert';
import "../components/navbar.dart";

class Watchlist extends StatefulWidget {
  const Watchlist({super.key});

  @override
  State<Watchlist> createState() => _WatchlistState();
}

class _WatchlistState extends State<Watchlist> {
  User? userInfo;

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    final secureStorage = FlutterSecureStorage();
    final token = await secureStorage.read(
      key: dotenv.env['SECURE_STORAGE_SECRET']!,
    );

    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']!}/auth/info'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("🚀 ${response.body}");

    if (response.statusCode == 200) {
      final userJson = json.decode(response.body);
      setState(() {
        userInfo = User.fromJson(userJson);
      });
    } else {
      setState(() {
        userInfo = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userInfo == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Navbar(),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),

      body: Column(
        children: [
          Text("Id: ${userInfo!.id}"),
          Text("First Name: ${userInfo!.firstName}"),
          Text("Last Name: ${userInfo!.lastName}"),
          Text("Email Name: ${userInfo!.email}"),
        ],
      ),
    );
  }
}
