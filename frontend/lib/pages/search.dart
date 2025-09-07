import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/buttons/icon_buttons/genre_button.dart';
import 'package:frontend/components/buttons/icon_buttons/sort_button.dart';
import 'package:frontend/components/bars/search_bar.dart';
import 'package:frontend/components/cards/no_shows_found_card.dart';
import 'package:frontend/components/show_grid.dart';
import 'package:frontend/main.dart';
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

class _SearchState extends State<Search> with RouteAware {
  User? userInfo;
  List<Show> showsInfo = [];
  final searchBarController = TextEditingController();

  String sortField = "Most Relevant";
  List<String> sortFieldOptions = [
    "Most Relevant",
    "Last Premiered",
    "First Premiered",
    "A to Z",
  ];

  Genre genre = Genre(genreName: "All", genreId: 0);

  bool finishedLoading = false;

  @override
  void initState() {
    super.initState();
    loadUserInfo();
    getShows().then((_) {
      for (var show in showsInfo) {
        if (!mounted) return;
        precacheImage(CachedNetworkImageProvider(show.imageUrl), context);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    getShows();
  }

  Future<void> loadUserInfo() async {
    final user = await getUserInfo();
    setState(() {
      userInfo = user;
    });
  }

  Future<void> getShows() async {
    final showName = searchBarController.text;

    if (showName != "") {
      await searchFlickPick();
      return;
    }

    print(genre.genreId);

    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']!}/show/search/genre/${genre.genreId}'),
      headers: {'Content-Type': 'application/json'},
    );

    final List<dynamic> showsJson = json.decode(response.body);

    final shows =
        showsJson
            .map((json) => Show.fromJson(json))
            .where((show) => show.hasAllFields)
            .toList();

    final sortedShows = _sortShows(shows);

    setState(() {
      showsInfo = sortedShows;
      finishedLoading = true;
    });
  }

  Future<void> searchFlickPick() async {
    final showName = searchBarController.text;

    if (showName == "") {
      await getShows();
      return;
    }

    // if searching reset genre
    changeGenre(Genre(genreName: "All", genreId: 0));

    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']!}/show/search/name/$showName'),
      headers: {'Content-Type': 'application/json'},
    );

    final List<dynamic> showsJson = json.decode(response.body);

    final shows =
        showsJson
            .map((json) => Show.fromJson(json))
            .where((show) => show.hasAllFields)
            .toList();

    final sortedShows = _sortShows(shows);

    setState(() {
      showsInfo = sortedShows;
    });
  }

  List<Show> _sortShows(List<Show> shows) {
    final sortedShows = List<Show>.from(shows);

    List<int> parseYMD(String date) {
      final parts = date.split('-');
      return [
        int.parse(parts[0]), // year
        int.parse(parts[1]), // month
        int.parse(parts[2]), // day
      ];
    }

    int compareDates(String a, String b) {
      final aParts = parseYMD(a);
      final bParts = parseYMD(b);

      for (int i = 0; i < 3; i++) {
        if (aParts[i] != bParts[i]) return aParts[i].compareTo(bParts[i]);
      }
      return 0;
    }

    if (sortField == "Most Relevant") {}

    if (sortField == "First Premiered") {
      sortedShows.sort(
        (a, b) => compareDates(a.premiered, b.premiered),
      ); // newest first
    }

    if (sortField == "Last Premiered") {
      sortedShows.sort(
        (a, b) => compareDates(b.premiered, a.premiered),
      ); // oldest first
    }

    if (sortField == "A to Z") {
      sortedShows.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
    }

    return sortedShows;
  }

  Future<void> changeSortField(String newSortField) async {
    setState(() {
      sortField = newSortField;
    });
  }

  Future<void> changeGenre(Genre newGenre) async {
    setState(() {
      genre = newGenre;
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
                      sortFieldOptions: sortFieldOptions,
                      sortField: sortField,
                      changeSortField: changeSortField,
                    ),
                    SizedBox(width: 10),
                    GenreButton(genre: genre, changeGenre: changeGenre),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),

      body:
          showsInfo.isEmpty
              ? Center(child: NoShowsFoundCard())
              : ShowGrid(shows: showsInfo),
      bottomNavigationBar: Navbar(),
    );
  }
}
