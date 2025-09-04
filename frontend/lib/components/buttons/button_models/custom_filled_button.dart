import 'package:flutter/material.dart';

class CustomFilledButton extends StatelessWidget {
  final Color? backgroundColor;
  final VoidCallback onPressed;
  final Widget child;

  const CustomFilledButton({
    this.backgroundColor,
    required this.onPressed,
    required this.child,
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
        child: child,
      ),
    );
  }
}
