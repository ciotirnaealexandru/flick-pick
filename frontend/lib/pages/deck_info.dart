import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/components/bars/search_bar.dart';
import 'package:frontend/components/buttons/icon_buttons/edit_deck_button.dart';
import 'package:frontend/components/buttons/icon_buttons/sort_button.dart';
import 'package:frontend/components/cards/no_shows_found_card.dart';
import 'package:frontend/components/show_grid.dart';
import 'package:frontend/models/deck_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/services/user_service.dart';
import 'package:http/http.dart' as http;

class DeckInfo extends StatefulWidget {
  const DeckInfo({super.key});

  @override
  State<DeckInfo> createState() => _DeckInfoState();
}

class _DeckInfoState extends State<DeckInfo> {
  User? userInfo;

  Deck? deck;
  String? deckId;

  bool finishedLoading = false;

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (deckId == null) {
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      deckId = args['deckId'].toString();
    }
  }

  Future<void> loadUserInfo() async {
    final user = await getUserInfo();
    setState(() {
      userInfo = user;
    });
    if (user != null) {
      await getDeckInfo();
    }
  }

  Future<void> getDeckInfo() async {
    // get the bearer token
    final secureStorage = FlutterSecureStorage();
    final token = await secureStorage.read(
      key: dotenv.env['SECURE_STORAGE_SECRET']!,
    );

    // get the deck info if it exists
    final deckResponse = await http.get(
      Uri.parse('${dotenv.env['API_URL']!}/user/deck/${userInfo?.id}/$deckId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final decksJson = json.decode(deckResponse.body);

    setState(() {
      deck = Deck.fromJson(decksJson);
      finishedLoading = true;
    });
  }

  Future<void> searchDeck(text) async {}

  @override
  Widget build(BuildContext context) {
    if (deck == null) {
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
                  label: "Search ${deck?.name}",
                  searchFunction: searchDeck,
                ),
              ),
              SizedBox(height: 5),
              Align(
                alignment: AlignmentGeometry.centerLeft,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SortButton(),
                      SizedBox(width: 10),
                      if (finishedLoading == true)
                        EditDeckButton(
                          userId: userInfo!.id,
                          deckId: deck!.id,
                          reloadFunction: () => getDeckInfo(),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child:
                finishedLoading && deck!.userShows.isEmpty
                    ? NoShowsFoundCard()
                    : ShowGrid(
                      shows:
                          deck?.userShows
                              .map((userShow) => userShow.show)
                              .toList() ??
                          [],
                    ),
          ),
        ],
      ),
    );
  }
}
