import 'package:delivery_guys_fyp/components/address_change.dart';
import 'package:delivery_guys_fyp/components/button.dart';
import 'package:delivery_guys_fyp/components/slide_bar.dart';
import 'package:delivery_guys_fyp/model/cart_model.dart';
import 'package:delivery_guys_fyp/pages/FireBase/fire_registeration.dart';
import 'package:delivery_guys_fyp/pages/FireBase/notification_service.dart';
import 'package:delivery_guys_fyp/pages/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckOut extends StatefulWidget {
  final String store;
  const CheckOut({super.key, required this.store});

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  final AuthService _authService = AuthService();
  String address = '';
  String mobileNumber = '';
  String name = '';
  String? token = "";

  @override
  void initState() {
    super.initState();
    _getUserDetail();
  }

  Future<void> _getUserDetail() async {
    User? user = _authService.getCurrentUser();
    if (user != null) {
      String uid = user.uid;

      String? userAddress = await _authService.getUserAddress(uid);
      String? userMobNo = await _authService.getUserMobileNo(uid);
      String? userName = await _authService.getUserFullName(uid);

      setState(() {
        if (userAddress != null) address = userAddress;
        if (userMobNo != null) mobileNumber = userMobNo;
        if (userName != null) name = userName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 124, 241, 128),
        appBar: AppBar(
          title: const Text("Delivery Detail"),
          backgroundColor: const Color.fromARGB(255, 38, 83, 39),
          actions: const [ManageProfilePage()],
        ),
        body: SafeArea(
          child: Column(children: [
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Container(
                height: 455,
                width: 395,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(45),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 25),
                    const Text(
                      'Delivery Address',
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Container(
                        height: 200,
                        width: 380,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 2, color: Colors.black),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: SingleChildScrollView(
                          child: Center(
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                AddressMobileContainer(
                                  label: 'Address',
                                  content: address,
                                ),
                                const SizedBox(height: 10),
                                AddressMobileContainer(
                                  label: 'Mobile Number',
                                  content: mobileNumber,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    MyButton(
                      color: const Color.fromARGB(255, 208, 176, 248),
                      hintText: "Change Personal info",
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeAddress(
                              address: address,
                              mobileNumber: mobileNumber,
                            ),
                          ),
                        );

                        if (result != null) {
                          setState(() {
                            address = result['address'];
                            mobileNumber = result['mobileNumber'];
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    const PaymentOptionButton(
                      label: "Cash On Delivery",
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 70,
              width: 380,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black),
              ),
              child: Row(
                children: [
                  MyButton(
                      widt: 120,
                      color: const Color.fromARGB(255, 208, 176, 248),
                      hintText: "Cancel order",
                      onTap: () {
                        Provider.of<CartModel>(context, listen: false)
                            .clearCart();
                        Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (context) {
                          return const HomePage();
                        }), (route) => route.isFirst);
                      }),
                  const SizedBox(
                    width: 30,
                  ),
                  MyButton(
                      widt: 120,
                      color: const Color.fromARGB(255, 208, 176, 248),
                      hintText: "Check Out",
                      onTap: () async {
                        token = await _authService.getToken(widget.store);
                        NotificationService sendnoti = NotificationService();
                        sendnoti.pushNotification(
                            title: "New Order",
                            body: "An New Order is Received",
                            token: token!,
                            type: 'G Order');
                        List cartItems =
                            Provider.of<CartModel>(context, listen: false)
                                .cartItems
                                .map((item) {
                          return item[0];
                        }).toList();

                        Map<String, dynamic> orderData = {
                          'store': widget.store,
                          'items': cartItems,
                          'orderTime': DateTime.now(),
                          'status': 'new',
                          'customerName': name,
                          'address': address,
                          'mobile Number': mobileNumber,
                          'Gorder': "GSTORE",
                        };
                        try {
                          await _authService.saveOrder(orderData);
                          print(orderData);
                          Provider.of<CartModel>(context, listen: false)
                              .clearCart();
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(builder: (context) {
                            return const HomePage();
                          }), (route) => route.isFirst);
                        } catch (e) {
                          print(
                              "Error Occurred: Can't store the order information");
                        }
                        showDialog(
                            // ignore: use_build_context_synchronously
                            context: context,
                            builder: (BuildContext context) {
                              return const AlertDialog(
                                title: Text("Order"),
                                content: Text("Order Succesfll"),
                                actions: [],
                              );
                            });
                      })
                ],
              ),
            )
          ]),
        ));
  }
}

class AddressMobileContainer extends StatelessWidget {
  final String label;
  final String content;

  const AddressMobileContainer({
    super.key,
    required this.label,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 230,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blue),
            color: const Color.fromARGB(255, 39, 176, 169),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Text(
          content,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class PaymentOptionButton extends StatelessWidget {
  final String label;

  const PaymentOptionButton({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 300,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 208, 176, 248),
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
