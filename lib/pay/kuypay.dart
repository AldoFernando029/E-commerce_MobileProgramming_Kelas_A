// lib/pay/kuypay.dart
import 'package:flutter/foundation.dart';

class KuyPay with ChangeNotifier {
  double _balance = 10000.0; // ✅ Saldo awal $10,000

  double get balance => _balance;

  // ✅ Kurangi saldo ketika checkout
  bool pay(double amount) {
    if (amount <= _balance) {
      _balance -= amount;
      notifyListeners();
      return true; // berhasil
    }
    return false; // gagal (saldo kurang)
  }

  // ✅ Tambah saldo (jika nanti mau top up)
  void topUp(double amount) {
    _balance += amount;
    notifyListeners();
  }
}
