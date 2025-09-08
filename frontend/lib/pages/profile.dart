import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/components/bars/navbar.dart';
import 'package:frontend/components/buttons/button_models/custom_filled_button.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/services/user_service.dart';

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
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(automaticallyImplyLeading: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              CircleAvatar(
                radius: 80, // size of the circle
                backgroundColor:
                    Theme.of(
                      context,
                    ).colorScheme.primary, // circle background color
                child: Icon(Icons.person, size: 120),
              ),
              SizedBox(height: 20),
              Text(
                userInfo!.firstName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                userInfo!.lastName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.email,
                          size: 25,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        SizedBox(width: 15),
                        Text(
                          userInfo!.email,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          size: 25,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        SizedBox(width: 15),
                        Text(
                          userInfo!.phone ?? "No phone number.",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 80),
              CustomFilledButton(
                onPressed:
                    () => {Navigator.pushNamed(context, '/update_profile')},
                child: Text("UPDATE PROFILE"),
              ),
              SizedBox(height: 10),
              CustomFilledButton(
                onPressed: () async {
                  // remove the JWT token
                  final secureStorage = FlutterSecureStorage();
                  await secureStorage.delete(key: "auth_token");

                  if (!context.mounted) return;
                  Navigator.pushReplacementNamed(context, '/login');
                },

                child: Text("LOGOUT"),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Navbar(),
    );
  }
}
