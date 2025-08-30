import 'package:flutter/material.dart';
import 'package:frontend/components/navbar.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/services/user_service.dart';

class Watchlist extends StatefulWidget {
  const Watchlist({super.key});

  @override
  State<Watchlist> createState() => _WatchlistState();
}

class _WatchlistState extends State<Watchlist> {
  User? userInfo;
  String selectedList = "WATCHED";

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    final user = await getUserInfo();
    setState(() {
      userInfo = user;
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
            Navbar(),
            SizedBox(height: 5),
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

      body: Placeholder(),
    );
  }
}
