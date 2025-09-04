import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/components/buttons/button_models/custom_filled_button.dart';
import 'package:frontend/components/show_message.dart';
import 'package:frontend/models/deck_model.dart';
import 'package:frontend/models/user_show_model.dart';
import 'package:frontend/services/deck_service.dart';
import 'package:frontend/services/show_service.dart';
import 'package:http/http.dart' as http;

class AddToWatchlist extends StatefulWidget {
  const AddToWatchlist({super.key});

  @override
  State<AddToWatchlist> createState() => _AddToWatchlistState();
}

class _AddToWatchlistState extends State<AddToWatchlist> {
  int? userId;
  int? apiId;

  UserShow? userShow;
  List<Deck>? decksInfo;
  bool finishedLoading = false;

  int? selectedDeckId;

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
      apiId = args['apiId'];
      loadDecksInfo();
      loadShowInfo();
    }
  }

  Future<void> loadDecksInfo() async {
    final decks = await getDecksInfo(userId: userId);
    setState(() {
      decksInfo = decks;
    });
  }

  Future<void> loadShowInfo() async {
    final UserShow? data = await getShowInfo(apiId: apiId, userId: userId);

    setState(() {
      userShow = data;
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
                  groupValue: selectedDeckId,
                  onChanged: (int? value) {
                    setState(() {
                      selectedDeckId = value;
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
              onPressed: () async {
                final secureStorage = FlutterSecureStorage();
                final token = await secureStorage.read(
                  key: dotenv.env['SECURE_STORAGE_SECRET']!,
                );

                final changeUserShowInfoResponse = await http.post(
                  Uri.parse('${dotenv.env['API_URL']!}/user/show/$userId'),
                  headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer $token',
                  },
                  body: jsonEncode({
                    'apiId': userShow?.show.apiId,
                    'name': userShow?.show.name,
                    'imageUrl': userShow?.show.imageUrl,
                    'summary': userShow?.show.summary,
                    'deckId': selectedDeckId,
                  }),
                );

                if (changeUserShowInfoResponse.statusCode == 200) {
                  showMessage(context, "Added show to deck.");
                } else {
                  print("Response body: ${changeUserShowInfoResponse.body}");

                  final responseData = jsonDecode(
                    changeUserShowInfoResponse.body,
                  );
                  final message =
                      responseData['message'] ?? 'Something went wrong.';

                  showMessage(context, message);
                }

                Navigator.pop(context);
              },
              child: Text("Add to Deck"),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
