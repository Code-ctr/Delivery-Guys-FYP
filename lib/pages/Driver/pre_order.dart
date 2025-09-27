import 'package:delivery_guys_fyp/components/slide_bar.dart';
import 'package:delivery_guys_fyp/pages/FireBase/fire_registeration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PreOrders extends StatefulWidget {
  const PreOrders({super.key});

  @override
  State<PreOrders> createState() => _PreOrdersState();
}

class _PreOrdersState extends State<PreOrders> {
  final AuthService _authService = AuthService();
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    User? driver = _authService.getCurrentUser();
    if (driver != null) {
      String? driverName = await _authService.getUserFullName(driver.uid);
      //print("Driver name: $driverName"); // Debug print to check driver name

      List<Map<String, dynamic>> fetchedOrders =
          await _authService.fetchDriverOrders(driverName!);
      setState(() {
        orders = fetchedOrders;
      });
      //print("Fetched orders: $orders"); // Debug print to check fetched orders
    } else {
      //print("Driver is not authenticated"); // Debug print to check authentication
    }
  }

  void startDelivery(int index) async {
    setState(() {
      orders[index]['status'] = 'inProgress';
      for (int i = 0; i < orders.length; i++) {
        if (i != index && orders[i]['status'] == 'new') {
          orders[i]['orderId'] = 'rejected';
        }
      }
    });
    await _authService.updateOrderStatus(
        orders[index]['orderId'], 'inProgress');
    User? driver = _authService.getCurrentUser();
    if (driver != null) {
      await _authService.updateDriverStatus(driver.uid, "busy");
    }
  }

  void rejectOrder(int index) async {
    setState(() {
      orders[index]['status'] = 'rejected';
    });
    await _authService.updateOrderStatus(orders[index]['orderId'], 'rejected');
    //print(orders[index]['orderId']);
    User? driver = _authService.getCurrentUser();
    if (driver != null) {
      await _authService.updateDriverStatus(driver.uid, "available");
    }
  }

  void markDelivered(int index) async {
    setState(() {
      orders[index]['status'] = 'delivered';
    });
    User? driverId = _authService.getCurrentUser();
    await _authService.updateOrderStatus(orders[index]['orderId'], 'delivered');
    await _authService.updateDriverStatus(driverId!.uid, "available");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Order in Advanced'),
          actions: const [ManageProfilePage()],
          backgroundColor: Colors.blue,
        ),
        body: Column(children: [
          const SizedBox(
            height: 30,
          ),
          if (orders.any((order) => (order['status'] == 'new' ||
              order['status'] == 'inProgress'))) ...[
            for (int i = 0; i < orders.length; i++) ...[
              if ((orders[i]['status'] == 'new' ||
                      orders[i]['status'] == 'inProgress') &&
                  orders[i]['type'] == 'Pre Order') ...[
                Center(
                  child: Container(
                    height: 60,
                    width: 330,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 147, 191, 227),
                        border: Border.all(
                            color: const Color.fromARGB(255, 147, 191, 227)),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            orders[i]['selectedTime'],
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            orders[i]['selectedDate'],
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
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
                            border: Border.all(
                                color:
                                    const Color.fromARGB(255, 147, 191, 227)),
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
                              Text(orders[i]['address']),
                              Text(orders[i]['mobileNumber']),
                              Text(orders[i]['selectedLocation']),
                              Text(orders[i]['price']),
                            ]),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              if (orders[i]['status'] == 'new') ...[
                                ElevatedButton(
                                  onPressed: () => startDelivery(i),
                                  child: const Text("Start Delivery"),
                                ),
                                ElevatedButton(
                                  onPressed: () => rejectOrder(i),
                                  child: const Text("Reject Order"),
                                ),
                              ] else if (orders[i]['status'] ==
                                  'inProgress') ...[
                                ElevatedButton(
                                  onPressed: () => markDelivered(i),
                                  child: const Text("Mark as Delivered"),
                                ),
                              ],
                            ],
                          ),
                        ]),
                      ))
                    ],
                  ),
                )
              ]
            ],
          ] else ...[
            const SizedBox(
              height: 230,
            ),
            const Center(child: Text("No Order Received"))
          ]
        ]));
  }
}
