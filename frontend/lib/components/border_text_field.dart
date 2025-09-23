import 'package:flutter/material.dart';

class BorderTextField extends StatelessWidget {
  final String hintText;
  final Future<void> Function(String) onSubmitted;
  final TextEditingController? controller;

  const BorderTextField({
    this.controller,
    required this.hintText,
    required this.onSubmitted,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
        textAlign: TextAlign.center,
        controller: controller,
        onSubmitted: (value) {
          onSubmitted(value);
          FocusScope.of(context).unfocus();
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          hintText: hintText,
          hintStyle: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 1.5,
            ),
          ),
        ),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          decoration: TextDecoration.none,
          decorationThickness: 0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
