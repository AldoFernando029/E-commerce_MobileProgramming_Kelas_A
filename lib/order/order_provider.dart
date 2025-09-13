import 'package:flutter/material.dart';
import 'order_model.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => _orders;

  void addOrder(Order order) {
    // cek apakah produk dengan nama sama sudah ada
    final index = _orders.indexWhere((o) => o.title == order.title);
    if (index != -1) {
      _orders[index].quantity++;
    } else {
      _orders.add(order);
    }
    notifyListeners();
  }

  void removeOrder(int index) {
    _orders.removeAt(index);
    notifyListeners();
  }

  void increaseQty(int index) {
    _orders[index].quantity++;
    notifyListeners();
  }

  void decreaseQty(int index) {
    if (_orders[index].quantity > 1) {
      _orders[index].quantity--;
    } else {
      _orders.removeAt(index);
    }
    notifyListeners();
  }

  int get totalItems =>
      _orders.fold(0, (sum, order) => sum + order.quantity);
}
