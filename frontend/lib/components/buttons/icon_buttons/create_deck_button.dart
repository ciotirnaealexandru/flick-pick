import 'package:flutter/material.dart';
import 'package:frontend/components/border_text_field.dart';
import 'package:frontend/components/buttons/button_models/custom_filled_button.dart';
import 'package:frontend/components/buttons/button_models/custom_icon_button.dart';

class CreateDeckButton extends StatefulWidget {
  const CreateDeckButton({super.key});

  @override
  State<CreateDeckButton> createState() => _CreateDeckButtonState();
}

class _CreateDeckButtonState extends State<CreateDeckButton> {
  void _openCreateDeckOptions(BuildContext context) {
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
                        text: "Create Deck",
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
      text: "Create Deck",
      icon: Icons.add,
      onPressed: _openCreateDeckOptions,
    );
  }
}
