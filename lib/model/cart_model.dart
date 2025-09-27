import 'package:flutter/material.dart';

class CartModel extends ChangeNotifier {
  final List _cartItems = [];

  List get cartItems => _cartItems;

  void addItemToCart(List item) {
    _cartItems.add(item);
    notifyListeners();
  }

  void removeItemFromCart(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
  }

  String calcluateTotal() {
    double totalprice = 0;
    for (int i = 0; i < cartItems.length; i++) {
      totalprice += double.parse(_cartItems[i][1]);
    }
    return totalprice.toString();
  }
}
