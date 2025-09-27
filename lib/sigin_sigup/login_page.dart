// ignore_for_file: use_build_context_synchronously
import 'package:delivery_guys_fyp/components/button.dart';
import 'package:delivery_guys_fyp/components/textfield.dart';
import 'package:delivery_guys_fyp/pages/Driver/driver_page.dart';
import 'package:delivery_guys_fyp/pages/FireBase/fire_registeration.dart';
import 'package:delivery_guys_fyp/pages/GroceryStore/gs_home.dart';
import 'package:delivery_guys_fyp/pages/home_screen.dart';
import 'package:delivery_guys_fyp/sigin_sigup/registraion.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernamecontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  height: 300,
                  child: Image.asset(
                    'lib/images/DeliveryGuyLogo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 30),
                MyTextField(
                  controller: usernamecontroller,
                  hinttext: 'Email',
                  obscuretext: false,
                  enabled: true,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordcontroller,
                  hinttext: 'Password',
                  obscuretext: true,
                  enabled: true,
                ),
                const SizedBox(height: 15),
                MyButton(
                  heigh: 50,
                  widt: 200,
                  color: Colors.black,
                  onTap: () async {
                    String email = usernamecontroller.text.trim();
                    String password = passwordcontroller.text.trim();

                    User? user = await _authService.loginWithEmailAndPassword(
                        email, password);

                    if (user != null) {
                      String? state = await _authService.getUserState(user.uid);
                      if (state != null && state == 'active') {
                        String? role = await _authService.getUserRole(user.uid);
                        if (role != null) {
                          if (role == "Customer") {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const HomePage();
                            }));
                          } else if (role == "Grocery Store") {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const GroceryStoreHomePage();
                            }));
                          } else if (role == "Driver") {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const DriverHome();
                            }));
                          }
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Login Error"),
                                content: const Text("Role not found."),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Close"),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("User Not Found"),
                              content: const Text(
                                  "No user is registered with the provided data."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Close"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("User Block"),
                            content: const Text(
                                "User is been Blocked by the admin of app"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Close"),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  hintText: 'Sign in',
                ),
                const SizedBox(height: 10),
                MyButton(
                  widt: 150,
                  hintText: "Sign up",
                  color: Colors.black,
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const Registration();
                    }));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
