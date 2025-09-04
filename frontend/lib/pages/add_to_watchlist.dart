import 'package:flutter/material.dart';
import 'package:frontend/components/bars/navbar.dart';
import 'package:frontend/components/bars/search_bar.dart';
import 'package:frontend/components/buttons/button_models/custom_filled_button.dart';
import 'package:frontend/components/buttons/icon_buttons/create_deck_button.dart';
import 'package:frontend/components/buttons/icon_buttons/sort_button.dart';
import 'package:frontend/models/deck_model.dart';
import 'package:frontend/services/deck_service.dart';

class AddToWatchlist extends StatefulWidget {
  const AddToWatchlist({super.key});

  @override
  State<AddToWatchlist> createState() => _AddToWatchlistState();
}

class _AddToWatchlistState extends State<AddToWatchlist> {
  int? userId;
  List<Deck>? decksInfo;
  bool finishedLoading = false;

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
      loadDecksInfo();
    }
  }

  Future<void> loadDecksInfo() async {
    final decks = await getDecksInfo(userId: userId);
    setState(() {
      decksInfo = decks;
      finishedLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!finishedLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Text("Your Decks", style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                child: RadioGroup<int>(
                  groupValue: selectedValue,
                  onChanged: (int? value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                  child: Column(
                    children: [
                      for (int i = 0; i < decksInfo!.length; i++)
                        RadioListTile<int>(
                          activeColor: Theme.of(context).colorScheme.onPrimary,
                          value: decksInfo![i].id,
                          title: Text(decksInfo![i].name),
                          contentPadding: EdgeInsets.all(0),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            CustomFilledButton(
              onPressed: () async => {},
              child: Text("Add to Deck"),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
