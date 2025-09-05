import 'package:flutter/material.dart';
import 'package:frontend/components/bottom_modal.dart';
import 'package:frontend/components/buttons/button_models/custom_icon_button.dart';
import 'package:frontend/components/buttons/button_models/custom_transparent_button.dart';

class SortButton extends StatefulWidget {
  final String sortField;
  final Future<void> Function(String) changeSortField;

  const SortButton({
    required this.sortField,
    required this.changeSortField,
    super.key,
  });

  @override
  State<SortButton> createState() => _SortButtonState();
}

class _SortButtonState extends State<SortButton> {
  void _openSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return BottomModal(
          modalSize: ModalSize.small,
          children: [
            CustomTransparentButton(
              onPressed:
                  () => {
                    widget.changeSortField("Newest"),
                    Navigator.pop(context),
                  },
              child: Container(
                decoration:
                    widget.sortField == "Newest"
                        ? BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Theme.of(context).colorScheme.onPrimary,
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
                    widget.changeSortField("Oldest"),
                    Navigator.pop(context),
                  },
              child: Container(
                decoration:
                    widget.sortField == "Oldest"
                        ? BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Theme.of(context).colorScheme.onPrimary,
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
                    widget.changeSortField("A to Z"),
                    Navigator.pop(context),
                  },
              child: Container(
                decoration:
                    widget.sortField == "A to Z"
                        ? BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Theme.of(context).colorScheme.onPrimary,
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
