import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/components/bars/navbar.dart';
import 'package:frontend/components/buttons/button_models/custom_filled_button.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/services/user_service.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with RouteAware {
  User? userInfo;

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    super.didPopNext();
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
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.onPrimary,
                        width: 2.0,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 76,
                      backgroundImage: const AssetImage(
                        'assets/images/purple.jpeg',
                      ),
                    ),
                  ),
                ],
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
              SizedBox(height: 30),
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
                          (userInfo?.phone?.isNotEmpty == true)
                              ? userInfo!.phone!
                              : "No phone number.",
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
                child: Text("Edit Profile"),
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

                child: Text("Logout"),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Navbar(),
    );
  }
}
