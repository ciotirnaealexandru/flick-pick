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
      cursorColor: const Color.fromARGB(255, 178, 166, 255),
      cursorErrorColor: const Color.fromARGB(255, 178, 166, 255),
      style: const TextStyle(color: const Color.fromARGB(255, 178, 166, 255)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: const Color.fromARGB(255, 178, 166, 255),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 178, 166, 255),
            width: 2,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 178, 166, 255),
            width: 2,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 178, 166, 255),
            width: 2,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 178, 166, 255),
            width: 2,
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 178, 166, 255),
            width: 2,
          ),
        ),
        errorStyle: const TextStyle(color: Colors.red),
      ),
    );
  }
}
