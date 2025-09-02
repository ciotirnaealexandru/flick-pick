import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:frontend/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:frontend/components/buttons/watch_status_button.dart';
import 'package:frontend/components/cards/expandable_text_card.dart';
import 'package:frontend/models/show_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/services/show_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
//import 'package:frontend/components/cards/review_card.dart';

class ShowInfo extends StatefulWidget {
  const ShowInfo({super.key});

  @override
  State<ShowInfo> createState() => _ShowInfoState();
}

class _ShowInfoState extends State<ShowInfo> {
  User? userInfo;

  String? apiId;
  Show? showInfo;

  int? userRating;
  bool showRating = false;
  String? watchStatus;

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (apiId == null) {
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      apiId = args['apiId'].toString();
    }
  }

  Future<void> loadUserInfo() async {
    final user = await getUserInfo();
    setState(() {
      userInfo = user;
    });

    if (apiId != null) {
      await loadShowInfo(apiId);
    }
  }

  Future<void> loadShowInfo(apiId) async {
    final data = await getShowInfo(
      apiId: apiId,
      userId: userInfo?.id.toString(),
    );

    setState(() {
      showInfo = data;
      watchStatus = showInfo?.watchStatus;
      userRating = showInfo?.userRating;
      showRating = (watchStatus == "WATCHED" || watchStatus == "FUTURE");
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showInfo == null || userInfo == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          showInfo!.name,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(height: 1.1),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "${(showInfo?.premiered != null || showInfo?.ended != null) ? "${showInfo?.premiered} - ${showInfo?.ended}" : "Years N/A"} • ${showInfo?.network}",
                          style: Theme.of(context).textTheme.bodyMedium,
                          softWrap: true,
                        ),
                        Text(
                          showInfo?.genres?.isNotEmpty == true
                              ? showInfo!.genres!.take(2).join(" • ")
                              : "No genres available",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        WatchStatusButton(),
                        SizedBox(height: 10),
                        IntrinsicWidth(
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              splashFactory: NoSplash.splashFactory,
                              highlightColor: Colors.transparent,
                            ),
                            child: StarRating(
                              size: 40,
                              rating:
                                  watchStatus != "NOT_WATCHED"
                                      ? (userRating?.toDouble() ?? 0)
                                      : 0,
                              color:
                                  showRating
                                      ? Colors.amber.shade300
                                      : Theme.of(context).colorScheme.primary,
                              borderColor:
                                  showRating
                                      ? Colors.amber.shade300
                                      : Theme.of(context).colorScheme.primary,
                              allowHalfRating: true,
                              onRatingChanged: (newRating) async {
                                if (showRating) {
                                  setState(
                                    () =>
                                        userRating =
                                            (userRating == newRating
                                                ? 0
                                                : newRating.toInt()),
                                  );

                                  print(userRating);

                                  final secureStorage = FlutterSecureStorage();
                                  final token = await secureStorage.read(
                                    key: dotenv.env['SECURE_STORAGE_SECRET']!,
                                  );

                                  await http.post(
                                    Uri.parse(
                                      '${dotenv.env['API_URL']!}/user/show/${userInfo?.id}',
                                    ),
                                    headers: {
                                      'Content-Type': 'application/json',
                                      'Authorization': 'Bearer $token',
                                    },
                                    body: jsonEncode({
                                      'apiId': showInfo?.apiId,
                                      'name': showInfo?.name,
                                      'imageUrl': showInfo?.imageUrl,
                                      'summary': showInfo?.summary,
                                      'userRating': userRating,
                                    }),
                                  );

                                  await loadShowInfo(apiId);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: CachedNetworkImage(
                      imageUrl: showInfo!.imageUrl,
                      fit: BoxFit.fitHeight,
                      height: 220,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              ExpandableTextCard(
                text: showInfo!.summary,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 40),
              /*
              Text("Reviews", style: Theme.of(context).textTheme.titleMedium),
              ReviewCard(author: "Alex", content: "Buna, asta e un mesaj."),
              ReviewCard(
                author: "Andrei",
                content:
                    "Buna, asta e un mesaj, dar mult mult mult mult mult mult mult mult mult mult mult mult mai lung.",
              ),
              ReviewCard(author: "Alex", content: "Buna, asta e un mesaj."),
              ReviewCard(
                author: "Andrei",
                content:
                    "Buna, asta e un mesaj, dar mult mult mult mult mult mult mult mult mult mult mult mult mai lung.",
              ),
              ReviewCard(author: "Alex", content: "Buna, asta e un mesaj."),
              ReviewCard(
                author: "Andrei",
                content:
                    "Buna, asta e un mesaj, dar mult mult mult mult mult mult mult mult mult mult mult mult mai lung.",
              ),
              */
            ],
          ),
        ),
      ),
    );
  }
}
