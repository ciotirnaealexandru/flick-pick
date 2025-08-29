import 'package:flutter/material.dart';

class ReviewCard extends StatefulWidget {
  final String author;
  final String content;

  const ReviewCard({required this.author, required this.content, super.key});

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.author}",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text("${widget.content}"),
            ],
          ),
        ),
        Divider(
          color: Theme.of(context).colorScheme.onPrimary,
          thickness: 1,
          height: 20,
          indent: 0,
          endIndent: 0,
        ),
      ],
    );
  }
}
