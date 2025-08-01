import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/widgets/customFormField.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
                return 'This field is empty';
              }
              if (!value.trim().endsWith('@gmail.com')) {
                return 'Not a valid email.';
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          CustomTextField(
            label: 'Password',
            controller: _passwordController,
            obscureText: true,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'This field is empty';
              }
              return null;
            },
          ),
          const SizedBox(height: 80),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.transparent),
              elevation: WidgetStateProperty.all(0),
              shadowColor: WidgetStateProperty.all(Colors.transparent),
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              splashFactory: NoSplash.splashFactory,
              padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Make an account',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 10),
                Icon(Icons.arrow_forward_rounded, color: Colors.white),
              ],
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/signup');
            },
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              child: Text(
                "LOGIN",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                final form = _formKey.currentState!;

                if (form.validate()) {
                  final email = _emailController.text.trim();
                  final password = _passwordController.text;

                  final response = await http.post(
                    Uri.parse('${dotenv.env['API_URL']!}/auth/login'),
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode({'email': email, 'password': password}),
                  );

                  if (response.statusCode == 200) {
                    final responseData = jsonDecode(response.body);
                    final token = responseData['token'];

                    // Save token securely (e.g., SharedPreferences or secure_storage)
                    print("Login successful! Token: $token");

                    Navigator.pushNamed(context, '/homepage');
                  } else {
                    print("Login failed: ${response.body}");
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Login failed')));
                  }
                }
              },
            ),
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
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              FormScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
