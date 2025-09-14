import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 2,
      height: 40,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}
