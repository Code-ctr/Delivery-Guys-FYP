import 'package:delivery_guys_fyp/components/button.dart';
import 'package:delivery_guys_fyp/components/slide_bar.dart';
import 'package:delivery_guys_fyp/pages/FireBase/fire_registeration.dart';
import 'package:delivery_guys_fyp/pages/FireBase/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReceivedOrder extends StatefulWidget {
  const ReceivedOrder({super.key});

  @override
  State<ReceivedOrder> createState() => _ReceivedOrderState();
}

class _ReceivedOrderState extends State<ReceivedOrder> {
  final AuthService _authService = AuthService();
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    User? storeowner = _authService.getCurrentUser();
    if (storeowner != null) {
      String? storeName = await _authService.getUserFullName(storeowner.uid);
      debugPrint("Store name: $storeName");

      if (storeName != null) {
        List<Map<String, dynamic>> fetchedOrders =
            await _authService.fetchStoreOrders(storeName);
        setState(() {
          orders = fetchedOrders;
        });
        debugPrint("Fetched orders: $orders");
      } else {
        debugPrint("Store name is null.");
      }
    } else {
      debugPrint("Store owner is not authenticated.");
    }
  }

  void startDelivery(int index) async {
    setState(() {
      orders[index]['status'] = 'inProgress';
    });
    await _authService.updateOrderStatus(
        orders[index]['orderId'], 'inProgress');
    String? token = await _authService.getToken(orders[index]["customerName"]);
    NotificationService sendnoti = NotificationService();
    sendnoti.pushNotification(
        title: "Order Dispatch",
        body: "Your delivery is on the way",
        token: token!,
        type: 'X');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Orders"),
        actions: const [ManageProfilePage()],
        backgroundColor: Colors.orange,
      ),
      body: SafeArea(
          child: Center(
        child: Column(children: [
          const SizedBox(
            height: 15,
          ),
          Column(
            children: [
              Container(
                height: 510,
                width: 380,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (orders.any((order) => order['status'] == 'new')) ...[
                        for (int i = 0; i < orders.length; i++) ...[
                          if ((orders[i]['status'] == 'new')) ...[
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                                height: 400,
                                width: 340,
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 200, 239, 239),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.white)),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                        "Customer Name: ${orders[i]['customerName']}"),
                                    Text("Address: ${orders[i]['address']}"),
                                    Text(
                                        "Mobile Number: ${orders[i]['mobile Number']}"),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 250,
                                      width: 300,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border:
                                              Border.all(color: Colors.white)),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            for (String item in orders[i]
                                                ['items']) ...[
                                              Container(
                                                height: 40,
                                                width: 250,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: const Color.fromARGB(
                                                        255, 194, 166, 166),
                                                    border: Border.all(
                                                        color: Colors.white)),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        item,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      const Text('value: 1'),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ]
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    MyButton(
                                        color: Colors.indigo,
                                        hintText: "Process",
                                        onTap: () async {
                                          startDelivery(i);
                                        })
                                  ],
                                )),
                          ]
                        ]
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ]),
      )),
    );
  }
}
