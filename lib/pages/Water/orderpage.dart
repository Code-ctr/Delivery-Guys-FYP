import 'package:delivery_guys_fyp/components/boxtank.dart';
import 'package:delivery_guys_fyp/components/slide_bar.dart';
import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {
  final String type;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  const OrderPage({
    super.key,
    required this.type,
    this.selectedDate,
    this.selectedTime,
  });

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final List<String> list = ["1200", "2400", "3600"];

  final List<String> lter = ["500", "1000", "1500"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tankers"),
        backgroundColor: Colors.blueAccent,
        actions: const [ManageProfilePage()],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              for (int i = 0; i < list.length; i++) ...[
                const SizedBox(height: 20),
                TankBox(
                  ordertype: widget.type,
                  hinttext: list[i],
                  liter: lter[i],
                  selectedDate: widget.selectedDate,
                  selectedTime: widget.selectedTime,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
