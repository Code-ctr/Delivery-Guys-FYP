import 'package:delivery_guys_fyp/pages/FireBase/fire_registeration.dart';
import 'package:flutter/material.dart';
import 'package:delivery_guys_fyp/components/button.dart';

class CustomizeOrder extends StatefulWidget {
  const CustomizeOrder({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CustomizeOrderState createState() => _CustomizeOrderState();
}

class _CustomizeOrderState extends State<CustomizeOrder> {
  final List<String> locations = [
    "Default",
    "Well Water",
    "Spring Water",
    "Chasma Water",
    "Water Pomp",
  ];
  final List<int> charges = [0, 2000, 2500, 3700, 4500];

  final AuthService _driverDetail = AuthService();
  String selectedLocation = "Default";
  String? selectedDriver;
  List<String> driverNames = [];
  Map<String, dynamic> driverDetails = {};

  @override
  void initState() {
    super.initState();
    fetchDrivers();
  }

  Future<void> fetchDrivers() async {
    try {
      List<Map<String, dynamic>> drivers =
          await _driverDetail.getAvailableDrivers();
      setState(() {
        driverNames = drivers
            .map((driver) => driver['fullName'] as String?)
            .where((name) => name != null)
            .cast<String>()
            .toList();
        driverDetails = {
          for (var driver in drivers)
            if (driver['fullName'] != null) driver['fullName']: driver,
        };
      });
    } catch (e) {
      print("Error fetching drivers: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 130, 188, 235),
      appBar: AppBar(
        title: const Text("Order Customization"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(30),
              ),
              height: 530,
              width: 380,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Change Delivery Driver or Water Delivery to Your Desired",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 70,
                    width: 330,
                    child: DropdownButtonFormField<String>(
                      focusColor: Colors.white,
                      value: selectedLocation,
                      items: locations.map((String location) {
                        return DropdownMenuItem<String>(
                          value: location,
                          child: Text(location),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedLocation = newValue!;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Your Delivery from',
                        labelStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 280,
                    width: 350,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(width: 1.8, color: Colors.black)),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (String driver in driverNames) ...[
                            RadioListTile<String>(
                              title: DriverProfile(
                                  name: driver, details: driverDetails[driver]),
                              value: driver,
                              groupValue: selectedDriver,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedDriver = value;
                                });
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  MyButton(
                      hintText: "Check out",
                      color: Colors.black,
                      onTap: () {
                        if (selectedDriver != null &&
                            selectedDriver!.isNotEmpty) {
                          Navigator.pop(context, {
                            'selectedDriver': selectedDriver,
                            'selectedLocation': selectedLocation,
                            'charges':
                                charges[locations.indexOf(selectedLocation)],
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select a driver'),
                            ),
                          );
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DriverProfile extends StatelessWidget {
  final String name;
  final Map<String, dynamic>? details;
  const DriverProfile({
    super.key,
    required this.name,
    this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      width: 330,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(25),
          color: const Color.fromARGB(255, 35, 50, 77)),
      child: Column(
        children: [
          const SizedBox(height: 5),
          SizedBox(
            height: 100,
            width: 100,
            child: Image.asset(
              'lib/images/user.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 50,
            width: 230,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5),
                color: Colors.white),
            child: Center(
              child: Text(
                name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
