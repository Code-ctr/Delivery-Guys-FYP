// ignore_for_file: library_private_types_in_public_api

import 'package:delivery_guys_fyp/components/button.dart';
import 'package:delivery_guys_fyp/components/slide_bar.dart';
import 'package:delivery_guys_fyp/pages/Water/orderpage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class PreOrderPage extends StatefulWidget {
  const PreOrderPage({super.key});

  @override
  _PreOrderPageState createState() => _PreOrderPageState();
}

class _PreOrderPageState extends State<PreOrderPage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pre Orders"),
        backgroundColor: Colors.blue,
        actions: const [ManageProfilePage()],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 550,
                width: 350,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 130, 202, 236),
                  border: Border.all(
                    width: 3,
                    color: const Color.fromARGB(255, 5, 63, 111),
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Order Now \nReceive When You Want",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    MyButton(
                      color: Colors.purple,
                      hintText: "Select Delivery Date",
                      onTap: () => _selectDate(context),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                        child: Text(
                          _selectedDate == null
                              ? 'No date chosen!'
                              : 'Delivery Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    MyButton(
                      color: Colors.purple,
                      hintText: "Select Delivery Time",
                      onTap: () => _selectTime(context),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                        child: Text(
                          _selectedTime == null
                              ? 'No time chosen!'
                              : 'Delivery Time: ${_selectedTime!.format(context)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const Spacer(),
                    MyButton(
                      widt: 150,
                      heigh: 50,
                      color: Colors.purple,
                      hintText: "Next",
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return OrderPage(
                            type: "Pre Order",
                            selectedDate: _selectedDate,
                            selectedTime: _selectedTime,
                          );
                        }));
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
