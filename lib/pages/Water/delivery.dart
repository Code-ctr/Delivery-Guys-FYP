import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_guys_fyp/components/address_change.dart';
import 'package:delivery_guys_fyp/components/button.dart';
import 'package:delivery_guys_fyp/components/customize_order.dart';
import 'package:delivery_guys_fyp/components/slide_bar.dart';
import 'package:delivery_guys_fyp/pages/FireBase/fire_registeration.dart';
import 'package:delivery_guys_fyp/pages/FireBase/notification_service.dart';
import 'package:delivery_guys_fyp/pages/Water/water_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Delivery extends StatefulWidget {
  final String price;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final String type;

  const Delivery({
    super.key,
    required this.price,
    required this.type,
    this.selectedDate,
    this.selectedTime,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DeliveryState createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  final AuthService _authService = AuthService();
  String address = "x";
  String mobileNumber = '0322 2413456';
  String name = "";
  String uuid = "";
  String? selectedDriver;
  String? selectedLocation;
  String? token = "";
  List<String> driverNames = [];
  int charges = 0;

  @override
  void initState() {
    super.initState();
    _getUserDetails();
    fetchDrivers();
  }

  Future<void> fetchDrivers() async {
    try {
      List<Map<String, dynamic>> drivers =
          await _authService.getAvailableDrivers();
      setState(() {
        driverNames = drivers
            .map((driver) => driver['fullName'] as String?)
            .where((name) => name != null)
            .cast<String>()
            .toList();
      });
    } catch (e) {
      debugPrint("Error fetching drivers: $e");
    }
  }

  int k() {
    Random random = Random();
    if (driverNames.isNotEmpty) {
      return random.nextInt(driverNames.length);
    } else {
      return 0;
    }
  }

  Future<void> _getUserDetails() async {
    User? user = _authService.getCurrentUser();
    if (user != null) {
      String uid = user.uid;

      String? userAddress = await _authService.getUserAddress(uid);
      String? userMobileNo = await _authService.getUserMobileNo(uid);
      String? username = await _authService.getUserFullName(uid);

      setState(() {
        if (userAddress != null) address = userAddress;
        if (userMobileNo != null) mobileNumber = userMobileNo;
        if (username != null) name = username;
        uuid = user.uid;
      });
    } else {
      debugPrint("User is not authenticated");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 130, 188, 235),
      appBar: AppBar(
        title: const Text("Delivery Detail"),
        backgroundColor: Colors.blue,
        actions: const [ManageProfilePage()],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.02),
            Center(
              child: Container(
                height: screenHeight * 0.59,
                width: screenWidth * 0.95,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(45),
                ),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.03),
                    const Text(
                      'Delivery Address',
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      child: Container(
                        height: screenHeight * 0.3,
                        width: screenWidth * 0.92,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 2, color: Colors.black),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: SingleChildScrollView(
                          child: Center(
                            child: Column(
                              children: [
                                SizedBox(height: screenHeight * 0.02),
                                AddressMobileContainer(
                                  label: 'Address',
                                  content: address,
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                const Divider(
                                  thickness: 2,
                                  color: Colors.amber,
                                ),
                                AddressMobileContainer(
                                  label: 'Mobile Number',
                                  content: mobileNumber,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    MyButton(
                      color: const Color.fromARGB(255, 208, 176, 248),
                      hintText: "Change Personal info",
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeAddress(
                              address: address,
                              mobileNumber: mobileNumber,
                            ),
                          ),
                        );

                        if (result != null) {
                          setState(() {
                            address = result['address'];
                            mobileNumber = result['mobileNumber'];
                            charges = result['charges'];
                          });
                        }
                      },
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    const PaymentOptionButton(
                      label: "Cash On Delivery",
                    ),
                    SizedBox(height: screenHeight * 0.01),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            MyButton(
              widt: screenWidth * 0.6,
              color: const Color.fromARGB(255, 59, 87, 89),
              hintText: "Customize Order",
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomizeOrder(),
                  ),
                );

                if (result != null) {
                  setState(() {
                    selectedDriver = result['selectedDriver'];
                    selectedLocation = result['selectedLocation'];
                    charges = result['charges'];
                  });
                }
              },
            ),
            SizedBox(height: screenHeight * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Total\n Rs${(int.parse(widget.price)) + charges}",
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: screenWidth * 0.05),
                MyButton(
                  color: const Color.fromARGB(255, 55, 84, 89),
                  hintText: "Confirm Order",
                  onTap: () async {
                    token = await _authService
                        .getToken(selectedDriver ?? driverNames[k()]);
                    NotificationService sendnoti = NotificationService();
                    sendnoti.pushNotification(
                      title: "New Order",
                      body: "A New Order is Received",
                      token: token!,
                      type: 'New Order',
                    );

                    Map<String, dynamic> orderData = {
                      'type': widget.type,
                      'selectedDriver': selectedDriver ?? driverNames[k()],
                      'address': address,
                      'mobileNumber': mobileNumber,
                      'selectedLocation': selectedLocation ?? 'Default',
                      'price': widget.price,
                      'orderTime': DateTime.now(),
                      'status': 'new',
                      'customerName': name,
                      'userid': uuid,
                    };

                    if (widget.type != "New Order") {
                      orderData['selectedTime'] =
                          // ignore: use_build_context_synchronously
                          widget.selectedTime?.format(context) ?? 'Right Now';
                      orderData['selectedDate'] =
                          widget.selectedDate?.toIso8601String() ?? 'Right Now';
                    }

                    try {
                      await _authService.saveOrder(orderData);

                      if (selectedDriver != null) {
                        await _authService.notifyDriver(
                            selectedDriver!, orderData);

                        // ignore: unused_local_variable
                        QuerySnapshot driverSnapshot = await FirebaseFirestore
                            .instance
                            .collection('users')
                            .where('fullName', isEqualTo: selectedDriver)
                            .limit(1)
                            .get();
                      }
                    } catch (e) {
                      // ignore: avoid_print
                      print("Error Occurred: Can't store the information");
                    }

                    showDialog(
                      // ignore: use_build_context_synchronously
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Order"),
                          content: const Text("Order Successful"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MyWidget(),
                                  ),
                                );
                              },
                              child: const Text("Close"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddressMobileContainer extends StatelessWidget {
  final String label;
  final String content;

  const AddressMobileContainer({
    super.key,
    required this.label,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 230,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blue),
            color: const Color.fromARGB(255, 39, 176, 169),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Text(
          content,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class PaymentOptionButton extends StatelessWidget {
  final String label;

  const PaymentOptionButton({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.8,
      height: screenHeight * 0.07,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.black),
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(255, 178, 212, 229),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
