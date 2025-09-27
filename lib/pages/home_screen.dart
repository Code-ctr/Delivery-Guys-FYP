import 'package:delivery_guys_fyp/components/button.dart';
import 'package:delivery_guys_fyp/components/slide_bar.dart';
import 'package:delivery_guys_fyp/pages/Grocery/store_chossing.dart';
import 'package:delivery_guys_fyp/pages/Water/water_home.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 124, 241, 128),
      appBar: AppBar(
        title: const Text("Home Screen"),
        actions: const [ManageProfilePage()],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Container(
                    height: screenHeight * 0.8, // Responsive height
                    width: screenWidth * 0.9, // Responsive width
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          "Welcome to Delivery Guys",
                          style: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                            height: screenHeight * 0.02), // Responsive spacing
                        MyButton(
                          heigh:
                              screenHeight * 0.26, // Responsive button height
                          widt: screenWidth * 0.8, // Responsive button width
                          imagePath: "lib/images/Tank.png",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return const MyWidget();
                              }),
                            );
                          },
                        ),
                        const Text(
                          "Order Water Tanker",
                          style: TextStyle(
                            color: Color.fromARGB(255, 48, 72, 92),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                            height: screenHeight * 0.05), // Responsive spacing
                        MyButton(
                          heigh:
                              screenHeight * 0.26, // Responsive button height
                          widt: screenWidth * 0.8, // Responsive button width
                          imagePath: "lib/images/GroceryLogo.jpeg.jpg",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return const StoreChossing();
                              }),
                            );
                          },
                        ),
                        const Text(
                          "Order Grocery",
                          style: TextStyle(
                            color: Color.fromARGB(255, 48, 72, 92),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
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
