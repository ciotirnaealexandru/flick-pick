import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:frontend/components/cards/expandable_text_card.dart';
import 'package:frontend/models/show_model.dart';
import 'package:frontend/services/show_service.dart';

class ShowInfo extends StatefulWidget {
  const ShowInfo({super.key});

  @override
  State<ShowInfo> createState() => _ShowInfoState();
}

class _ShowInfoState extends State<ShowInfo> {
  String? showId;
  Show? showInfo;
  double? rating;
  bool isEnabled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (showId == null) {
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      showId = args['id'].toString();

      _loadShowInfo(showId!);
    }
  }

  Future<void> _loadShowInfo(showId) async {
    final data = await getShowInfo(showId);
    setState(() {
      showInfo = data;
    });
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
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed:
                                () => {
                                  setState(() {
                                    isEnabled = !isEnabled;
                                  }),
                                },
                            child: Text(
                              "Add to watchlist",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        IntrinsicWidth(
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              splashFactory: NoSplash.splashFactory,
                              highlightColor: Colors.transparent,
                            ),
                            child: StarRating(
                              size: 40,
                              rating: isEnabled ? (rating ?? 0) : 0,
                              color:
                                  isEnabled
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Theme.of(context).colorScheme.primary,
                              borderColor:
                                  isEnabled
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Theme.of(context).colorScheme.primary,
                              allowHalfRating: true,
                              onRatingChanged: (newRating) {
                                setState(
                                  () =>
                                      rating =
                                          (rating == newRating || !isEnabled
                                              ? 0
                                              : newRating),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: CachedNetworkImage(
                      imageUrl: showInfo!.image,
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
            ],
          ),
        ),
      ),
    );
  }
}
