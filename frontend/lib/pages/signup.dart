import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/components/buttons/button_models/custom_filled_button.dart';
import 'package:frontend/components/buttons/button_models/custom_transparent_button.dart';
import 'package:frontend/components/custom_form_field.dart';
import 'package:frontend/components/show_message.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 30),
          CustomTextField(
            controller: _firstNameController,
            label: 'First Name',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'This field is empty.';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: _lastNameController,
            label: 'Last Name',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'This field is empty.';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: _emailController,
            label: 'Email',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'This field is empty.';
              }
              if (!value.trim().endsWith('@gmail.com')) {
                return 'Not a valid email.';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: _passwordController,
            label: 'Password',
            obscureText: true,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'This field is empty.';
              }
              if (value.length < 8) {
                return 'Password must be at least 8 characters.';
              }
              if (!RegExp(r'[A-Z]').hasMatch(value)) {
                return 'Add at least one uppercase letter.';
              }
              if (!RegExp(r'[0-9]').hasMatch(value)) {
                return 'Add at least one number.';
              }

              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: _confirmPasswordController,
            label: 'Confirm Password',
            obscureText: true,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'This field is empty.';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match.';
              }
              return null;
            },
          ),
          const SizedBox(height: 30),
          CustomTransparentButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Already have an account?',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 25,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ],
            ),
            onPressed: () async {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
          const SizedBox(height: 15),
          CustomFilledButton(
            child: Text("SIGN UP"),
            onPressed: () async {
              final form = _formKey.currentState!;

              if (form.validate()) {
                final firstName = _firstNameController.text.trim();
                final lastName = _lastNameController.text.trim();
                final email = _emailController.text.trim();
                final password = _passwordController.text;

                final response = await http.post(
                  Uri.parse('${dotenv.env['API_URL']!}/user/signup'),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode({
                    'firstName': firstName,
                    'lastName': lastName,
                    'email': email,
                    'password': password,
                  }),
                );

                if (response.statusCode == 200) {
                  Navigator.pushReplacementNamed(context, '/login');
                } else {
                  final responseData = jsonDecode(response.body);
                  final message =
                      responseData['message'] ?? 'Something went wrong';

                  showMessage(context, message);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sign Up', style: Theme.of(context).textTheme.displayLarge),
              FormScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
