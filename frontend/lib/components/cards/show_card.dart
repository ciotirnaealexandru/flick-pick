import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/buttons/button_models/custom_transparent_button.dart';

class ShowCard extends StatelessWidget {
  final int apiId;
  final String imageUrl;

  const ShowCard({super.key, required this.apiId, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.primary,
      ),
      clipBehavior: Clip.hardEdge,
      child: CustomTransparentButton(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
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
