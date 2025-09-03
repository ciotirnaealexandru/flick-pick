import 'package:flutter/material.dart';
import 'package:frontend/components/buttons/button_models/custom_filled_button.dart';
import 'package:frontend/components/buttons/button_models/custom_icon_button.dart';
import 'package:frontend/components/buttons/button_models/custom_transparent_button.dart';

class FilterButton extends StatefulWidget {
  const FilterButton({super.key});

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  void _openFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SizedBox(
            height: 300,
            child: Center(
              child: SizedBox(
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTransparentButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Genre",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Icon(Icons.arrow_forward_rounded, size: 25),
                        ],
                      ),
                      onPressed: () => Navigator.pushNamed(context, '/filter'),
                    ),
                    CustomTransparentButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Release Year",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Icon(Icons.arrow_forward_rounded, size: 25),
                        ],
                      ),
                      onPressed: () => Navigator.pushNamed(context, '/filter'),
                    ),
                    CustomTransparentButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Ending Year",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Icon(Icons.arrow_forward_rounded, size: 25),
                        ],
                      ),
                      onPressed: () => Navigator.pushNamed(context, '/filter'),
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: [
                        CustomTransparentButton(
                          child: Text(
                            "Remove all filters",
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.normal),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        CustomFilledButton(
                          text: "Apply Filters",
                          onPressedFunction: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      text: "Filter",
      icon: Icons.filter_alt_outlined,
      onPressed: _openFilterOptions,
    );
  }
}
