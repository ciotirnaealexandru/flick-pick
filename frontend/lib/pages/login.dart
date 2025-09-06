import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/components/buttons/button_models/custom_filled_button.dart';
import 'package:frontend/components/buttons/button_models/custom_transparent_button.dart';
import 'package:frontend/components/custom_form_field.dart';
import 'package:frontend/components/show_message.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 30),
          CustomTextField(
            label: 'Email',
            controller: _emailController,
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
            label: 'Password',
            controller: _passwordController,
            obscureText: true,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'This field is empty.';
              }
              return null;
            },
          ),
          const SizedBox(height: 80),
          CustomTransparentButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Make an account',
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
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/signup');
            },
          ),
          const SizedBox(height: 20),

          CustomFilledButton(
            child: Text("LOGIN"),
            onPressed: () async {
              final form = _formKey.currentState!;

              if (form.validate()) {
                final email = _emailController.text.trim();
                final password = _passwordController.text;

                final response = await http.post(
                  Uri.parse('${dotenv.env['API_URL']!}/user/login'),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode({'email': email, 'password': password}),
                );

                if (response.statusCode == 200) {
                  final responseData = jsonDecode(response.body);
                  final token = responseData['token'];

                  final secureStorage = FlutterSecureStorage();
                  await secureStorage.write(
                    key: dotenv.env['SECURE_STORAGE_SECRET']!,
                    value: token,
                  );

                  if (!context.mounted) return;
                  Navigator.pushReplacementNamed(context, '/search');
                } else {
                  if (!context.mounted) return;
                  showMessage(context, "Login failed.");
                }
              }
            },
          ),
          // a temporary button to skip the login
          SizedBox(height: 180),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/search');
            },
            child: Text("SKIP"),
          ),
        ],
      ),
    );
  }
}

class Login extends StatelessWidget {
  const Login({super.key});

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
              Text('Login', style: Theme.of(context).textTheme.displayLarge),
              FormScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
