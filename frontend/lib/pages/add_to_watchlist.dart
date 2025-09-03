import 'package:flutter/material.dart';
import 'package:frontend/components/bars/search_bar.dart';
import 'package:frontend/components/buttons/icon_buttons/create_deck_button.dart';
import 'package:frontend/components/buttons/icon_buttons/sort_button.dart';

class AddToWatchlist extends StatefulWidget {
  const AddToWatchlist({super.key});

  @override
  State<AddToWatchlist> createState() => _AddToWatchlistState();
}

class _AddToWatchlistState extends State<AddToWatchlist> {
  Future<void> searchDecks(text) async {}

  @override
  Widget build(BuildContext context) {
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
                  label: "Search Decks",
                  searchFunction: searchDecks,
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
                      CreateDeckButton(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),

      body: Placeholder(),
    );
  }
}
