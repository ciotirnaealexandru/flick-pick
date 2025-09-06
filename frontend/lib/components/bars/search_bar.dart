import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final Future<void> Function() searchFunction;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.label,
    required this.searchFunction,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  void initState() {
    super.initState();
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                IconButton(
                  onPressed: () async => await widget.searchFunction(),
                  icon: Icon(Icons.search, size: 25),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: widget.controller,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 5),
                        hintText: widget.label,
                        hintStyle: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                        border: InputBorder.none,
                      ),
                      onSubmitted:
                          (text) async => await widget.searchFunction(),
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
        ),
      ],
    );
  }
}
