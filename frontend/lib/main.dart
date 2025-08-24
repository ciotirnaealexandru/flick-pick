import 'package:flutter/material.dart';
import 'package:frontend/pages/login.dart';
import 'package:frontend/pages/profile.dart';
import 'package:frontend/pages/signup.dart';
import 'package:frontend/pages/search.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flick Pick',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(116, 95, 255, 1),
        textTheme: TextTheme(titleLarge: const TextStyle(fontSize: 30)),
        appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
      ),
      home: const Login(),
      routes: {
        '/login': (context) => const Login(),
        '/signup': (context) => const Signup(),
        '/search': (context) => const Search(),
        '/profile': (context) => const Profile(),
      },
    );
  }
}
