import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/navbar.dart';
import 'package:frontend/components/custom_form_field.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/user_model.dart';

class FormScreen extends StatefulWidget {
  final User userInfo;
  final Future<void> Function() loadUserInfo;

  const FormScreen(this.userInfo, this.loadUserInfo, {super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  late TextEditingController _firstNameController = TextEditingController();
  late TextEditingController _lastNameController = TextEditingController();
  late TextEditingController _emailController = TextEditingController();
  late TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(
      text: widget.userInfo.firstName,
    );
    _lastNameController = TextEditingController(text: widget.userInfo.lastName);
    _emailController = TextEditingController(text: widget.userInfo.email);
    _phoneController = TextEditingController(text: widget.userInfo.phone);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            'First Name',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 178, 166, 255),
            ),
          ),

          const SizedBox(height: 10),
          CustomTextField(
            controller: _firstNameController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'This field is empty';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),
          Text(
            'Last Name',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 178, 166, 255),
            ),
          ),
          const SizedBox(height: 10),

          CustomTextField(
            controller: _lastNameController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'This field is empty';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),
          Text(
            'Email',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 178, 166, 255),
            ),
          ),
          const SizedBox(height: 10),

          CustomTextField(
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

          const SizedBox(height: 20),
          Text(
            'Phone number',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 178, 166, 255),
            ),
          ),
          const SizedBox(height: 10),

          CustomTextField(
            controller: _phoneController,
            validator: (value) {
              // allow empty
              if (value == null || value.trim().isEmpty) return null;

              final normalized = value.trim();
              final pattern = RegExp(r'^\d{4} \d{3} \d{3}$');

              if (!pattern.hasMatch(normalized)) {
                return 'Phone must be in format: XXXX XXX XXX';
              }
              return null;
            },
          ),

          const SizedBox(height: 60),

          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 200,
              height: 40,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Color.fromARGB(255, 28, 37, 51),
                  ),
                ),
                child: Text(
                  "UPDATE",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 178, 166, 255),
                  ),
                ),
                onPressed: () async {
                  final form = _formKey.currentState!;

                  if (form.validate()) {
                    final firstName = _firstNameController.text.trim();
                    final lastName = _lastNameController.text.trim();
                    final email = _emailController.text.trim();
                    final phone = _phoneController.text.trim();

                    final secureStorage = FlutterSecureStorage();
                    final token = await secureStorage.read(
                      key: dotenv.env['SECURE_STORAGE_SECRET']!,
                    );

                    final response = await http.patch(
                      Uri.parse(
                        '${dotenv.env['API_URL']!}/user/id/${widget.userInfo.id}',
                      ),
                      headers: {
                        'Content-Type': 'application/json',
                        'Authorization': 'Bearer $token',
                      },
                      body: jsonEncode({
                        'firstName': firstName,
                        'lastName': lastName,
                        'email': email,
                        'phone': phone,
                      }),
                    );

                    if (response.statusCode == 200) {
                      print("Profile changed successfully!");

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Profile changed successfully!",
                            style: TextStyle(
                              color: Color.fromARGB(255, 178, 166, 255),
                            ),
                          ),
                          backgroundColor: const Color.fromARGB(
                            255,
                            28,
                            37,
                            51,
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    } else {
                      print("Response body: ${response.body}");

                      final responseData = jsonDecode(response.body);
                      final message =
                          responseData['message'] ?? 'Something went wrong.';

                      // show a message of the error
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            message,
                            style: TextStyle(
                              color: Color.fromARGB(255, 178, 166, 255),
                            ),
                          ),
                          backgroundColor: const Color.fromARGB(
                            255,
                            28,
                            37,
                            51,
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? userInfo;

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    final user = await getUserInfo();
    setState(() {
      userInfo = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userInfo == null) {
      return Center(
        child: CircularProgressIndicator(
          color: Color.fromARGB(255, 178, 166, 255),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Column(children: [Navbar()]),
        backgroundColor: const Color.fromARGB(255, 5, 12, 28),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: const Color.fromARGB(255, 5, 12, 28),
            width: double.infinity,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 178, 166, 255),
                  ),
                ),
                FormScreen(userInfo!, loadUserInfo),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 5, 12, 28),
    );
  }
}
