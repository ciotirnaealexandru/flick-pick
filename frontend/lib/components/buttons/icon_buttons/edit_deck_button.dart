import 'package:flutter/material.dart';
import 'package:frontend/components/border_text_field.dart';
import 'package:frontend/components/buttons/button_models/custom_filled_button.dart';
import 'package:frontend/components/buttons/button_models/custom_icon_button.dart';

class EditDeckButton extends StatefulWidget {
  const EditDeckButton({super.key});

  @override
  State<EditDeckButton> createState() => _EditDeckButtonState();
}

class _EditDeckButtonState extends State<EditDeckButton> {
  void _changeNameOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(
                  context,
                ).viewInsets.bottom, // pushes up on keyboard
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),

            child: SizedBox(
              height: 200,
              child: Center(
                child: SizedBox(
                  width: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BorderTextField(
                        hintText: "Enter Deck Name",
                        onSubmitted: (text) => {print(text)},
                      ),
                      SizedBox(height: 10),
                      CustomFilledButton(
                        onPressedFunction: () => Navigator.pop(context),
                        text: "Change Name",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _deleteDeckOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(
                  context,
                ).viewInsets.bottom, // pushes up on keyboard
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),

            child: SizedBox(
              height: 200,
              child: Center(
                child: SizedBox(
                  width: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Are you sure you want to delete this deck?",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      SizedBox(height: 10),
                      CustomFilledButton(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        onPressedFunction: () => Navigator.pop(context),
                        text: "Delete",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _editDeckOptions(BuildContext context) {
    final rootContext = Navigator.of(context, rootNavigator: true).context;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(
                  context,
                ).viewInsets.bottom, // pushes up on keyboard
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),

            child: SizedBox(
              height: 200,
              child: Center(
                child: SizedBox(
                  width: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomFilledButton(
                        onPressedFunction:
                            () => {
                              Navigator.pop(context),
                              Future.delayed(
                                const Duration(milliseconds: 300),
                                () {
                                  _changeNameOptions(rootContext);
                                },
                              ),
                            },
                        text: "Change Name",
                      ),
                      SizedBox(height: 10),
                      CustomFilledButton(
                        onPressedFunction:
                            () => {
                              Navigator.pop(context),
                              Future.delayed(
                                const Duration(milliseconds: 300),
                                () {
                                  _deleteDeckOptions(rootContext);
                                },
                              ),
                            },
                        text: "Delete Deck",
                      ),
                    ],
                  ),
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
      text: "Edit Deck",
      icon: Icons.edit_outlined,
      onPressed: _editDeckOptions,
    );
  }
}
