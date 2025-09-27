import 'package:delivery_guys_fyp/components/button.dart';
import 'package:delivery_guys_fyp/components/textfield.dart';
import 'package:delivery_guys_fyp/pages/FireBase/fire_registeration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CRegistration extends StatefulWidget {
  final String role;
  final String text;
  final String email;
  final String password;
  const CRegistration({
    super.key,
    required this.email,
    required this.password,
    required this.role,
    required this.text,
  });

  @override
  State<CRegistration> createState() => _CRegistrationState();
}

class _CRegistrationState extends State<CRegistration> {
  final fullname = TextEditingController();
  final addresscon = TextEditingController();
  final phonecon = TextEditingController();
  final tankinfo = TextEditingController();
  final AuthService _authService = AuthService();
  String? userToken = "";

  @override
  void initState() {
    super.initState();
    _setinguserToken();
  }

  Future<void> _setinguserToken() async {
    String t = await _authService.getUserTokenMessaging();
    setState(() {
      userToken = t;
    });
  }

  // Dropdown menu items for locations
  final List<String> locations = [
    " ",
    "Saryab Road",
    "Bazar",
    "New Khili",
    "Jinna Town",
    "Steliate Town"
  ];

  // Dropdown menu items for tanker info
  final List<String> tankerOptions = ["500 Liter", "1000 Liter", "1500 Liter"];

  // Selected location and tanker info
  String selectedLocation = " ";
  String selectedTanker = "500 Liter";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 183, 231, 254),
      appBar: AppBar(
        title: const Text("Complete Registration"),
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
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  MyTextField(
                    controller: fullname,
                    hinttext: widget.text,
                    obscuretext: false,
                    enabled: true,
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    controller: phonecon,
                    hinttext: "Phone Number",
                    obscuretext: false,
                    enabled: true,
                  ),
                  const SizedBox(height: 15),
                  MyTextField(
                    controller: addresscon,
                    hinttext: "Address",
                    obscuretext: false,
                    enabled: true,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Please Select Your Location",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    value: selectedLocation,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedLocation = newValue!;
                      });
                    },
                    items: locations.map<DropdownMenuItem<String>>(
                      (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList(),
                  ),
                  const SizedBox(height: 15),
                  if (widget.role == "Driver")
                    Column(
                      children: [
                        const Text(
                          "Please Select Your Tanker Info",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 10),
                        DropdownButton<String>(
                          value: selectedTanker,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedTanker = newValue!;
                            });
                          },
                          items: tankerOptions.map<DropdownMenuItem<String>>(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            },
                          ).toList(),
                        ),
                      ],
                    ),
                  const SizedBox(height: 30),
                  MyButton(
                    color: Colors.purple,
                    heigh: 50,
                    widt: 180,
                    hintText: 'Complete Registration',
                    onTap: () async {
                      if (fullname.text.isEmpty ||
                          phonecon.text.isEmpty ||
                          addresscon.text.isEmpty ||
                          selectedLocation == " ") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please fill in all the fields"),
                          ),
                        );
                        return;
                      }

                      final userInfo = {
                        'email': widget.email,
                        'role': widget.role,
                        'fullName': fullname.text,
                        'phone': phonecon.text,
                        'address': addresscon.text,
                        'location': selectedLocation,
                        'tanker':
                            widget.role == 'Driver' ? selectedTanker : null,
                        'status': widget.role == 'Driver' ? 'available' : null,
                        'token': userToken,
                        'state': 'active'
                      };

                      User? user =
                          await _authService.registerWithEmailAndPassword(
                        widget.email,
                        widget.password,
                        userInfo,
                      );

                      if (user != null) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Registration successful"),
                          ),
                        );
                        Navigator.pop(
                            // ignore: use_build_context_synchronously
                            context); // Go back to the previous screen
                      } else {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Registration failed"),
                          ),
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
