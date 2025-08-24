import 'package:flutter/material.dart';
import 'package:frontend/components/show_card.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/user_model.dart';
import '../models/show_model.dart';
import 'dart:convert';
import "../components/navbar.dart";

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  User? userInfo;
  List<Show> shows = [];

  @override
  void initState() {
    super.initState();
    loadUserInfo();
    getPopularShows();
  }

  Future<void> loadUserInfo() async {
    final user = await getUserInfo();
    setState(() {
      userInfo = user;
    });
  }

  Future<void> getPopularShows() async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']!}/shows/popular'),
      headers: {'Content-Type': 'application/json'},
    );

    final List<dynamic> showsJson = json.decode(response.body);

    setState(() {
      shows =
          showsJson
              .map((json) => Show.fromJson(json))
              .where((show) => show.hasAllFields)
              .toList();
    });
  }

  Future<void> getShowsByName(text) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']!}/shows/search/$text'),
      headers: {'Content-Type': 'application/json'},
    );

    final List<dynamic> showsJson = json.decode(response.body);

    setState(() {
      shows =
          showsJson
              .map((json) => Show.fromJson(json))
              .where((show) => show.hasAllFields)
              .toList();
    });
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
      return Center(
        child: CircularProgressIndicator(
          color: Color.fromARGB(255, 178, 166, 255),
        ),
      );
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
                color: const Color.fromARGB(255, 28, 37, 51),
              ),
              height: 48,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        controller: _searchBarController,
                        decoration: InputDecoration(
                          hintText: 'Search me up ...',
                          hintStyle: TextStyle(
                            color: const Color.fromARGB(255, 178, 166, 255),
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: const Color.fromARGB(255, 178, 166, 255),
                          decoration: TextDecoration.none,
                          decorationThickness: 0,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    onPressed: () async {
                      // if the search button is pressed get the text
                      final text = _searchBarController.text.trim();

                      // send a a request to the backend to get the shows with those names
                      print("🚀");
                      getShowsByName(text);
                    },
                    icon: Icon(
                      Icons.search,
                      size: 28,
                      color: const Color.fromARGB(255, 178, 166, 255),
                    ),
                  ),
                  SizedBox(width: 4),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 5, 12, 28),
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
      ),

      body: Container(
        color: const Color.fromARGB(255, 5, 12, 28),

        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                padding: EdgeInsets.all(20),
                childAspectRatio: 0.61,
                children: List.generate(shows.length, (i) {
                  return ShowCard(imageUrl: shows[i].image);
                }),
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
