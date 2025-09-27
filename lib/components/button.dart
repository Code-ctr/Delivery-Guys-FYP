import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String? hintText;
  final String? imagePath; // New parameter for the image path
  final Color? color;
  final double? heigh;
  final double? widt;

  const MyButton(
      {super.key,
      required this.onTap,
      this.hintText,
      this.imagePath,
      this.color,
      this.heigh,
      this.widt // Initialize the new parameter
      });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25),
        height: heigh ?? 50,
        width: widt ?? 200, // You can adjust the height as needed
        decoration: BoxDecoration(
          color: color ?? Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(20), // Ensure rounded corners for the image
          child: Stack(
            fit: StackFit.expand, // Ensure the stack fills the container
            children: [
              // Background image
              if (imagePath != null)
                Image.asset(
                  imagePath!,
                  fit: BoxFit.cover,
                ),
              // Text on top of image
              Center(
                child: Text(
                  hintText ?? "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    shadows: [
                      Shadow(
                        offset: Offset(1.0, 1.0),
                        blurRadius: 3.0,
                        color: Colors.black38,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
