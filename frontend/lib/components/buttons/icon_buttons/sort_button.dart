import 'package:flutter/material.dart';
import 'package:frontend/components/buttons/button_models/custom_icon_button.dart';
import 'package:frontend/components/buttons/button_models/custom_transparent_button.dart';

class SortButton extends StatefulWidget {
  const SortButton({super.key});

  @override
  State<SortButton> createState() => _SortButtonState();
}

class _SortButtonState extends State<SortButton> {
  String selected = "popular";

  void _openSortOptions(BuildContext context) {
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
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomTransparentButton(
                    onPressed:
                        () => {
                          setState(() {
                            selected = "popular";
                          }),
                          Navigator.pop(context),
                        },

                    child: Container(
                      decoration:
                          selected == "popular"
                              ? BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    width: 2.5,
                                  ),
                                ),
                              )
                              : null,
                      child: Text(
                        "Popular",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                  CustomTransparentButton(
                    onPressed:
                        () => {
                          setState(() {
                            selected = "newest";
                          }),
                          Navigator.pop(context),
                        },
                    child: Container(
                      decoration:
                          selected == "newest"
                              ? BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    width: 2.5,
                                  ),
                                ),
                              )
                              : null,
                      child: Text(
                        "Newest",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                  CustomTransparentButton(
                    onPressed:
                        () => {
                          setState(() {
                            selected = "oldest";
                          }),
                          Navigator.pop(context),
                        },
                    child: Container(
                      decoration:
                          selected == "oldest"
                              ? BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    width: 2.5,
                                  ),
                                ),
                              )
                              : null,
                      child: Text(
                        "Oldest",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                  CustomTransparentButton(
                    onPressed:
                        () => {
                          setState(() {
                            selected = "alphabetically";
                          }),
                          Navigator.pop(context),
                        },
                    child: Container(
                      decoration:
                          selected == "alphabetically"
                              ? BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    width: 2.5,
                                  ),
                                ),
                              )
                              : null,
                      child: Text(
                        "A to Z",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                ],
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
      text: "Sort",
      icon: Icons.swap_vert,
      onPressed: _openSortOptions,
    );
  }
}
