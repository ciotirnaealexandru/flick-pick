import 'package:flutter/material.dart';
import 'package:frontend/components/border_text_field.dart';
import 'package:frontend/components/bottom_modal.dart';
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
        return BottomModal(
          modalSize: ModalSize.small,
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
