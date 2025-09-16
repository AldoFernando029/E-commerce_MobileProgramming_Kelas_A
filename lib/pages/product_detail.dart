import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../utils/utils.dart';
import '../order/order_provider.dart';
import '../order/order_model.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Gambar produk
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.grey[200],
              child: Image.network(product.image, fit: BoxFit.contain),
            ),
            const SizedBox(height: 16),

            // ✅ Judul
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                product.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // ✅ Harga
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "\$${product.price.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // ✅ Rating
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    "${product.rating} (${product.ratingCount} ulasan)",
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const Divider(height: 30),

            // ✅ Deskripsi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                product.description,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ✅ Kategori
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Kategori: ${product.category}",
                style: const TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: Colors.blueGrey,
                ),
              ),
            ),
          ],
        ),
      ),

      // ✅ Tombol beli (masuk ke keranjang)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton(
          onPressed: () {
            final now =
                DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now());

            context.read<OrderProvider>().addOrder(
                  Order(
                    title: product.title,
                    date: now,
                    price: product.price,
                    image: product.image,
                    quantity: 1,
                  ),
                );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Produk ditambahkan ke keranjang 🛒")),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "Beli Sekarang",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
