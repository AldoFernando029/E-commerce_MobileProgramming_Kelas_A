import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../order/order_provider.dart';
import '../order/order_model.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrderProvider>().orders;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Keranjang"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: orders.isEmpty
          ? const Center(child: Text("Keranjang masih kosong"))
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: orders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final Order order = orders[index];
                      return _cartItem(context, order, index);
                    },
                  ),
                ),
                // Footer Beli Semua
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: Colors.grey.shade300)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 8),
                      const Text("Semua"),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Checkout berhasil 🚀"),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                        ),
                        child: const Text("Beli"),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }

 Widget _cartItem(BuildContext context, Order order, int index) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 3))
      ],
    ),
    child: Row(
      children: [
        // ✅ Gambar produk
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            order.image,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 60,
              height: 60,
              color: Colors.grey[300],
              child: const Icon(Icons.image_not_supported, color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // ✅ Info produk
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(order.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 4),
              Text(
                "\$${order.price.toStringAsFixed(2)}",
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        // ✅ Tombol jumlah +/-
        Row(
          children: [
            IconButton(
              onPressed: () {
                Provider.of<OrderProvider>(context, listen: false)
                    .decreaseQty(index);
              },
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text("${order.quantity}"),
            ),
            IconButton(
              onPressed: () {
                Provider.of<OrderProvider>(context, listen: false)
                    .increaseQty(index);
              },
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        )
      ],
    ),
  );
}
}