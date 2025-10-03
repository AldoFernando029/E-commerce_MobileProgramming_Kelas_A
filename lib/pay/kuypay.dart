import 'package:flutter/foundation.dart';

class KuyPay with ChangeNotifier {
  double _balance = 10000.0; 

  double get balance => _balance;

  bool pay(double amount) {
    if (amount <= _balance) {
      _balance -= amount;
      notifyListeners();
      return true; 
    }
    return false; 
  }

  void topUp(double amount) {
    _balance += amount;
    notifyListeners();
  }
}

