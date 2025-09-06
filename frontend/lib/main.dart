import 'package:flutter/material.dart';
import 'package:frontend/pages/deck_info.dart';
import 'package:frontend/pages/filter.dart';
import 'package:frontend/pages/login.dart';
import 'package:frontend/pages/profile.dart';
import 'package:frontend/pages/update_profile.dart';
import 'package:frontend/pages/show_info.dart';
import 'package:frontend/pages/signup.dart';
import 'package:frontend/pages/search.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/pages/watchlist.dart';
import 'package:frontend/pages/add_to_watchlist.dart';

import 'theme.dart';
import 'phone_frame_wrapper.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return PhoneFrameWrapper(
      child: MaterialApp(
        navigatorObservers: [routeObserver],
        scrollBehavior: NoScrollbarScrollBehavior(),
        debugShowCheckedModeBanner: false,
        title: 'Flick Pick',
        theme: appTheme,
        home: const Login(),
        routes: {
          '/login': (context) => const Login(),
          '/signup': (context) => const Signup(),
          '/search': (context) => const Search(),
          '/profile': (context) => const Profile(),
          '/update_profile': (context) => const UpdateProfile(),
          '/show_info': (context) => const ShowInfo(),
          '/watchlist': (context) => const Watchlist(),
          '/add_to_watchlist': (context) => const AddToWatchlist(),
          '/deck_info': (context) => const DeckInfo(),
          '/filter': (context) => const Filter(),
        },
      ),
    );
  }
}
