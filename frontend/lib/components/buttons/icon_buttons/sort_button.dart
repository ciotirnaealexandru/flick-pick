import 'package:flutter/material.dart';
import 'package:frontend/components/bottom_modal.dart';
import 'package:frontend/components/buttons/button_models/custom_icon_button.dart';
import 'package:frontend/components/buttons/button_models/custom_transparent_button.dart';

class SortButton extends StatefulWidget {
  final String sortField;
  final List<String> sortFieldOptions;
  final Future<void> Function(String) changeSortField;

  const SortButton({
    required this.sortField,
    required this.sortFieldOptions,
    required this.changeSortField,
    super.key,
  });

  @override
  State<SortButton> createState() => _SortButtonState();
}

class _SortButtonState extends State<SortButton> {
  void _openSortOptions(BuildContext context) {
    FocusScope.of(context).unfocus();

    Future.delayed(const Duration(milliseconds: 200), () {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return BottomModal(
            modalSize: ModalSize.small,
            children:
                widget.sortFieldOptions.map((option) {
                  return CustomTransparentButton(
                    onPressed: () async {
                      await widget.changeSortField(option);
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration:
                          widget.sortField == option
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
                        option,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  );
                }).toList(),
          );
        },
      );
    });
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
