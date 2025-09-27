import 'package:delivery_guys_fyp/components/button.dart';
import 'package:delivery_guys_fyp/components/slide_bar.dart';
import 'package:delivery_guys_fyp/pages/GroceryStore/sale_report.dart';
import 'package:delivery_guys_fyp/pages/GroceryStore/update_inventory.dart';
import 'package:delivery_guys_fyp/pages/GroceryStore/view_order.dart';
import 'package:flutter/material.dart';

class GroceryStoreHomePage extends StatelessWidget {
  const GroceryStoreHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home",
        ),
        actions: const [ManageProfilePage()],
        backgroundColor: const Color.fromARGB(255, 144, 124, 65),
      ),
      body: SafeArea(
          child: Center(
              child: Container(
        height: 500,
        width: 350,
        decoration: BoxDecoration(
            color: Colors.orange,
            border: Border.all(color: Colors.orange),
            borderRadius: BorderRadius.circular(30)),
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          const Text("Welcome To Delivery Guys"),
          const SizedBox(
            height: 70,
          ),
          MyButton(
              color: const Color.fromARGB(255, 180, 196, 188),
              heigh: 100,
              hintText: "New Orders",
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const ReceivedOrder();
                }));
              }),
          const SizedBox(
            height: 7,
          ),
          MyButton(
              color: const Color.fromARGB(255, 180, 196, 188),
              heigh: 100,
              hintText: "Update Inventory",
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const UpdateInventory();
                }));
              }),
          const SizedBox(
            height: 7,
          ),
          MyButton(
              color: const Color.fromARGB(255, 180, 196, 188),
              heigh: 100,
              hintText: "View Sales Report",
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const SaleReport();
                }));
              })
        ]),
      ))),
    );
  }
}
