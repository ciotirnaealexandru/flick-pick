import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/components/navbar.dart';
import 'package:frontend/components/show_grid.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/show_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/services/user_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Watchlist extends StatefulWidget {
  const Watchlist({super.key});

  @override
  State<Watchlist> createState() => _WatchlistState();
}

class _WatchlistState extends State<Watchlist> with RouteAware {
  User? userInfo;
  String selectedList = "WATCHED";
  List<Show> shows = [];
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
    // Called when returning to this page after a pop
    getShowsByList(selectedList);
  }

  Future<void> loadUserInfo() async {
    final user = await getUserInfo();
    setState(() {
      userInfo = user;
    });
    if (user != null) {
      await getShowsByList(selectedList);
    }
  }

  Future<void> getShowsByList(selectedList) async {
    final secureStorage = FlutterSecureStorage();
    final token = await secureStorage.read(
      key: dotenv.env['SECURE_STORAGE_SECRET']!,
    );

    String watchType = (selectedList == "WATCHED") ? "watched" : "future";

    final showsResponse = await http.get(
      Uri.parse(
        '${dotenv.env['API_URL']!}/user/show/$watchType/${userInfo?.id}',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final List<dynamic> showsJson = json.decode(showsResponse.body);

    setState(() {
      shows =
          showsJson
              .map((json) => Show.fromJson(json['show']))
              .where((show) => show.hasAllFields)
              .toList();
      finishedLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userInfo == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        title: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        backgroundColor:
                            selectedList == "WATCHED"
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedList = "WATCHED";
                        });
                        getShowsByList(selectedList);
                      },
                      child: Text(
                        "WATCHED",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              selectedList == "WATCHED"
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        backgroundColor:
                            selectedList == "FUTURE"
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedList = "FUTURE";
                        });
                        getShowsByList(selectedList);
                      },
                      child: Text(
                        "FUTURE",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              selectedList == "FUTURE"
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      body:
          finishedLoading && shows.isEmpty
              ? Center(
                child: Text(
                  "No shows found.",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              )
              : ShowGrid(shows: shows),
      bottomNavigationBar: Navbar(),
    );
  }
}
