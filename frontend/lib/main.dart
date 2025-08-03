import 'package:flutter/material.dart';
import 'package:frontend/pages/login.dart';
import 'package:frontend/pages/signup.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/pages/watchlist.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flick Pick',
      theme: ThemeData(
        primaryColor: Color(0xFF745FFF),
        textTheme: TextTheme(titleLarge: const TextStyle(fontSize: 30)),
        appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
      ),
      home: const Login(),
      routes: {
        '/login': (context) => const Login(),
        '/signup': (context) => const Signup(),
        '/watchlist': (context) => const Watchlist(),
      },
    );
  }
}
