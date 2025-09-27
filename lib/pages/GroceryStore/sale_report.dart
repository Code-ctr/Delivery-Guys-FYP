import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_guys_fyp/pages/FireBase/fire_registeration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SaleReport extends StatefulWidget {
  const SaleReport({super.key});

  @override
  _SaleReportState createState() => _SaleReportState();
}

class _SaleReportState extends State<SaleReport> {
  Map<String, int> salesData = {};
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _fetchSalesData();
  }

  Future<void> _fetchSalesData() async {
    User? user = _authService.getCurrentUser();
    if (user != null) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      String? storeName = await _authService.getUserFullName(user.uid);

      QuerySnapshot ordersSnapshot = await firestore
          .collection('orders')
          .where('store', isEqualTo: storeName)
          .get();

      Map<String, int> tempSalesData = {};

      for (var doc in ordersSnapshot.docs) {
        List<dynamic> items = doc['items'];

        for (String item in items) {
          if (tempSalesData.containsKey(item)) {
            tempSalesData[item] = tempSalesData[item]! + 1;
          } else {
            tempSalesData[item] = 1;
          }
        }
      }

      setState(() {
        salesData = tempSalesData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sales Report"),
        backgroundColor: Colors.orange,
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            height: 580,
            width: 390,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 200, 239, 239),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: salesData.isNotEmpty
                  ? ListView.builder(
                      itemCount: salesData.length,
                      itemBuilder: (context, index) {
                        String itemName = salesData.keys.elementAt(index);
                        int quantitySold = salesData[itemName]!;
                        return ListTile(
                          title: Text(
                            itemName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Text(
                            '$quantitySold times',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
      ),
    );
  }
}
