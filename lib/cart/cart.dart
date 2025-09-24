import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../order/order_provider.dart';
import '../order/order_model.dart';
import '../pages/checkout.dart'; 

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final orders = orderProvider.orders;

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
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: Colors.grey.shade300)),
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: orders.isNotEmpty &&
                            orders.every((o) => o.isSelected),
                        onChanged: (value) {
                          orderProvider.selectAll(value ?? false);
                        },
                      ),
                      const Text("Semua"),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: orderProvider.selectedOrders.isEmpty
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CheckoutPage(
                                      selectedOrders:
                                          orderProvider.selectedOrders,
                                    ),
                                  ),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
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
    final provider = Provider.of<OrderProvider>(context, listen: false);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          Checkbox(
            value: order.isSelected,
            onChanged: (_) {
              provider.toggleSelection(index);
            },
          ),
          const SizedBox(width: 8),

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
                child: const Icon(Icons.image_not_supported,
                    color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  "Rp ${order.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          Row(
            children: [
              IconButton(
                onPressed: () => provider.decreaseQty(index),
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
                onPressed: () => provider.increaseQty(index),
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          )
        ],
      ),
    );
  }
}
