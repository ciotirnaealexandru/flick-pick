import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/components/bars/search_bar.dart';
import 'package:frontend/components/buttons/icon_buttons/add_show_button.dart';
import 'package:frontend/components/buttons/icon_buttons/edit_deck_button.dart';
import 'package:frontend/components/buttons/icon_buttons/sort_button.dart';
import 'package:frontend/components/cards/no_shows_found_card.dart';
import 'package:frontend/components/show_grid.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/deck_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/models/user_show_model.dart';
import 'package:frontend/services/deck_service.dart';
import 'package:frontend/services/user_service.dart';
import 'package:http/http.dart' as http;

class DeckInfo extends StatefulWidget {
  const DeckInfo({super.key});

  @override
  State<DeckInfo> createState() => _DeckInfoState();
}

class _DeckInfoState extends State<DeckInfo> with RouteAware {
  User? userInfo;
  Deck? deckInfo;
  int? deckId;
  final searchBarController = TextEditingController();

  String sortField = "First Added";
  List<String> sortFieldOptions = ["First Added", "Last Added", "A to Z"];

  bool finishedLoading = false;

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);

    if (deckId == null) {
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      deckId = args['deckId'];
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    getIndividualDeckInfo();
  }

  Future<void> loadUserInfo() async {
    final user = await getUserInfo();
    setState(() {
      userInfo = user;
    });
    if (user != null) {
      await getIndividualDeckInfo();
    }
  }

  Future<void> getIndividualDeckInfo() async {
    final showName = searchBarController.text;

    if (showName != "") {
      await searchDeck();
      return;
    }

    final Deck? deck;

    // check for the full deck
    if (deckId == 0) {
      deck = await getFullDeckInfo(userId: userInfo!.id);
    }
    // if not, then it's a normal deck
    else {
      // get the bearer token
      final secureStorage = FlutterSecureStorage();
      final token = await secureStorage.read(
        key: dotenv.env['SECURE_STORAGE_SECRET']!,
      );

      // get the deck info if it exists
      final deckResponse = await http.get(
        Uri.parse(
          '${dotenv.env['API_URL']!}/user/deck/${userInfo?.id}/$deckId',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final decksJson = json.decode(deckResponse.body);

      deck = Deck.fromJson(decksJson);
    }

    final sortedShowsDeck = Deck(
      id: deck!.id,
      name: deck.name,
      userId: deck.userId,
      createdAt: deck.createdAt,
      userShows: _sortUserShows(deck.userShows),
    );

    setState(() {
      deckInfo = sortedShowsDeck;
      finishedLoading = true;
    });
  }

  Future<void> searchDeck() async {
    final showName = searchBarController.text;

    if (showName == "") {
      await getIndividualDeckInfo();
      return;
    }

    Deck? deck;

    // check for the full deck
    if (deckId == 0) {
      deck = await getFullDeckInfo(userId: userInfo!.id);
    }
    // if not, then it's a normal deck
    else {
      // get the bearer token
      final secureStorage = FlutterSecureStorage();
      final token = await secureStorage.read(
        key: dotenv.env['SECURE_STORAGE_SECRET']!,
      );

      // get the deck info if it exists
      final deckResponse = await http.get(
        Uri.parse(
          '${dotenv.env['API_URL']!}/user/deck/${userInfo?.id}/$deckId',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final decksJson = json.decode(deckResponse.body);

      deck = Deck.fromJson(decksJson);
    }

    final sortedShowsDeck = Deck(
      id: deck!.id,
      name: deck.name,
      userId: deck.userId,
      createdAt: deck.createdAt,
      userShows: _sortUserShows(deck.userShows),
    );

    final lowerQuery = showName.toLowerCase().trim();

    final searchedShows =
        sortedShowsDeck.userShows
            .where(
              (userShow) =>
                  userShow.show.name.toLowerCase().contains(lowerQuery),
            )
            .toList();

    final searchedShowsDeck = Deck(
      id: sortedShowsDeck.id,
      name: sortedShowsDeck.name,
      userId: sortedShowsDeck.userId,
      createdAt: sortedShowsDeck.createdAt,
      userShows: searchedShows,
    );

    setState(() {
      deckInfo = searchedShowsDeck;
    });
  }

  List<UserShow> _sortUserShows(List<UserShow> shows) {
    final sortedShows = shows;

    if (sortField == "Last Added") {
      sortedShows.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));
    }
    if (sortField == "First Added") {
      sortedShows.sort((a, b) => a.updatedAt!.compareTo(b.updatedAt!));
    }
    if (sortField == "A to Z") {
      sortedShows.sort(
        (a, b) =>
            a.show.name.toLowerCase().compareTo(b.show.name.toLowerCase()),
      );
    }

    return sortedShows;
  }

  Future<void> changeSortField(String newSortField) async {
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
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(110),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomSearchBar(
                  controller: searchBarController,
                  label: "Search ${deckInfo?.name}",
                  searchFunction: searchDeck,
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SortButton(
                        sortFieldOptions: sortFieldOptions,
                        sortField: sortField,
                        changeSortField: changeSortField,
                      ),
                      if (deckId != 0) SizedBox(width: 10),
                      if (deckId != 0)
                        EditDeckButton(
                          userId: userInfo!.id,
                          deckId: deckInfo!.id,
                        ),
                      SizedBox(width: 10),
                      AddShowButton(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child:
            finishedLoading && (deckInfo?.userShows.isEmpty ?? true)
                ? Center(child: NoShowsFoundCard())
                : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ShowGrid(
                    shows:
                        deckInfo?.userShows
                            .map((userShow) => userShow.show)
                            .toList() ??
                        [],
                  ),
                ),
      ),
    );
  }
}
