import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.label,
    this.validator,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      cursorColor: Colors.white,
      cursorErrorColor: Colors.white, // fix the pulsing line color
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
        ),
        errorStyle: const TextStyle(color: Colors.red),
      ),
    );
  }
}
