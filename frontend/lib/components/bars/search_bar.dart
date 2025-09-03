import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final Future<void> Function(String) searchFunction;
  final String label;

  const CustomSearchBar({
    super.key,
    required this.label,
    required this.searchFunction,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.primary,
          ),
          height: 50,
          child: Row(
            children: [
              IconButton(
                onPressed: () async {
                  // if the search button is pressed get the text
                  final text = controller.text.trim();

                  // send a a request to the backend to get the shows with those names
                  await widget.searchFunction(text);
                },
                icon: Icon(Icons.search, size: 25),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: widget.label,
                      hintStyle: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (text) async {
                      // if the user pressed enter on keyboard
                      // send a a request to the backend to get the shows with those names
                      await widget.searchFunction(text);
                    },
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      decoration: TextDecoration.none,
                      decorationThickness: 0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
