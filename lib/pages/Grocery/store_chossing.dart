import 'package:delivery_guys_fyp/components/button.dart';
import 'package:delivery_guys_fyp/components/slide_bar.dart';
import 'package:delivery_guys_fyp/pages/FireBase/fire_registeration.dart';
import 'package:delivery_guys_fyp/pages/Grocery/home_grocery.dart';
import 'package:flutter/material.dart';

class StoreChossing extends StatefulWidget {
  const StoreChossing({super.key});

  @override
  State<StoreChossing> createState() => _StoreChossingState();
}

class _StoreChossingState extends State<StoreChossing> {
  final AuthService _authService = AuthService();
  List<String> storeNames = [];

  @override
  void initState() {
    super.initState();
    fetchStores();
  }

  Future<void> fetchStores() async {
    try {
      List<Map<String, dynamic>> stores = await _authService.getGStores();
      setState(() {
        storeNames = stores
            .map((driver) => driver['fullName'] as String?)
            .where((name) => name != null)
            .cast<String>()
            .toList();
      });
    } catch (e) {
      print("Error fetching drivers: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        title: const Text("Stores"),
        backgroundColor: const Color.fromARGB(255, 112, 105, 55),
        actions: const [ManageProfilePage()],
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            SingleChildScrollView(
              child: Container(
                  height: 500,
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Column(children: [
                    const SizedBox(
                      height: 50,
                    ),
                    for (String store in storeNames) ...[
                      MyButton(
                          hintText: store,
                          color: const Color.fromRGBO(255, 152, 0, 1),
                          widt: 250,
                          heigh: 170,
                          onTap: () {
                            print(store);
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return GroceryHome(
                                store: store,
                              );
                            }));
                          })
                    ]
                  ])),
            ),
          ],
        ),
      ),
    );
  }
}
