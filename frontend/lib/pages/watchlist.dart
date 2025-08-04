import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/components/show_card.dart';
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

  final _searchBarController = TextEditingController();

  @override
  void dispose() {
    // Clean up the search bar controller when the widget is disposed.
    _searchBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (userInfo == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        title: Column(
          children: [
            Navbar(),
            SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              height: 48,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        controller: _searchBarController,
                        decoration: InputDecoration(
                          hintText: 'Search me up ...',
                          hintStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          decoration: TextDecoration.none,
                          decorationThickness: 0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      final text = _searchBarController.text.trim();

                      print("🚀");
                      print(text);
                    },
                    icon: Icon(
                      Icons.search,
                      size: 28,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.white, Theme.of(context).primaryColor],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                padding: EdgeInsets.all(20),
                childAspectRatio: 0.7111,
                children: [
                  ShowCard(),
                  ShowCard(),
                  ShowCard(),
                  ShowCard(),
                  ShowCard(),
                  ShowCard(),
                  ShowCard(),
                  ShowCard(),
                ],
              ),
            ),
            /*
            Text("Id: ${userInfo!.id}"),
            Text("First Name: ${userInfo!.firstName}"),
            Text("Last Name: ${userInfo!.lastName}"),
            Text("Email Name: ${userInfo!.email}"),
            */
          ],
        ),
      ),
    );
  }
}
