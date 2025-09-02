import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/buttons/filter_button.dart';
import 'package:frontend/components/buttons/sort_button.dart';
import 'package:frontend/components/bars/search_bar.dart';
import 'package:frontend/components/show_grid.dart';
import 'package:frontend/services/user_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/user_model.dart';
import '../models/show_model.dart';
import 'dart:convert';
import "../components/bars/navbar.dart";

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  User? userInfo;
  List<Show> shows = [];
  bool finishedLoading = false;

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
      finishedLoading = true;
    });
  }

  Future<void> getShowsByName(text) async {
    // if the string is empty return the popular shows
    if (text == "") {
      await getPopularShows();
      return;
    }

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

  @override
  Widget build(BuildContext context) {
    if (userInfo == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        titleSpacing: 0,
        toolbarHeight: 120,
        title: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomSearchBar(
                label: "Search Flick Pick",
                searchFunction: getShowsByName,
              ),
            ),
            SizedBox(height: 5),
            Align(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [SortButton(), SizedBox(width: 10), FilterButton()],
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
        centerTitle: true,
      ),

      body:
          finishedLoading && shows.isEmpty
              ? Center(
                child: Text(
                  "No shows found.",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              )
              : ShowGrid(shows: shows),
      bottomNavigationBar: Navbar(),
    );
  }
}
