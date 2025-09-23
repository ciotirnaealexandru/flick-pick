import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/components/buttons/button_models/custom_filled_button.dart';
import 'package:frontend/components/buttons/icon_buttons/create_deck_button.dart';
import 'package:frontend/components/buttons/icon_buttons/edit_deck_button.dart';
import 'package:frontend/components/show_message.dart';
import 'package:frontend/main.dart';
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

class _AddToWatchlistState extends State<AddToWatchlist> with RouteAware {
  int? userId;
  int? apiId;

  UserShow? userShow;
  List<Deck>? decksInfo;
  bool finishedLoading = false;

  List<int>? currentSelectedDeckIds = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);

    if (userId == null) {
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      userId = args['userId'];
      apiId = args['apiId'];
      loadDecksInfo();
      loadShowInfo();
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
    loadDecksInfo();
    loadShowInfo();
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
      if (userShow?.userId != null) {
        currentSelectedDeckIds = userShow?.selectedDeckIds;
      }
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: decksInfo!.length,
                        itemBuilder: (context, i) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: CheckboxListTile(
                                    value:
                                        currentSelectedDeckIds?.contains(
                                          decksInfo![i].id,
                                        ) ??
                                        false,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value == true) {
                                          currentSelectedDeckIds?.add(
                                            decksInfo![i].id,
                                          );
                                        } else {
                                          currentSelectedDeckIds?.remove(
                                            decksInfo![i].id,
                                          );
                                        }
                                      });
                                    },
                                    title: Text(decksInfo![i].name),
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    contentPadding: EdgeInsets.zero,
                                    activeColor:
                                        Theme.of(context).colorScheme.primary,
                                    checkColor:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                                EditDeckButton(
                                  userId: userId!,
                                  deckId: decksInfo![i].id,
                                  type: EditDeckButtonType.icon,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      CreateDeckButton(
                        userId: userId!,
                        type: CreateDeckButtonType.transparent,
                      ),
                      SizedBox(height: 15),
                      CustomFilledButton(
                        onPressed: () async {
                          final secureStorage = FlutterSecureStorage();
                          final token = await secureStorage.read(
                            key: "auth_token",
                          );

                          // if no decks were selected simply delete the show
                          if (currentSelectedDeckIds!.isEmpty) {
                            final deleteShowResponse = await http.delete(
                              Uri.parse(
                                '${EnvConfig.apiUrl}/user/show/$userId/${userShow?.showId}',
                              ),
                              headers: {
                                'Content-Type': 'application/json',
                                'Authorization': 'Bearer $token',
                              },
                            );

                            if (deleteShowResponse.statusCode == 200) {
                              if (!context.mounted) return;
                              showMessage(context, "Removed show.");
                            } else {
                              print(
                                "Response body: ${deleteShowResponse.body}",
                              );

                              final responseData = jsonDecode(
                                deleteShowResponse.body,
                              );
                              final message =
                                  responseData['message'] ??
                                  'Something went wrong.';

                              if (!context.mounted) return;
                              showMessage(context, message);
                            }
                          }
                          // if some decks were selected change the user show info
                          else {
                            final changeUserShowInfoResponse = await http.post(
                              Uri.parse(
                                '${EnvConfig.apiUrl}/user/show/$userId',
                              ),
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
                                'selectedDeckIds': currentSelectedDeckIds,
                              }),
                            );

                            if (changeUserShowInfoResponse.statusCode == 200) {
                              if (!context.mounted) return;
                              showMessage(context, "Added show to deck.");
                            } else {
                              print(
                                "Response body: ${changeUserShowInfoResponse.body}",
                              );

                              final responseData = jsonDecode(
                                changeUserShowInfoResponse.body,
                              );
                              final message =
                                  responseData['message'] ??
                                  'Something went wrong.';

                              if (!context.mounted) return;
                              showMessage(context, message);
                            }
                          }

                          Navigator.pop(context);
                        },
                        child: Text("Confirm Decks"),
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
