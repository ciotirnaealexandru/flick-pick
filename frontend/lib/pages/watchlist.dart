import 'package:flutter/material.dart';
import 'package:frontend/components/navbar.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/services/auth_service.dart';

class Watchlist extends StatefulWidget {
  const Watchlist({super.key});

  @override
  State<Watchlist> createState() => _WatchlistState();
}

class _WatchlistState extends State<Watchlist> {
  User? userInfo;

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
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).colorScheme.primary,
                    ),

                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        onPressed: () {},
                        child: Text(
                          "WATCHED",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        onPressed: () {},
                        child: Text(
                          "WILL WATCH",
                          style: Theme.of(context).textTheme.bodySmall,
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
