import 'package:delivery_guys_fyp/components/button.dart';
import 'package:delivery_guys_fyp/components/textfield.dart';
import 'package:delivery_guys_fyp/sigin_sigup/comlete_registration.dart';
import 'package:flutter/material.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final usernamecontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final confirmpasswordcontroller = TextEditingController();
  String _selectedRole = " ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 183, 231, 254),
      appBar: AppBar(
        title: const Text("Registration Form"),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              height: 580,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(30)),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    "Register Yourself For An Experience",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 25),
                  MyTextField(
                    controller: usernamecontroller,
                    hinttext: "Email Address",
                    obscuretext: false,
                    enabled: true,
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: passwordcontroller,
                    hinttext: "Password",
                    obscuretext: true,
                    enabled: true,
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: confirmpasswordcontroller,
                    hinttext: "Confirm Password",
                    obscuretext: true,
                    enabled: true,
                  ),
                  const SizedBox(height: 15),
                  Container(
                    width: 300,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 2.5, color: Colors.black),
                        borderRadius: BorderRadius.circular(30)),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          "Register your self as",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                        ListTile(
                          title: const Text('Customer'),
                          leading: Radio<String>(
                            value: 'Customer',
                            groupValue: _selectedRole,
                            onChanged: (String? value) {
                              setState(() {
                                _selectedRole = value!;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('Grocery Store'),
                          leading: Radio<String>(
                            value: 'Grocery Store',
                            groupValue: _selectedRole,
                            onChanged: (String? value) {
                              setState(() {
                                _selectedRole = value!;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('Driver'),
                          leading: Radio<String>(
                            value: 'Driver',
                            groupValue: _selectedRole,
                            onChanged: (String? value) {
                              setState(() {
                                _selectedRole = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  MyButton(
                    color: Colors.purple,
                    heigh: 50,
                    widt: 180,
                    hintText: 'Next',
                    onTap: () {
                      if (passwordcontroller.text ==
                          confirmpasswordcontroller.text) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return CRegistration(
                            email: usernamecontroller.text,
                            password: passwordcontroller.text,
                            role: _selectedRole,
                            text: _selectedRole == "Grocery Store"
                                ? "Store Name"
                                : "Full Name",
                          );
                        }));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Passwords do not match")),
                        );
                      }
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
