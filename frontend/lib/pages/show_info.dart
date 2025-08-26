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
  Show? showInfo;

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
          showInfo = Show.fromJson(showJson);
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
    if (showInfo == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40),
                      Text(
                        showInfo!.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(showInfo!.name),
                    ],
                  ),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.network(
                      showInfo!.image,
                      fit: BoxFit.fitHeight,
                      height: 220,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Text(
                showInfo!.summary,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 40),
              Text("Seasons", style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}
