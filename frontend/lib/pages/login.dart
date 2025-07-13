import 'package:flutter/material.dart';
import 'package:frontend/widgets/customFormField.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 30),
          CustomTextField(
            label: 'Email',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'This field is empty';
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          CustomTextField(
            label: 'Password',
            obscureText: true,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'This field is empty';
              }
              return null;
            },
          ),
          const SizedBox(height: 100),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.transparent),
              elevation: WidgetStateProperty.all(0),
              shadowColor: WidgetStateProperty.all(Colors.transparent),
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              splashFactory: NoSplash.splashFactory,
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
              onPressed: () {
                final form = _formKey.currentState!;

                if (form.validate()) {
                  Navigator.pushNamed(context, '/homepage');
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
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        margin: const EdgeInsets.only(top: 90, bottom: 90, left: 50, right: 50),
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
    );
  }
}
