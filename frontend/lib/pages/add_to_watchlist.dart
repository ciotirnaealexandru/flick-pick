import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/components/buttons/button_models/custom_filled_button.dart';
import 'package:frontend/components/buttons/button_models/custom_transparent_button.dart';
import 'package:frontend/components/show_message.dart';
import 'package:frontend/models/deck_model.dart';
import 'package:frontend/models/user_show_model.dart';
import 'package:frontend/services/deck_service.dart';
import 'package:frontend/services/env_service.dart';
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

  int? selectedDeckId = 0;

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
      if (userShow?.userId != null) selectedDeckId = userShow?.deckId;
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
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(decksInfo![i].name),
                              Icon(Icons.more_vert, size: 25),
                            ],
                          ),
                          contentPadding: EdgeInsets.all(0),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            CustomTransparentButton(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimary,
                      width: 2.5,
                    ),
                  ),
                ),
                child: Text(
                  'Create Deck',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              onPressed: () async {},
            ),
            SizedBox(height: 20),
            if (userShow?.userId != null)
              Column(
                children: [
                  CustomFilledButton(
                    onPressed: () async {
                      final secureStorage = FlutterSecureStorage();
                      final token = await secureStorage.read(key: "auth_token");

                      final changeUserShowInfoResponse = await http.delete(
                        Uri.parse(
                          '${EnvConfig.apiUrl}/user/show/$userId/${userShow?.show.apiId}',
                        ),
                        headers: {
                          'Content-Type': 'application/json',
                          'Authorization': 'Bearer $token',
                        },
                      );

                      if (changeUserShowInfoResponse.statusCode == 200) {
                        if (!context.mounted) return;
                        showMessage(context, "Removed show.");
                      } else {
                        print(
                          "Response body: ${changeUserShowInfoResponse.body}",
                        );

                        final responseData = jsonDecode(
                          changeUserShowInfoResponse.body,
                        );
                        final message =
                            responseData['message'] ?? 'Something went wrong.';

                        if (!context.mounted) return;
                        showMessage(context, message);
                      }

                      Navigator.pop(context);
                    },
                    child: Text("Remove Show"),
                  ),
                ],
              ),
            if (userShow?.userId != null) SizedBox(height: 10),
            CustomFilledButton(
              onPressed: () async {
                // make sure the user selected deck
                if (selectedDeckId == 0) return;

                final secureStorage = FlutterSecureStorage();
                final token = await secureStorage.read(key: "auth_token");

                final changeUserShowInfoResponse = await http.post(
                  Uri.parse('${EnvConfig.apiUrl}/user/show/$userId'),
                  headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer $token',
                  },
                  body: jsonEncode({
                    'apiId': userShow?.show.apiId,
                    'name': userShow?.show.name,
                    'imageUrl': userShow?.show.imageUrl,
                    'summary': userShow?.show.summary,
                    'premiered': userShow?.show.premiered,
                    'deckId': selectedDeckId,
                  }),
                );

                if (changeUserShowInfoResponse.statusCode == 200) {
                  if (!context.mounted) return;
                  showMessage(context, "Added show to deck.");
                } else {
                  print("Response body: ${changeUserShowInfoResponse.body}");

                  final responseData = jsonDecode(
                    changeUserShowInfoResponse.body,
                  );
                  final message =
                      responseData['message'] ?? 'Something went wrong.';

                  if (!context.mounted) return;
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
