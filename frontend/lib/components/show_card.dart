import 'package:flutter/material.dart';

class ShowCard extends StatefulWidget {
  final String imageUrl;

  const ShowCard({super.key, required this.imageUrl});

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
          Image.network(widget.imageUrl, fit: BoxFit.cover),
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
                splashFactory: NoSplash.splashFactory,
              ),
              child: Text("ADD", style: Theme.of(context).textTheme.bodyMedium),
            ),
          ),
        ],
      ),
    );
  }
}
