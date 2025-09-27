import 'package:delivery_guys_fyp/components/slide_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:delivery_guys_fyp/components/item_tile.dart';
import 'package:delivery_guys_fyp/model/cart_model.dart';
import 'package:delivery_guys_fyp/pages/Grocery/cart_page.dart';

class CategoryShop extends StatelessWidget {
  final String title;
  final List items;
  final String? store;

  const CategoryShop(
      {super.key, required this.title, required this.items, this.store});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color.fromARGB(255, 108, 107, 54),
        actions: const [ManageProfilePage()],
      ),
      floatingActionButton: SizedBox(
        height: 60,
        width: 120,
        child: FloatingActionButton(
          onPressed: () =>
              Navigator.push(context, MaterialPageRoute(builder: ((context) {
            return CartPage(
              store: store,
            );
          }))),
          backgroundColor: Colors.lightGreen,
          child: const Icon(Icons.shopping_bag),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (items.isEmpty == true) ...[
              const SizedBox(height: 250),
              const Center(
                  child: Text("The Store Do not have that catgory items"))
            ] else ...[
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "Let's order some fresh items",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  color: Colors.black87,
                ),
              ),
              Expanded(
                child: Consumer<CartModel>(
                  builder: (context, value, child) {
                    return GridView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: items.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1 / 1.3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemBuilder: (context, index) {
                        if (index < items.length) {
                          return ItemTile(
                            itemName: items[index][0],
                            itemPrice: items[index][1],
                            imagePath: items[index][2],
                            color: Colors.amber,
                            onPressed: () {
                              Provider.of<CartModel>(context, listen: false)
                                  .addItemToCart(items[index]);
                            },
                          );
                        } else {
                          return const SizedBox(); // Return an empty widget if the index is out of range
                        }
                      },
                    );
                  },
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
