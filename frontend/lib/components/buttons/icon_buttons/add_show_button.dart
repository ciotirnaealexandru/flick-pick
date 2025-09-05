import 'package:flutter/material.dart';
import 'package:frontend/components/buttons/button_models/custom_icon_button.dart';

class AddShowButton extends StatelessWidget {
  const AddShowButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      text: "Add Show",
      icon: Icons.add,
      onPressed:
          (context) => Navigator.pushReplacementNamed(context, '/search'),
    );
  }
}
