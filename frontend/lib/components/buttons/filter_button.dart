import 'package:flutter/material.dart';

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
                    Theme(
                      data: Theme.of(context).copyWith(
                        splashFactory: NoSplash.splashFactory,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () => {Navigator.pop(context)},
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              overlayColor: Colors.transparent,
                              padding: EdgeInsets.symmetric(horizontal: 0),
                            ),
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
                          ),
                          ElevatedButton(
                            onPressed: () => {Navigator.pop(context)},
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              overlayColor: Colors.transparent,
                              padding: EdgeInsets.symmetric(horizontal: 0),
                            ),
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
                          ),
                          ElevatedButton(
                            onPressed: () => {Navigator.pop(context)},
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              overlayColor: Colors.transparent,
                              padding: EdgeInsets.symmetric(horizontal: 0),
                            ),
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
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () => {Navigator.pop(context)},
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            overlayColor: Colors.transparent,
                            padding: EdgeInsets.symmetric(horizontal: 0),
                          ),
                          child: Text(
                            "Remove All Filters",
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,

                              backgroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              shadowColor: Colors.transparent,
                              overlayColor: Colors.transparent,
                            ),
                            onPressed: () => {Navigator.pop(context)},
                            child: Text(
                              "Apply Filters",
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
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
    return ElevatedButton(
      onPressed: () => {_openFilterOptions(context)},
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(EdgeInsets.only(left: 15, right: 20)),
      ),
      child: Row(
        children: [
          Icon(Icons.filter_alt_outlined, size: 25),
          SizedBox(width: 6),
          Text(
            "Filter",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
