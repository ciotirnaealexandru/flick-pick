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
  int? userId;
  int? selectedValue;

  Future<void> searchDecks(text) async {}

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (userId == null) {
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      userId = args['userId'];
    }
  }

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
                      if (userId != null) SortButton(),
                      SizedBox(width: 10),
                      if (userId != null) CreateDeckButton(userId: userId!),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),

      body: RadioGroup<int>(
        groupValue: selectedValue,
        onChanged: (int? value) {
          setState(() {
            selectedValue = value;
          });
        },
        child: Column(
          children: [
            RadioListTile<int>(value: 1, title: Text("Option 1")),
            RadioListTile<int>(value: 2, title: Text("Option 2")),
          ],
        ),
      ),
    );
  }
}
