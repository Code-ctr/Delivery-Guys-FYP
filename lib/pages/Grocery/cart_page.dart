import 'package:delivery_guys_fyp/components/button.dart';
import 'package:delivery_guys_fyp/components/slide_bar.dart';
import 'package:delivery_guys_fyp/model/cart_model.dart';
import 'package:delivery_guys_fyp/pages/Grocery/check_out.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  final String? store;
  const CartPage({super.key, this.store});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isNetworkImage(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: const Color.fromARGB(255, 38, 83, 39),
        actions: const [ManageProfilePage()],
      ),
      body: Consumer<CartModel>(
        builder: (context, value, child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: value.cartItems.length,
                  padding: const EdgeInsets.all(12.0),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: ListTile(
                          leading: isNetworkImage(value.cartItems[index][2])
                              ? Image.network(
                                  value.cartItems[index][2],
                                  height: 36,
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return const Icon(
                                      Icons.image_not_supported,
                                      size: 36,
                                      color: Colors.grey,
                                    );
                                  },
                                )
                              : Image.asset(
                                  value.cartItems[index][2],
                                  height: 36,
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return const Icon(
                                      Icons.image_not_supported,
                                      size: 36,
                                      color: Colors.grey,
                                    );
                                  },
                                ),
                          title: Text(value.cartItems[index][0]),
                          subtitle: Text(value.cartItems[index][1]),
                          trailing: IconButton(
                            icon: const Icon(Icons.cancel),
                            onPressed: () {
                              Provider.of<CartModel>(context, listen: false)
                                  .removeItemFromCart(index);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: [
                            Text(
                              'Total Price',
                              style: TextStyle(color: Colors.grey[100]),
                            ),
                            Text(
                              value.calcluateTotal(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 61,
                        ),
                        MyButton(
                            widt: 120,
                            color: Colors.white,
                            hintText: "Order Now",
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return CheckOut(store: widget.store!);
                              }));
                            })
                      ],
                    )),
              )
            ],
          );
        },
      ),
    );
  }
}
