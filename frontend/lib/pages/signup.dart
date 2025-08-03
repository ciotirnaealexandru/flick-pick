import 'package:flutter/material.dart';
import 'package:frontend/widgets/customFormField.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final secureStorage = FlutterSecureStorage();

  // used to check if passwords match
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
            label: 'First Name',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'This field is empty';
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          CustomTextField(
            label: 'Last Name',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'This field is empty';
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          CustomTextField(
            label: 'Email',
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
              if (value.length < 8) {
                return 'Password must be at least 8 characters';
              }
              if (!RegExp(r'[A-Z]').hasMatch(value)) {
                return 'Add at least one uppercase letter';
              }
              if (!RegExp(r'[0-9]').hasMatch(value)) {
                return 'Add at least one number';
              }

              return null;
            },
          ),
          const SizedBox(height: 15),
          CustomTextField(
            label: 'Confirm Password',
            controller: _confirmPasswordController,
            obscureText: true,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'This field is empty';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 30),
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
                  'Already have an account?',
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
            onPressed: () async {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              child: Text(
                "SIGN UP",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                final form = _formKey.currentState!;

                if (form.validate()) {
                  Navigator.pushNamed(context, '/login');
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
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
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sign Up',
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
