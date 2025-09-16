import 'package:flutter/material.dart';
import 'order_model.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => _orders;

  void addOrder(Order order) {

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

  void toggleSelection(int index) {
    if (index >= 0 && index < _orders.length) {
      _orders[index].isSelected = !_orders[index].isSelected;
      notifyListeners();
    }
  }

  void selectAll(bool value) {
    for (var order in _orders) {
      order.isSelected = value;
    }
    notifyListeners();
  }

  List<Order> get selectedOrders =>
      _orders.where((order) => order.isSelected).toList();

  int checkoutSelected() {
    final selected = selectedOrders;
    if (selected.isEmpty) return 0;
    _orders.removeWhere((order) => order.isSelected);
    notifyListeners();
    return selected.length;
  }

  void clearCart() {
    _orders.clear();
    notifyListeners();
  }

  int get totalItems =>
      _orders.fold(0, (sum, order) => sum + order.quantity);

  double get totalSelectedPrice => _orders
      .where((o) => o.isSelected)
      .fold(0, (sum, o) => sum + (o.price * o.quantity));
}
