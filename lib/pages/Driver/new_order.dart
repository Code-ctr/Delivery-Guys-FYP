import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_guys_fyp/components/slide_bar.dart';
import 'package:delivery_guys_fyp/pages/FireBase/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:delivery_guys_fyp/pages/FireBase/fire_registeration.dart';
import 'package:location/location.dart';

class NewOrders extends StatefulWidget {
  const NewOrders({super.key});

  @override
  State<NewOrders> createState() => _NewOrdersState();
}

class _NewOrdersState extends State<NewOrders> {
  final AuthService _authService = AuthService();
  List<Map<String, dynamic>> orders = [];
  StreamSubscription<LocationData>? locationSubscription;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    User? driver = _authService.getCurrentUser();
    if (driver != null) {
      String? driverName = await _authService.getUserFullName(driver.uid);
      debugPrint(
          "Driver name: $driverName"); // Debug print to check driver name

      List<Map<String, dynamic>> fetchedOrders =
          await _authService.fetchDriverOrders(driverName!);
      setState(() {
        orders = fetchedOrders;
      });
      debugPrint(
          "Fetched orders: $orders"); // Debug print to check fetched orders
    } else {
      debugPrint(
          "Driver is not authenticated"); // Debug print to check authentication
    }
  }

  void startDelivery(int index) async {
    setState(() {
      for (int i = 0; i < orders.length; i++) {
        if (i != index && orders[i]['status'] == 'new') {
          orders[i]['orderId'] = 'rejected';
        }
      }
      orders[index]['status'] = 'inProgress';
    });
    for (int i = 0; i < orders.length; i++) {
      if (i != index && orders[i]['status'] == 'new') {
        orders[i]['orderId'] = 'rejected';
        // await _authService.updateOrderStatus(orders[i]['orderId'], 'rejected');
      }
    }
    await _authService.updateOrderStatus(
        orders[index]['orderId'], 'inProgress');
    debugPrint(
        "Order status updated to inProgress for order ID: ${orders[index]['orderId']}");

    User? driver = _authService.getCurrentUser();
    if (driver != null) {
      await _authService.updateDriverStatus(driver.uid, "busy");
    }
    Location location = Location();
    locationSubscription =
        location.onLocationChanged.listen((LocationData currentLocation) async {
      String? driverName = await _authService.getUserFullName(driver!.uid);
      try {
        await FirebaseFirestore.instance
            .collection('location')
            .doc(orders[index]['orderId'])
            .set({
          'latitude': currentLocation.latitude,
          'longitude': currentLocation.longitude,
          'timestamp': FieldValue.serverTimestamp(),
          'driverName': driverName,
          'driverId': driver.uid,
          'customerName': orders[index]["customerName"],
          'orderId': orders[index]['orderId'],
          'status': 'new'
        });
      } catch (e) {
        print("Error writing location data: $e");
      }
    });
    String? token = await _authService.getToken(orders[index]["customerName"]);
    NotificationService sendnoti = NotificationService();
    sendnoti.pushNotification(
        title: "Order Accepted",
        body: "The Driver accept your Delivery. The Delivery is on the way",
        token: token!,
        type: 'On Way');
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
    String? token = await _authService.getToken(orders[index]["customerName"]);
    NotificationService sendnoti = NotificationService();
    sendnoti.pushNotification(
        title: "Order Rejected",
        body: "The Driver rejected your Delivery. Chose an other driver",
        token: token!,
        type: 'Rejected');
  }

  void markDelivered(int index) async {
    setState(() {
      orders[index]['status'] = 'delivered';
    });
    User? driverId = _authService.getCurrentUser();
    await _authService.updateOrderStatus(orders[index]['orderId'], 'delivered');
    await _authService.updateDriverStatus(driverId!.uid, "available");

    String? token = await _authService.getToken(orders[index]["customerName"]);
    String? driverName = await _authService.getUserFullName(driverId.uid);
    String customerName = orders[index]["customerName"];
    NotificationService sendnoti = NotificationService();
    sendnoti.pushNotification(
      title: "Order Delivered",
      body: "Your Order is delivered rate the experanice",
      token: token!,
      type: 'Deliverd',
      orderId: orders[index]['orderId'],
      driverName: driverName,
      customerName: customerName,
    );
    // Stop updating location after delivery
    await FirebaseFirestore.instance
        .collection('location')
        .doc(orders[index]['orderId'])
        .update({'status': 'completed'});

    locationSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Received Orders'),
        actions: const [ManageProfilePage()],
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Center(
          child: Container(
              height: 500,
              width: 380,
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  if (orders.any((order) =>
                      order['status'] == 'new' ||
                      order['status'] == 'inProgress')) ...[
                    for (int i = 0; i < orders.length; i++) ...[
                      if ((orders[i]['status'] == 'new' ||
                              orders[i]['status'] == 'inProgress') &&
                          orders[i]['type'] == 'New Order') ...[
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
                                    color: const Color.fromARGB(
                                        255, 147, 191, 227),
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 147, 191, 227)),
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
                                        borderRadius:
                                            BorderRadius.circular(25.0)),
                                    child: SingleChildScrollView(
                                      child: Column(children: [
                                        Image.asset('lib/images/Tank.png'),
                                        Text(
                                          "Delivery Address:\n${orders[i]['address']}",
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          "Mobile No: \n${orders[i]['mobileNumber']}",
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          "Water Filling Location:${orders[i]['selectedLocation']}",
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          "Price: ${orders[i]['price']}",
                                          textAlign: TextAlign.center,
                                        ),
                                      ]),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      if (orders[i]['status'] == 'new') ...[
                                        ElevatedButton(
                                          onPressed: () => startDelivery(i),
                                          child: const Text("Start Delivery"),
                                        ),
                                        const SizedBox(
                                          width: 40,
                                        ),
                                        ElevatedButton(
                                          onPressed: () => rejectOrder(i),
                                          child: const Text("Reject Order"),
                                        ),
                                      ] else if (orders[i]['status'] ==
                                          'inProgress') ...[
                                        Center(
                                          child: ElevatedButton(
                                            onPressed: () => markDelivered(i),
                                            child:
                                                const Text("Mark as Delivered"),
                                          ),
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
                    ]
                  ] else ...[
                    const SizedBox(
                      height: 250,
                    ),
                    const Center(child: Text("No Order Received Yet"))
                  ]
                ],
              ))),
        ),
      ),
    );
  }
}
