import 'package:flutter/material.dart';
import 'package:frontend/components/buttons/icon_buttons/create_deck_button.dart';
import 'package:frontend/components/buttons/icon_buttons/sort_button.dart';
import 'package:frontend/components/cards/deck_card.dart';
import 'package:frontend/components/bars/navbar.dart';
import 'package:frontend/components/bars/search_bar.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/deck_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/services/deck_service.dart';
import 'package:frontend/services/user_service.dart';

class Watchlist extends StatefulWidget {
  const Watchlist({super.key});

  @override
  State<Watchlist> createState() => _WatchlistState();
}

class _WatchlistState extends State<Watchlist> with RouteAware {
  User? userInfo;
  List<Deck>? decksInfo = [];
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
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    loadDecksInfo();
  }

  Future<void> loadUserInfo() async {
    final user = await getUserInfo();
    setState(() {
      userInfo = user;
    });
    if (user != null) {
      await loadDecksInfo();
    }
  }

  Future<void> loadDecksInfo() async {
    final decks = await getDecksInfo(userId: userInfo!.id);
    final fullDeck = await getFullDeckInfo(userId: userInfo!.id);

    setState(() {
      decksInfo = [fullDeck!, ...decks!];
      finishedLoading = true;
    });
  }

  Future<void> searchWatchlist(text) async {}

  @override
  Widget build(BuildContext context) {
    if (!finishedLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
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
                label: "Search Watchlist",
                searchFunction: searchWatchlist,
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
                    // if (userInfo != null) SortButton(),
                    SizedBox(width: 10),
                    if (userInfo != null)
                      CreateDeckButton(userId: userInfo!.id),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),

      body: Column(
        children: [
          SizedBox(height: 10),
          Expanded(
            child: SizedBox(
              child: ListView.separated(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: decksInfo!.length,
                separatorBuilder: (context, index) => SizedBox(),
                itemBuilder: (context, i) {
                  return Column(
                    children: [
                      DeckCard(deck: decksInfo![i]),
                      SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: Navbar(),
    );
  }
}
