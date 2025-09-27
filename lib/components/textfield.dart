import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hinttext;
  final bool obscuretext;
  final bool enabled; // New parameter

  const MyTextField({
    super.key,
    required this.controller,
    required this.hinttext,
    required this.obscuretext,
    required this.enabled, // New parameter
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        decoration: const BoxDecoration(color: Colors.white),
        width: 350,
        height: 60,
        child: TextField(
          controller: controller,
          obscureText: obscuretext,
          enabled: enabled, // Use the new parameter
          decoration: InputDecoration(
            hintText: hinttext,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: const BorderSide(width: 2, color: Colors.black),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: const BorderSide(width: 2, color: Colors.black),
            ),
            fillColor: Colors.white,
            filled: true,
          ),
        ),
      ),
    );
  }
}
