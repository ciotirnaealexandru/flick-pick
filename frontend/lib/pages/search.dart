import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/show_grid.dart';
import 'package:frontend/services/user_service.dart';
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
    getPopularShows().then((_) {
      for (var show in shows) {
        precacheImage(CachedNetworkImageProvider(show.imageUrl), context);
      }
    });
  }

  Future<void> loadUserInfo() async {
    final user = await getUserInfo();
    setState(() {
      userInfo = user;
    });
  }

  Future<void> getPopularShows() async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']!}/show/popular'),
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
      Uri.parse('${dotenv.env['API_URL']!}/show/search/$text'),
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
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        title: Column(
          children: [
            Navbar(),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    height: 42,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            alignment: Alignment.centerLeft,
                            child: TextField(
                              controller: _searchBarController,
                              decoration: InputDecoration(
                                hintText: 'Search me up ...',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                border: InputBorder.none,
                              ),
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                decoration: TextDecoration.none,
                                decorationThickness: 0,
                                fontWeight: FontWeight.bold,
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
                            getShowsByName(text);
                          },
                          icon: Icon(Icons.search, size: 28),
                        ),
                        SizedBox(width: 4),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  height: 42,
                  child: IconButton(
                    onPressed: () async {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    icon: Icon(Icons.local_fire_department_outlined, size: 26),
                  ),
                ),
              ],
            ),
          ],
        ),
        centerTitle: true,
      ),

      body: ShowGrid(shows: shows),
    );
  }
}
