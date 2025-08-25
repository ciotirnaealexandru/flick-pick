import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/models/show_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ShowInfo extends StatefulWidget {
  const ShowInfo({super.key});

  @override
  State<ShowInfo> createState() => _ShowInfoState();
}

class _ShowInfoState extends State<ShowInfo> {
  String? showId;
  Show? show;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (showId == null) {
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      showId = args['id'].toString();

      // fetch the show info after we have the showId
      getShowInfo(showId!);
    }
  }

  Future<void> getShowInfo(showId) async {
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']!}/shows/$showId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final showJson = json.decode(response.body);

        setState(() {
          show = Show.fromJson(showJson);
        });
      } else {
        print('Failed to load show info: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching show info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(show != null ? '${show!.name}' : "Loading..."),
      ),
      body: Center(child: Text("Details for show with id $showId")),
    );
  }
}
