import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../order/order_model.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final List<String> statusList = [
    "Pembayaran",
    "Proses",
    "Dikirim",
    "Sampai",
    "Review"
  ];

  String? filterStatus;
  Timer? _timer;
  List<Order> orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final savedOrders = prefs.getStringList('orders') ?? [];

    setState(() {
      orders = savedOrders.map((o) => Order.fromJson(jsonDecode(o))).toList();
    });

    if (orders.isNotEmpty) {
      _startStatusTimer();
    }
  }

  void _startStatusTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (!mounted) return;

      setState(() {
        for (var order in orders) {
          if (order.statusIndex < statusList.length - 1) {
            order.statusIndex++;
          }
        }
      });

      final prefs = await SharedPreferences.getInstance();
      final encoded = orders.map((o) => jsonEncode(o.toJson())).toList();
      await prefs.setStringList('orders', encoded);
    });
  }

  Future<void> _deleteOrder(Order order) async {
    setState(() {
      orders.remove(order);
    });
    final prefs = await SharedPreferences.getInstance();
    final encoded = orders.map((o) => jsonEncode(o.toJson())).toList();
    await prefs.setStringList('orders', encoded);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredOrders = orders.where((order) {
      final status = statusList[order.statusIndex];
      if (filterStatus == null) return true;
      return filterStatus == status;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Pesanan",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // ✅ teks rata kiri
          children: [
            const Text(
              "Pesanan Saya",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),

            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(statusList.length, (index) {
                  final isSelected = filterStatus == statusList[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          filterStatus = null;
                        } else {
                          filterStatus = statusList[index];
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: _StatusIcon(
                        icon: _getIcon(statusList[index]),
                        label: statusList[index],
                        active: isSelected,
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),

            if (filteredOrders.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Belum ada pesanan",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
              )
            else
              Column(
                children: filteredOrders
                    .map((order) => _TransaksiCard(
                          title: "Belanja",
                          date: order.date,
                          product: order.title,
                          price: order.price * order.quantity,
                          status: statusList[order.statusIndex],
                          onDelete: () => _deleteOrder(order),
                        ))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String status) {
    switch (status) {
      case "Pembayaran":
        return Icons.payment;
      case "Proses":
        return Icons.inventory;
      case "Dikirim":
        return Icons.local_shipping;
      case "Sampai":
        return Icons.inventory_2;
      case "Review":
        return Icons.reviews;
      default:
        return Icons.help;
    }
  }
}

class _StatusIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _StatusIcon({
    required this.icon,
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: active ? Colors.blue : Colors.grey[200],
          child: Icon(icon, color: active ? Colors.white : Colors.black),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
            color: active ? Colors.blue : Colors.black,
          ),
        ),
      ],
    );
  }
}

class _TransaksiCard extends StatelessWidget {
  final String title;
  final String date;
  final String product;
  final double price;
  final String status;
  final VoidCallback onDelete;

  const _TransaksiCard({
    required this.title,
    required this.date,
    required this.product,
    required this.price,
    required this.status,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10), // ✅ compact
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.shopping_bag,
                      color: Colors.blue, size: 20), // ✅ biru
                  const SizedBox(width: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13)),
                      Text(date,
                          style: TextStyle(
                              color: Colors.grey[600], fontSize: 11)),
                    ],
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.green.shade50,
                      border: Border.all(color: Colors.green),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(color: Colors.green, fontSize: 11),
                    ),
                  ),
                  if (status == "Review") ...[
                    const SizedBox(width: 6),
                    InkWell(
                      onTap: onDelete,
                      borderRadius: BorderRadius.circular(20),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 18,
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ],
          ),
          const Divider(height: 18),
          Text(product,
              style: const TextStyle(fontSize: 13, color: Colors.black)),
          const SizedBox(height: 4),
          Text(
            "Rp${price.toStringAsFixed(2)}",
            style: const TextStyle(
                fontSize: 13, color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
