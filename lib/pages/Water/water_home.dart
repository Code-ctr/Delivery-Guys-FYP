import 'package:delivery_guys_fyp/components/button.dart';
import 'package:delivery_guys_fyp/components/location_showing_customer.dart';
import 'package:delivery_guys_fyp/components/slide_bar.dart';
import 'package:delivery_guys_fyp/pages/FireBase/fire_registeration.dart';
import 'package:delivery_guys_fyp/pages/Water/history.dart';
import 'package:delivery_guys_fyp/pages/Water/orderpage.dart';
import 'package:delivery_guys_fyp/pages/Water/preorder_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
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
      backgroundColor: const Color.fromARGB(255, 130, 202, 236),
      appBar: AppBar(
        title: const Text("Water Tanker"),
        backgroundColor: Colors.blue,
        actions: const [ManageProfilePage()],
      ),
      floatingActionButton: SizedBox(
        height: 80,
        width: 80,
        child: FloatingActionButton(
          enableFeedback: true,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const DriverTrackingMap();
            }));
          },
          backgroundColor: const Color.fromARGB(255, 98, 169, 227),
          child: const Icon(Icons.location_on),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(35)),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      "Order Fresh Water Full of Mineral",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyButton(
                    heigh: 150,
                    widt: 300,
                    hintText: "Order Water Tanker",
                    color: const Color.fromARGB(255, 171, 202, 227),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (constext) {
                        return const OrderPage(
                          type: "New Order",
                        );
                      }));
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyButton(
                    heigh: 150,
                    widt: 300,
                    hintText: "Pre Order",
                    color: const Color.fromARGB(255, 171, 202, 227),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (constext) {
                        return const PreOrderPage();
                      }));
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyButton(
                    heigh: 150,
                    widt: 300,
                    hintText: "History",
                    color: const Color.fromARGB(255, 171, 202, 227),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (constext) {
                        return History(name: name!, role: 'userName');
                      }));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
