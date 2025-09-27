import 'package:delivery_guys_fyp/components/button.dart';
import 'package:delivery_guys_fyp/components/textfield.dart';
import 'package:delivery_guys_fyp/sigin_sigup/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatelessWidget {
  ForgetPassword({super.key});

  final emailcon = TextEditingController();
  final passwdcon = TextEditingController();
  final confpasswdcon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forget Password"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
          child: Column(
        children: [
          const SizedBox(
            height: 80,
          ),
          Center(
            child: Container(
              height: 430,
              width: 350,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(30)),
              child: Column(children: [
                const SizedBox(
                  height: 110,
                ),
                MyTextField(
                    controller: emailcon,
                    hinttext: "Enter your email address",
                    obscuretext: false,
                    enabled: true),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                    controller: passwdcon,
                    hinttext: "New Password",
                    obscuretext: false,
                    enabled: true),
                const SizedBox(
                  height: 10,
                ),
                MyTextField(
                    controller: confpasswdcon,
                    hinttext: "Confirme password",
                    obscuretext: false,
                    enabled: true),
                const SizedBox(
                  height: 50,
                ),
                MyButton(
                    color: Colors.black,
                    hintText: "Change Password",
                    onTap: () async {
                      String email = emailcon.text.trim();
                      String newPassword = passwdcon.text.trim();
                      String confirmPassword = confpasswdcon.text.trim();

                      if (newPassword != confirmPassword) {
                        // Show an error message if passwords don't match
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Passwords do not match')),
                        );
                        return;
                      }

                      try {
                        User? user = FirebaseAuth.instance.currentUser;

                        if (user != null && user.email == email) {
                          // Update the password
                          await user.updatePassword(newPassword);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Password changed successfully')),
                          );
                          // Navigate to login page after successful password change
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return const LoginPage();
                          }));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Error: No user found with this email')),
                          );
                        }
                      } catch (e) {
                        // Handle errors such as re-authentication required or other issues
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    })
              ]),
            ),
          ),
        ],
      )),
    );
  }
}
