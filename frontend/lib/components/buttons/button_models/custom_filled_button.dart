import 'package:flutter/material.dart';

class CustomFilledButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;

  const CustomFilledButton({
    this.backgroundColor,
    required this.text,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor:
              backgroundColor ?? Theme.of(context).colorScheme.onPrimary,
        ),

        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
