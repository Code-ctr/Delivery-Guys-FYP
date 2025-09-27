import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_guys_fyp/components/slide_bar.dart';
import 'package:flutter/material.dart';
import 'package:delivery_guys_fyp/pages/Grocery/cart_page.dart';
import 'package:delivery_guys_fyp/components/button.dart';
import 'package:delivery_guys_fyp/pages/Grocery/category_shop.dart';

// ignore: must_be_immutable
class GroceryHome extends StatefulWidget {
  String? store;
  GroceryHome({super.key, this.store});

  @override
  State<GroceryHome> createState() => _GroceryHomeState();
}

class _GroceryHomeState extends State<GroceryHome> {
  Future<Map<String, List<List<String>>>> fetchItems() async {
    Map<String, List<List<String>>> categories = {
      'Vegetables': [
        ["Bell Pepper", "80", "lib/images/veges/bell_pepper.jpeg"],
        ["Cabbage", "50", "lib/images/veges/cabbage.jpeg"],
        ["Carrot", "150", "lib/images/veges/carrot.jpeg"],
        ["Chili", "280", "lib/images/veges/chili.jpeg"],
        ["Cucumber", "80", "lib/images/veges/cucumber.jpeg"],
        ["Eggplant", "70", "lib/images/veges/eggplant.jpeg"],
        ["Lady Finger", "180", "lib/images/veges/lady_finger.jpeg"],
        ["Onion", "80", "lib/images/veges/onion.jpeg"],
      ],
      'Fruits': [
        [
          "Apple",
          "70",
          "lib/images/fruits/apple.jpeg",
        ],
        [
          "Grapes",
          "90",
          "lib/images/fruits/grapes.jpeg",
        ],
        [
          "Mango",
          "60",
          "lib/images/fruits/mango.jpg",
        ],
        [
          "Orange",
          "170",
          "lib/images/fruits/orange.jpeg",
        ],
        [
          "Peach",
          "210",
          "lib/images/fruits/peach.jpeg",
        ],
        [
          "Watermelon",
          "80",
          "lib/images/fruits/watermelon.jpeg",
        ],
        // Add fruits data here
      ],
      'Dariy': [
        // Add dairy data here
      ],
      'Meat': [
        [
          "Beef",
          "800",
          "lib/images/meat/beef.jpeg",
        ],
        ["Chicken", "450", "lib/images/meat/chicken.jpeg"],
        ["Mutton", "800", "lib/images/meat/mutton.jpeg"],
      ],
      'Sweet': [
        [
          "Gulab Jamun",
          "1050",
          "lib/images/sweets/gulab_jamun.jpg",
        ],
        ["Rabri", "1050", "lib/images/sweets/rabri.jpeg"],
        [
          "Soan Papdi",
          "1050",
          "lib/images/sweets/soan_papdi.jpeg",
        ],
      ],
      'Snacks': [
        ["Cheetos", "50", "lib/images/snacks/cheetos.jpeg"],
        ["Chocolate", "100", "lib/images/snacks/chocolate.jpeg"],
        [
          "Kurkure",
          "50",
          "lib/images/snacks/kurkure.png",
        ],
        [
          "Lays",
          "50",
          "lib/images/snacks/lays.jpeg",
        ],
        // Add snacks data here
      ],
      'Other Items': [
        [
          "Cheetos",
          "50",
          "lib/images/snacks/cheetos.jpeg",
        ],
        [
          "Chocolate",
          "100",
          "lib/images/snacks/chocolate.jpeg",
        ],
        ["Kurkure", "50", "lib/images/snacks/kurkure.png"],
        ["Lays", "50", "lib/images/snacks/lays.jpeg"],
        // Add snacks data here
      ],
      'Driay Fruit': []
    };

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('items')
        .where('store', isEqualTo: widget.store)
        .get();

    for (var doc in querySnapshot.docs) {
      String category = doc['category'];
      String name = doc['name'];
      String price = doc['price'];
      String imageURL = doc['imageURL'];

      if (categories.containsKey(category)) {
        categories[category]!.add([name, price, imageURL, ""]);
      } else {
        categories['Other Items']!.add([name, price, imageURL, ""]);
      }
    }

    return categories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        title: const Text("Grocery Shop"),
        backgroundColor: const Color.fromARGB(255, 112, 105, 55),
        actions: const [ManageProfilePage()],
      ),
      floatingActionButton: SizedBox(
        height: 60,
        width: 120,
        child: FloatingActionButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return CartPage(
                store: widget.store,
              );
            },
          )),
          backgroundColor: const Color.fromARGB(255, 89, 120, 54),
          child: const Icon(Icons.shopping_bag),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            height: 600,
            width: 380,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(35)),
            child: FutureBuilder<Map<String, List<List<String>>>>(
              future: fetchItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No items available"));
                }

                final categories = snapshot.data!;

                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          "Let's order some fresh Items",
                          style: TextStyle(
                              fontSize: 36, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ...categories.keys
                          .map((category) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: MyButton(
                                  heigh: 200,
                                  widt: 300,
                                  color:
                                      const Color.fromARGB(255, 231, 164, 62),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CategoryShop(
                                            title: category,
                                            items: categories[category]!,
                                            store: widget.store),
                                      ),
                                    );
                                  },
                                  hintText: category,
                                ),
                              ))
                          .toList(),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
