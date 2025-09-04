import 'package:cached_network_image/cached_network_image.dart';
import 'package:frontend/components/buttons/button_models/custom_filled_button.dart';
import 'package:frontend/models/user_show_model.dart';
import 'package:frontend/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:frontend/components/cards/expandable_text_card.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/services/show_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ShowInfo extends StatefulWidget {
  const ShowInfo({super.key});

  @override
  State<ShowInfo> createState() => _ShowInfoState();
}

class _ShowInfoState extends State<ShowInfo> {
  User? userInfo;

  int? apiId;
  UserShow? userShow;

  int? userRating;
  bool showRating = false;
  bool watchStatus = false;
  bool finishedLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (apiId == null) {
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      apiId = args['apiId'];
      loadUserInfo();
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
    final UserShow? data = await getShowInfo(
      apiId: apiId,
      userId: userInfo?.id,
    );

    setState(() {
      userShow = data;
      userRating = userShow?.userRating;
      finishedLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!finishedLoading) {
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
                          userShow?.show.name ?? "Unknown Show",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 15),
                        Text(
                          "${(userShow?.show.premiered != null || userShow?.show.ended != null) ? "${userShow?.show.premiered} - ${userShow?.show.ended}" : "Years N/A"} • ${userShow?.show.network}",
                          style: Theme.of(context).textTheme.bodyMedium,
                          softWrap: true,
                        ),
                        Text(
                          (userShow?.show.genres != null &&
                                  userShow!.show.genres!.isNotEmpty)
                              ? userShow!.show.genres!.take(2).join(" • ")
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
                                  'apiId': userShow?.show.apiId,
                                },
                              ),

                          child: Text("Add Show"),
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
                        (userShow?.show.imageUrl != null)
                            ? CachedNetworkImage(
                              imageUrl: userShow!.show.imageUrl,
                              fit: BoxFit.fitHeight,
                              height: 220,
                            )
                            : Placeholder(),
                  ),
                ],
              ),
              SizedBox(height: 40),
              ExpandableTextCard(
                text: userShow?.show.summary ?? "Unknown summary.",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
