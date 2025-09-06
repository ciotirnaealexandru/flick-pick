import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/buttons/icon_buttons/filter_button.dart';
import 'package:frontend/components/buttons/icon_buttons/sort_button.dart';
import 'package:frontend/components/bars/search_bar.dart';
import 'package:frontend/components/cards/no_shows_found_card.dart';
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
  String sortField = "Newest";
  final searchBarController = TextEditingController();
  bool finishedLoading = false;

  @override
  void initState() {
    super.initState();
    loadUserInfo();
    getPopularShows().then((_) {
      for (var show in shows) {
        if (!mounted) return;
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

  void _sortShows() {}

  Future<void> getPopularShows() async {
    final showName = searchBarController.text;

    if (showName != "") {
      await searchFlickPick();
      return;
    }

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
      _sortShows();
      finishedLoading = true;
    });
  }

  Future<void> searchFlickPick() async {
    final showName = searchBarController.text;

    if (showName == "") {
      await getPopularShows();
      return;
    }

    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']!}/show/search/$showName'),
      headers: {'Content-Type': 'application/json'},
    );

    final List<dynamic> showsJson = json.decode(response.body);

    setState(() {
      shows =
          showsJson
              .map((json) => Show.fromJson(json))
              .where((show) => show.hasAllFields)
              .toList();
      _sortShows();
    });
  }

  Future<void> changeSortField(newSortField) async {
    setState(() {
      sortField = newSortField;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!finishedLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        toolbarHeight: 120,
        title: Column(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomSearchBar(
                controller: searchBarController,
                label: "Search Flick Pick",
                searchFunction: searchFlickPick,
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SortButton(
                      sortField: sortField,
                      changeSortField: changeSortField,
                    ),
                    SizedBox(width: 10),
                    FilterButton(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),

      body:
          shows.isEmpty
              ? Center(child: NoShowsFoundCard())
              : ShowGrid(shows: shows),
      bottomNavigationBar: Navbar(),
    );
  }
}
