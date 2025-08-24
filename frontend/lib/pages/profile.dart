import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/components/navbar.dart';
import 'package:frontend/components/custom_form_field.dart';
import 'package:frontend/services/auth_service.dart';
import '../models/user_model.dart';

class FormScreen extends StatefulWidget {
  final User userInfo;

  const FormScreen(this.userInfo, {super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final secureStorage = FlutterSecureStorage();

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
            initialValue: widget.userInfo.firstName,
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
            initialValue: widget.userInfo.lastName,
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
            initialValue: widget.userInfo.email,
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
                onPressed: () {
                  final form = _formKey.currentState!;

                  if (form.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Profile changed successfully!',
                          style: TextStyle(
                            color: Color.fromARGB(255, 178, 166, 255),
                          ),
                        ),
                        backgroundColor: const Color.fromARGB(255, 28, 37, 51),
                        duration: const Duration(seconds: 2),
                      ),
                    );
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
      appBar: AppBar(
        title: Column(children: [Navbar()]),
        backgroundColor: const Color.fromARGB(255, 5, 12, 28),
      ),
      body: Container(
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
            FormScreen(userInfo!),
            /*
            Text(
              "EDIT PROFILE",
              style: TextStyle(
                color: Color.fromARGB(255, 178, 166, 255),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              children: [
                Text("Id: ${userInfo!.id}"),
                Text("First Name: ${userInfo!.firstName}"),
                Text("Last Name: ${userInfo!.lastName}"),
                Text("Email Name: ${userInfo!.email}"),
              ],
            ),
            */
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 5, 12, 28),
    );
  }
}
