import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? initialValue;

  const CustomTextField({
    super.key,
    this.label,
    this.validator,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      initialValue: initialValue,
      cursorColor: Theme.of(context).colorScheme.onPrimary,
      cursorErrorColor: Theme.of(context).colorScheme.onPrimary,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: Theme.of(context).textTheme.bodyLarge,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onPrimary,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onPrimary,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onPrimary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onPrimary,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onPrimary,
            width: 2,
          ),
        ),
        errorStyle: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
