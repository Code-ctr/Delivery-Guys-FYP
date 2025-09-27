import 'package:flutter/material.dart';

class Driver extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback onStartDelivery;
  final VoidCallback onRejectOrder;
  final VoidCallback onMarkDelivered;

  const Driver({
    required this.order,
    required this.onStartDelivery,
    required this.onRejectOrder,
    required this.onMarkDelivered,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Center(
              child: Container(
            height: 455,
            width: 340,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 147, 191, 227),
                border:
                    Border.all(color: const Color.fromARGB(255, 147, 191, 227)),
                borderRadius: BorderRadius.circular(30.0)),
            child: Column(children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 350,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(25.0)),
                child: Column(children: [
                  Image.asset('lib/images/Tank.png'),
                  Text(order['address']),
                  Text(order['mobileNumber']),
                  Text(order['selectedLocation']),
                  Text(order['price']),
                ]),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  if (order['status'] == 'new') ...[
                    ElevatedButton(
                      onPressed: onStartDelivery,
                      child: const Text("Start Delivery"),
                    ),
                    ElevatedButton(
                      onPressed: onRejectOrder,
                      child: const Text("Reject Order"),
                    ),
                  ] else if (order['status'] == 'inProgress') ...[
                    ElevatedButton(
                      onPressed: onMarkDelivered,
                      child: const Text("Mark as Delivered"),
                    ),
                  ],
                ],
              ),
            ]),
          ))
        ],
      ),
    );
  }
}
