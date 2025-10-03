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
    final formattedPrice = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp',
      decimalDigits: 2,
    ).format(product.price);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          product.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar produk dengan efek bayangan
            Container(
              height: 300,
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(product.image, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                product.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                formattedPrice,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    "${product.rating} (${product.ratingCount} ulasan)",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const Divider(height: 30, thickness: 1.2),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                product.description,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 12),

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
            const SizedBox(height: 20),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: ElevatedButton(
          onPressed: () {
            final now = DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now());

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
            backgroundColor: Colors.blueAccent,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
            shadowColor: Colors.black26,
          ),
          child: const Text(
            "Masukan Keranjang",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
