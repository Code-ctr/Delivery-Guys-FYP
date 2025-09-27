// ignore_for_file: library_private_types_in_public_api
import 'package:delivery_guys_fyp/components/address_change.dart';
import 'package:delivery_guys_fyp/components/button.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  const Orders({
    super.key,
  });

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  String address = 'X Street House No#3 Jinna Town';
  String mobileNumber = '0322 2413456';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 455,
        width: 395,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(45),
        ),
        child: Column(
          children: [
            const SizedBox(height: 25),
            const Text(
              'Delivery Address',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Container(
                height: 200,
                width: 380,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 2, color: Colors.black),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        AddressMobileContainer(
                          label: 'Address',
                          content: address,
                        ),
                        const SizedBox(height: 10),
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
            const SizedBox(height: 8),
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
                  });
                }
              },
            ),
            const SizedBox(height: 30),
            const PaymentOptionButton(
              label: "Cash On Delivery",
            ),
            const SizedBox(height: 5),
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
    return Container(
      height: 50,
      width: 300,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 208, 176, 248),
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
