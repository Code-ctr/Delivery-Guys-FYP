import 'package:delivery_guys_fyp/components/button.dart';
import 'package:delivery_guys_fyp/pages/Water/delivery.dart';
import 'package:flutter/material.dart';

class TankBox extends StatelessWidget {
  final String hinttext;
  final String liter;
  final String ordertype;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;

  const TankBox({
    super.key,
    required this.hinttext,
    required this.liter,
    required this.ordertype,
    this.selectedDate,
    this.selectedTime,
  });

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Center(
      child: Container(
        height: screenHeight * 0.35, // Responsive height
        width: screenWidth * 0.9, // Responsive width
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
          border: Border.all(color: Colors.blueGrey.shade400),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/images/Tank.png',
                  height: screenHeight * 0.15, // Responsive image height
                ),
                SizedBox(height: screenHeight * 0.02), // Responsive spacing
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$liter Liter\nRs$hinttext",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * 0.05, // Responsive font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    MyButton(
                      hintText: "Order Now",
                      color: Colors.deepPurple,
                      heigh: screenHeight * 0.07, // Responsive button height
                      widt: screenWidth * 0.3, // Responsive button width
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return Delivery(
                              type: ordertype,
                              price: hinttext,
                              selectedDate: selectedDate,
                              selectedTime: selectedTime,
                            );
                          }),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
