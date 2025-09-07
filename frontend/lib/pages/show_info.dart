import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:frontend/components/buttons/button_models/custom_filled_button.dart';
import 'package:frontend/components/cards/no_shows_found_card.dart';
import 'package:frontend/components/show_grid.dart';
import 'package:frontend/components/show_message.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/show_model.dart';
import 'package:frontend/models/user_show_model.dart';
import 'package:frontend/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/services/show_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:expandable_text/expandable_text.dart';

class ShowInfo extends StatefulWidget {
  const ShowInfo({super.key});

  @override
  State<ShowInfo> createState() => _ShowInfoState();
}

class _ShowInfoState extends State<ShowInfo> with RouteAware {
  User? userInfo;

  int? apiId;
  UserShow? userShowInfo;
  List<Show>? similarShowsInfo;

  int? userRating;
  String watchStatus = "Add Show";
  bool showRating = false;
  bool finishedLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);

    if (apiId == null) {
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      apiId = args['apiId'];

      loadUserInfo();
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
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    final user = await getUserInfo();
    setState(() {
      userInfo = user;
    });

    if (apiId != null) {
      await loadShowInfo(apiId);
      await getSimilarShows(apiId);
    }
  }

  Future<void> loadShowInfo(apiId) async {
    final UserShow? data = await getShowInfo(
      apiId: apiId,
      userId: userInfo?.id,
    );

    setState(() {
      userShowInfo = data;
      userRating = userShowInfo?.userRating;
      if (userShowInfo?.deckId != null) {
        watchStatus = "Added";
        showRating = true;
      } else {
        watchStatus = "Add Show";
        showRating = false;
      }
    });
  }

  Future<void> getSimilarShows(apiId) async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']!}/show/similar/$apiId'),
      headers: {'Content-Type': 'application/json'},
    );

    final List<dynamic> showsJson = json.decode(response.body);

    final shows =
        showsJson
            .map((json) => Show.fromJson(json))
            .where((show) => show.hasAllFields)
            .toList();

    setState(() {
      similarShowsInfo = shows;
      finishedLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!finishedLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            while (Navigator.canPop(context)) {
              final route = ModalRoute.of(context);
              if (route?.settings.name != '/show_info') break;
              Navigator.pop(context);
            }
          },
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 190,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userShowInfo?.show.name ?? "Unknown Show",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 15),
                        Text(
                          "${(userShowInfo?.show.premiered != null || userShowInfo?.show.ended != null) ? "${userShowInfo?.show.premiered.substring(0, 4)} - ${userShowInfo?.show.ended!.substring(0, 4)}" : "Years N/A"} • ${userShowInfo?.show.network}",
                          style: Theme.of(context).textTheme.bodyMedium,
                          softWrap: true,
                        ),
                        Text(
                          (userShowInfo?.show.genres != null &&
                                  userShowInfo!.show.genres!.isNotEmpty)
                              ? userShowInfo!.show.genres!.take(2).join(" • ")
                              : "No genres available",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        CustomFilledButton(
                          onPressed:
                              () => Navigator.pushNamed(
                                context,
                                '/add_to_watchlist',
                                arguments: {
                                  'userId': userInfo?.id,
                                  'apiId': userShowInfo?.show.apiId,
                                },
                              ),

                          child: Text(watchStatus),
                        ),
                        SizedBox(height: 10),
                        IntrinsicWidth(
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              splashFactory: NoSplash.splashFactory,
                              highlightColor: Colors.transparent,
                            ),
                            child: StarRating(
                              size: 38,
                              rating:
                                  watchStatus == "Added"
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

                                  final changeUserShowInfoResponse = await http
                                      .post(
                                        Uri.parse(
                                          '${dotenv.env['API_URL']!}/user/show/${userInfo?.id}',
                                        ),
                                        headers: {
                                          'Content-Type': 'application/json',
                                          'Authorization': 'Bearer $token',
                                        },
                                        body: jsonEncode({
                                          'apiId': userShowInfo?.show.apiId,
                                          'name': userShowInfo?.show.name,
                                          'imageUrl':
                                              userShowInfo?.show.imageUrl,
                                          'summary': userShowInfo?.show.summary,
                                          'premiered':
                                              userShowInfo?.show.premiered,
                                          'deckId': userShowInfo?.deckId,
                                          'userRating': userRating,
                                        }),
                                      );

                                  if (changeUserShowInfoResponse.statusCode !=
                                      200) {
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
                    child:
                        (userShowInfo?.show.imageUrl != null)
                            ? CachedNetworkImage(
                              imageUrl: userShowInfo!.show.imageUrl,
                              fit: BoxFit.fitHeight,
                              height: 220,
                            )
                            : Placeholder(),
                  ),
                ],
              ),
              SizedBox(height: 40),
              ExpandableText(
                userShowInfo?.show.summary ?? "Unknown summary.",
                expandText: '',
                linkColor: Theme.of(context).colorScheme.onPrimary,
                maxLines: 4,
                collapseOnTextTap: true,
                expandOnTextTap: true,
                animation: true,
                animationDuration: Duration(milliseconds: 800),
              ),

              Divider(
                thickness: 2,
                height: 40, // keeps it tight, no extra vertical padding
                color: Theme.of(context).primaryColor,
              ),

              Text(
                "More like this",
                style: Theme.of(context).textTheme.titleMedium,
              ),

              similarShowsInfo!.isEmpty
                  ? Center(child: NoShowsFoundCard())
                  : SingleChildScrollView(
                    child: ShowGrid(shows: similarShowsInfo!),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
