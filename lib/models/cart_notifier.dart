import 'package:flutter/material.dart';
import '../utils/cart_item.dart';
class CartNotifier extends ValueNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addItem(CartItem item) {
    final existingIndex = value.indexWhere((i) => i.title == item.title);
    if (existingIndex != -1) {
      value[existingIndex].quantity += item.quantity;
    } else {
      value = [...value, item];
    }
    notifyListeners();
  }

  void clear() {
    value = [];
    notifyListeners();
  }

  int get totalItems => value.fold(0, (sum, item) => sum + item.quantity);

  List<CartItem> get cartItems => value;
}

final cartNotifier = CartNotifier();
