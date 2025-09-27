import 'package:delivery_guys_fyp/pages/Driver/driver_page.dart';
import 'package:delivery_guys_fyp/pages/FireBase/fire_registeration.dart';
import 'package:delivery_guys_fyp/pages/GroceryStore/gs_home.dart';
import 'package:delivery_guys_fyp/pages/home_screen.dart';
import 'package:delivery_guys_fyp/sigin_sigup/forget_password.dart';
import 'package:delivery_guys_fyp/sigin_sigup/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ManageProfilePage extends StatefulWidget {
  const ManageProfilePage({super.key});

  @override
  State<ManageProfilePage> createState() => _ManageProfilePageState();
}

class _ManageProfilePageState extends State<ManageProfilePage> {
  String role = "";
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _getUserRole();
  }

  void _getUserRole() async {
    User? user = _authService.getCurrentUser();
    if (user != null) {
      String? userRole = await _authService.getUserRole(user.uid);

      setState(() {
        if (userRole != null) role = userRole;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      onSelected: (value) async {
        switch (value) {
          case 0:
            if (role == 'Customer') {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) {
                return const HomePage();
              }), (route) => route.isFirst);
            } else if (role == "Grocery Store") {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) {
                return const GroceryStoreHomePage();
              }), (route) => route.isFirst);
            } else {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) {
                return const DriverHome();
              }), (route) => route.isFirst);
            }
            break;
          case 1:
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ForgetPassword()));
            break;
          case 2:
            try {
              await FirebaseAuth.instance.signOut();
              // ignore: use_build_context_synchronously
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) {
                return const LoginPage();
              }), (route) => route.isFirst);
            } catch (e) {
              print(e);
            }

            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 0,
          child: Row(
            children: [
              Icon(Icons.home, color: Colors.black),
              SizedBox(width: 8),
              Text('Home'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              Icon(Icons.lock, color: Colors.black),
              SizedBox(width: 8),
              Text('Change Password'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              Icon(Icons.logout, color: Colors.black),
              SizedBox(width: 8),
              Text('Log Out'),
            ],
          ),
        ),
      ],
      icon: const Icon(Icons.menu),
    );
  }
}
