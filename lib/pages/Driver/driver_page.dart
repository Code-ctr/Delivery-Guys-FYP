import 'package:delivery_guys_fyp/components/button.dart';
import 'package:delivery_guys_fyp/components/slide_bar.dart';
import 'package:delivery_guys_fyp/pages/Driver/new_order.dart';
import 'package:delivery_guys_fyp/pages/Driver/pre_order.dart';
import 'package:delivery_guys_fyp/pages/FireBase/fire_registeration.dart';
import 'package:delivery_guys_fyp/pages/Water/history.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DriverHome extends StatefulWidget {
  const DriverHome({super.key});

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  final AuthService _authService = AuthService();
  String? name;

  @override
  void initState() {
    super.initState();
    _getName();
  }

  Future<void> _getName() async {
    User? userId = _authService.getCurrentUser();
    String? userName;
    if (userId != null) {
      userName = await _authService.getUserFullName(userId.uid);
    }
    setState(() {
      name = userName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 71, 85, 96),
      appBar: AppBar(
        title: const Text("Home"),
        actions: const [ManageProfilePage()],
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Easse to your Bussians & And Comfart To You",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 480,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(25.0)),
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    MyButton(
                        heigh: 140,
                        widt: 300,
                        color: const Color.fromARGB(255, 56, 81, 84),
                        hintText: 'New Orders',
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const NewOrders();
                          }));
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    MyButton(
                        heigh: 140,
                        widt: 300,
                        color: const Color.fromARGB(255, 56, 81, 84),
                        hintText: 'Pre Orders',
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const PreOrders();
                          }));
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    MyButton(
                        heigh: 140,
                        widt: 300,
                        color: const Color.fromARGB(255, 56, 81, 84),
                        hintText: 'History',
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return History(name: name!, role: 'driverName');
                          }));
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
