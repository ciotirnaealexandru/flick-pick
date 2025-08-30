import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ShowCard extends StatelessWidget {
  final int apiId;
  final String showImageUrl;

  const ShowCard({super.key, required this.apiId, required this.showImageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.primary,
      ),
      clipBehavior: Clip.hardEdge,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
        child: CachedNetworkImage(
          imageUrl: showImageUrl,
          fit: BoxFit.cover,
          fadeInDuration: Duration(milliseconds: 200),
          maxHeightDiskCache: 300,
          maxWidthDiskCache: 210,
        ),
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/show_info',
            arguments: {'apiId': apiId},
          );
        },
      ),
    );
  }
}
