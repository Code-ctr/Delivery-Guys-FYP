import 'package:delivery_guys_fyp/components/button.dart';
import 'package:delivery_guys_fyp/components/slide_bar.dart';
import 'package:delivery_guys_fyp/pages/GroceryStore/add_new_items.dart';
import 'package:delivery_guys_fyp/pages/GroceryStore/remove_item.dart';
import 'package:flutter/material.dart';

class UpdateInventory extends StatelessWidget {
  const UpdateInventory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        title: const Text("Update Inventory"),
        actions: const [ManageProfilePage()],
        backgroundColor: const Color.fromARGB(255, 144, 124, 65),
      ),
      body: SafeArea(
          child: Center(
        child: Container(
          height: 450,
          width: 380,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(30)),
          child: Column(children: [
            const SizedBox(
              height: 130,
            ),
            MyButton(
                heigh: 100,
                color: const Color.fromARGB(255, 180, 196, 188),
                hintText: "Add New Item",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const AddItemsPage();
                  }));
                }),
            const SizedBox(
              height: 15,
            ),
            MyButton(
                heigh: 100,
                color: const Color.fromARGB(255, 180, 196, 188),
                hintText: "Remove An Item",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const RemoveItemPage();
                  }));
                }),
            const SizedBox(
              height: 15,
            ),
          ]),
        ),
      )),
    );
  }
}
