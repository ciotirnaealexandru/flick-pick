import 'package:flutter/material.dart';

class ShowCard extends StatefulWidget {
  final int showId;
  final String showImageUrl;

  const ShowCard({super.key, required this.showId, required this.showImageUrl});

  @override
  State<ShowCard> createState() => _ShowCardState();
}

class _ShowCardState extends State<ShowCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.primary,
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
            child: Image.network(widget.showImageUrl, fit: BoxFit.fitHeight),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/show_info',
                arguments: {'id': widget.showId},
              );
            },
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                padding: WidgetStatePropertyAll(EdgeInsets.zero),
                backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                shadowColor: WidgetStatePropertyAll(Colors.transparent),
                elevation: WidgetStatePropertyAll(0),
                minimumSize: WidgetStatePropertyAll(
                  Size(0, 40),
                ), // sets min height
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                "ADD",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
