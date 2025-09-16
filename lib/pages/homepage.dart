import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/utils.dart';
import '../order/order_provider.dart';
import '../order/order_model.dart';
import 'search.dart';
import 'package:marketplace_app/cart/cart.dart';
import 'package:intl/intl.dart';
import 'product_detail.dart'; // ✅ tambahkan ini

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product>> products;

  @override
  void initState() {
    super.initState();
    products = fetchProducts(); // panggil dari utils.dart
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔍 Search bar + cart
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.grey[200],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.grey),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                  hintText: "Mau Belanja Apa?",
                                  border: InputBorder.none,
                                ),
                                onSubmitted: (value) {
                                  if (value.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SearchPage(initialQuery: value),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CartPage()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                        ),
                        child: const Icon(Icons.shopping_cart_outlined),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                // Wishlist + Status + Balance
                Row(
                  children: [
                    _chip(
                        icon: Icons.favorite,
                        label: "Wishlist",
                        color: Colors.red),
                    const SizedBox(width: 8),
                    _chip(label: "Status"),
                    const SizedBox(width: 8),
                    _chip(label: "AldiPay\nSaldo : 900\$"),
                  ],
                ),

                const SizedBox(height: 20),

                // Banner Promo
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "Temukan Gaya & Kenyamanan dengan Fjällräven Kånken",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.shopping_bag,
                            size: 40, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Produk dari API
                FutureBuilder<List<Product>>(
                  future: products,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("Produk kosong"));
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final product = snapshot.data![index];
                        return ProductCard(product: product);
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chip({IconData? icon, required String label, Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[200],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon, size: 18, color: color ?? Colors.black),
          if (icon != null) const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // ✅ supaya klik gambar/teks/harga buka detail
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailPage(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Gambar produk
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(15)),
                ),
                child: Image.network(
                  product.image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "\$${product.price.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      final now =
                          DateFormat("dd MMM yyyy").format(DateTime.now());

                      Provider.of<OrderProvider>(context, listen: false)
                          .addOrder(
                        Order(
                          title: product.title,
                          date: now,
                          price: product.price,
                          image: product.image, // ✅ tambahkan image ke Order
                        ),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Pesanan ditambahkan!")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 36),
                    ),
                    child: const Text("Berbelanja"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
