import 'package:flutter/material.dart';
import 'package:frontend/components/navbar.dart';
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
      appBar: AppBar(title: Navbar()),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
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
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  userInfo!.lastName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 400,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.email, size: 30),
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
                          Icon(Icons.phone, size: 30),
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
                SizedBox(
                  width: 250,
                  height: 40,
                  child: ElevatedButton(
                    onPressed:
                        () => {Navigator.pushNamed(context, '/update_profile')},
                    child: Text(
                      "UPDATE PROFILE",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 250,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () => {},
                    child: Text(
                      "LOGOUT",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
