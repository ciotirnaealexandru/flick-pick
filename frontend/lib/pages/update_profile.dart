import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/custom_form_field.dart';
import 'package:frontend/services/user_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/user_model.dart';

class UpdateProfileForm extends StatefulWidget {
  final User userInfo;
  final Future<void> Function() loadUserInfo;

  const UpdateProfileForm(this.userInfo, this.loadUserInfo, {super.key});

  @override
  State<UpdateProfileForm> createState() => _UpdateProfileFormState();
}

class _UpdateProfileFormState extends State<UpdateProfileForm> {
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
          const SizedBox(height: 30),
          CustomTextField(
            label: "First Name",
            controller: _firstNameController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'This field is empty.';
              }
              return null;
            },
          ),

          const SizedBox(height: 30),
          CustomTextField(
            label: "Last Name",
            controller: _lastNameController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'This field is empty.';
              }
              return null;
            },
          ),

          const SizedBox(height: 30),
          CustomTextField(
            label: "Email",
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

          const SizedBox(height: 30),
          CustomTextField(
            label: "Phone number",
            controller: _phoneController,
            validator: (value) {
              // allow empty phone number
              if (value == null || value.trim().isEmpty) return null;

              final normalized = value.trim();
              final pattern = RegExp(r'^\d{4} \d{3} \d{3}$');

              if (!pattern.hasMatch(normalized)) {
                return 'Phone must be in format: XXXX XXX XXX.';
              }
              return null;
            },
          ),

          const SizedBox(height: 50),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: Text(
                  "UPDATE",
                  style: Theme.of(context).textTheme.bodyLarge,
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
                        '${dotenv.env['API_URL']!}/user/${widget.userInfo.id}',
                      ),
                      headers: {
                        'Content-Type': 'application/json',
                        'Authorization': 'Bearer $token',
                      },
                      body: jsonEncode({
                        'newFirstName': firstName,
                        'newLastName': lastName,
                        'newEmail': email,
                        'newPhone': phone,
                      }),
                    );

                    if (response.statusCode == 200) {
                      print("Profile changed successfully.");

                      await widget.loadUserInfo();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Profile changed successfully."),
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
                          content: Text(message),
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

class DeleteProfileButton extends StatefulWidget {
  final User userInfo;
  final Future<void> Function() loadUserInfo;

  const DeleteProfileButton(this.userInfo, this.loadUserInfo, {super.key});

  @override
  State<DeleteProfileButton> createState() => _DeleteProfileButtonState();
}

class _DeleteProfileButtonState extends State<DeleteProfileButton> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          child: Text(
            "DELETE",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  insetPadding: EdgeInsets.all(16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  title: Text(
                    "Confirm Delete",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  content: Text(
                    "Are you sure you want to delete your profile? This cannot be undone.",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed:
                          () => Navigator.of(context).pop(false), // cancel
                      child: Text(
                        "Cancel",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                      onPressed:
                          () => Navigator.of(context).pop(true), // confirm
                      child: Text(
                        "Delete",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );

            // If user confirmed deletion
            if (confirmed == true) {
              final secureStorage = FlutterSecureStorage();
              final token = await secureStorage.read(
                key: dotenv.env['SECURE_STORAGE_SECRET']!,
              );

              final response = await http.delete(
                Uri.parse(
                  '${dotenv.env['API_URL']!}/user/${widget.userInfo.id}',
                ),
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer $token',
                },
              );

              if (response.statusCode == 200) {
                print("Profile deleted successfully!");

                // remove the JWT token
                final secureStorage = FlutterSecureStorage();
                await secureStorage.delete(
                  key: dotenv.env['SECURE_STORAGE_SECRET']!,
                );

                Navigator.pushReplacementNamed(context, '/login');
              } else {
                print("Response body: ${response.body}");

                final responseData = jsonDecode(response.body);
                final message =
                    responseData['message'] ?? 'Something went wrong.';

                // show a message of the error
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
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
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 40),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Update Profile',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                UpdateProfileForm(userInfo!, loadUserInfo),
                SizedBox(height: 10),
                DeleteProfileButton(userInfo!, loadUserInfo),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
