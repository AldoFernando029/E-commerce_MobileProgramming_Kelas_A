import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../order/order_model.dart';
import '../order/order_provider.dart';
import '../pay/kuypay.dart'; // ✅ KuyPay ditambahkan
import 'menupage.dart';

class CheckoutPage extends StatefulWidget {
  final List<Order> selectedOrders;

  const CheckoutPage({super.key, required this.selectedOrders});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String alamat = "Memuat alamat...";

  @override
  void initState() {
    super.initState();
    _loadAlamat();
  }

  Future<void> _loadAlamat() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      alamat =
          prefs.getString('alamat') ??
          "Alamat belum diatur. Silakan update di Profile.";
    });
  }

  Future<void> _simpanPesanan() async {
    final prefs = await SharedPreferences.getInstance();
    final existingOrders = prefs.getStringList('orders') ?? [];
    final newOrders =
        widget.selectedOrders.map((order) => jsonEncode(order.toJson())).toList();
    existingOrders.addAll(newOrders);
    await prefs.setStringList('orders', existingOrders);
  }

  @override
  Widget build(BuildContext context) {
    double totalHarga = widget.selectedOrders.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Alamat Pengiriman",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Text(alamat),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: ListView.separated(
                itemCount: widget.selectedOrders.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final order = widget.selectedOrders[index];
                  return ListTile(
                    leading: Image.network(order.image, width: 50, height: 50),
                    title: Text(order.title),
                    subtitle: Text(
                      "${order.quantity} x Rp${order.price.toStringAsFixed(2)}",
                    ),
                    trailing: Text(
                      "Rp${(order.price * order.quantity).toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Rp${totalHarga.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                final kuypay = Provider.of<KuyPay>(context, listen: false);

                if (kuypay.pay(totalHarga)) {
                  await _simpanPesanan();
                  context.read<OrderProvider>().checkoutSelected();

                  if (!mounted) return;

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MenuPage()),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Pesanan berhasil dikonfirmasi! Saldo berkurang Rp$totalHarga",
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Saldo tidak cukup untuk konfirmasi!")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                "Konfirmasi Pesanan",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
