import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'order_model.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => _orders;

  OrderProvider() {
    _loadOrders(); // ✅ Load keranjang saat pertama kali provider dipanggil
  }

  Future<void> _loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList("orders") ?? [];
    _orders.clear();
    _orders.addAll(data.map((e) => Order.fromJson(jsonDecode(e))));
    notifyListeners();
  }

  Future<void> _saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _orders.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList("orders", data);
  }

  void addOrder(Order order) {
    final index = _orders.indexWhere((o) => o.title == order.title);
    if (index != -1) {
      _orders[index].quantity++;
    } else {
      _orders.add(order);
    }
    _saveOrders();
    notifyListeners();
  }

  void removeOrder(int index) {
    _orders.removeAt(index);
    _saveOrders();
    notifyListeners();
  }

  void increaseQty(int index) {
    _orders[index].quantity++;
    _saveOrders();
    notifyListeners();
  }

  void decreaseQty(int index) {
    if (_orders[index].quantity > 1) {
      _orders[index].quantity--;
    } else {
      _orders.removeAt(index);
    }
    _saveOrders();
    notifyListeners();
  }

  /// ✅ Toggle satu checkbox item
  void toggleSelection(int index) {
    if (index >= 0 && index < _orders.length) {
      _orders[index].isSelected = !_orders[index].isSelected;
      _saveOrders();
      notifyListeners();
    }
  }

  /// ✅ Pilih semua / batalkan semua
  void selectAll(bool value) {
    for (var order in _orders) {
      order.isSelected = value;
    }
    _saveOrders();
    notifyListeners();
  }

  /// ✅ Ambil hanya item yang dipilih
  List<Order> get selectedOrders =>
      _orders.where((order) => order.isSelected).toList();

  /// ✅ Checkout hanya yang dipilih
  int checkoutSelected() {
    final selected = selectedOrders;
    if (selected.isEmpty) return 0;
    _orders.removeWhere((order) => order.isSelected);
    _saveOrders();
    notifyListeners();
    return selected.length;
  }

  /// ✅ Hitung total jumlah barang
  int get totalItems =>
      _orders.fold(0, (sum, order) => sum + order.quantity);

  /// ✅ Hitung total harga hanya yang dipilih
  double get totalSelectedPrice => _orders
      .where((o) => o.isSelected)
      .fold(0, (sum, o) => sum + (o.price * o.quantity));
}
