import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/utils.dart';
import '../order/order_provider.dart';
import '../order/order_model.dart';
import '../pay/kuypay.dart'; 
import 'search.dart';
import 'package:marketplace_app/cart/cart.dart';
import 'package:intl/intl.dart';
import 'product_detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product>> products;
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    products = fetchProducts();

    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: const Color.fromARGB(255, 240, 252, 255),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
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
                    Consumer<OrderProvider>(
                      builder: (context, orderProvider, child) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CartPage(),
                              ),
                            );
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color.fromARGB(255, 234, 252, 255),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.shopping_cart_outlined),
                              ),
                              if (orderProvider.orders.isNotEmpty)
                                Positioned(
                                  right: 0,
                                  top: -2,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      "${orderProvider.orders.length}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Consumer<KuyPay>(
                  builder: (context, kuypay, _) {
                    final formattedBalance = NumberFormat.currency(
                      locale: 'id',
                      symbol: 'Rp',
                      decimalDigits: 2,
                    ).format(kuypay.balance);

                    return Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _showTopUpDialog(context),
                            child: _chip(
                              icon: Icons.account_balance_wallet_outlined,
                              label: "KuyPay  |  $formattedBalance",
                              color: Colors.blue,
                              boxColor: const Color.fromARGB(255, 220, 240, 255),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: InkWell(
                            onTap: () => _showIdentitasDialog(context),
                            child: _chip(
                              icon: Icons.shopping_bag_outlined,
                              label: "Kuy Belanja Aja!",
                              color: Colors.green,
                              boxColor: const Color.fromARGB(255, 220, 255, 220),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 22),

                SizedBox(
                  height: 120,
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          children: [
                            _promoCard(
                              title:
                                  "Temukan Gaya & Kenyamanan dengan Fjällräven Kånken",
                              image: "assets/bag.png",
                            ),
                            _promoCard(
                              title:
                                  "Diskon 50% untuk Sepatu Olahraga Terbaru!",
                              image: "assets/shoes.png",
                            ),
                            _promoCard(
                              title:
                                  "Promo Gadget Kekinian dengan Harga Spesial",
                              image: "assets/phone.png",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage == index ? 16 : 8,
                            height: 5,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? Colors.blue
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // 📦 Produk
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
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.78,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final product = snapshot.data![index];
                        return ProductCard(product: product);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Chip
  Widget _chip({
    IconData? icon,
    required String label,
    Color? color,
    Color? boxColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: boxColor ?? Colors.grey[200],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) Icon(icon, size: 18, color: color ?? Colors.black),
          if (icon != null) const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: color ?? Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _promoCard({required String title, required String image}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(image, fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Dialog Top Up KuyPay
  void _showTopUpDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        final kuypay = context.watch<KuyPay>();
        final formattedBalance = NumberFormat.currency(
          locale: 'id',
          symbol: 'Rp',
          decimalDigits: 2,
        ).format(kuypay.balance);

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.account_balance_wallet_outlined,
                    size: 40, color: Colors.blue),
                const SizedBox(height: 12),
                const Text(
                  "Top Up KuyPay",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text("Sisa Saldo: $formattedBalance",
                    style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Masukkan jumlah",
                    prefixText: "Rp ",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Batal"),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        final amount = double.tryParse(controller.text) ?? 0;
                        if (amount > 0) {
                          context.read<KuyPay>().topUp(amount);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green,
                              content: Text("Top up Rp${amount.toStringAsFixed(0)}"),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.check_circle_outline, size: 18),
                      label: const Text("Top Up"),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // 🔹 Dialog Identitas 4 anggota
  void _showIdentitasDialog(BuildContext context) {
    final anggota = [
      {"nama": "Muhammad Aldi Rifky Pasaribu", "nim": "535240005"},
      {"nama": "Aldo Fernando", "nim": "535240029"},
      {"nama": "Howard Dominikov Oei", "nim": "535240014"},
      {"nama": "Dafiza Mutakin", "nim": "535240032"},
    ];

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start, // ✅ Rata kiri
              children: [
                const Text("Identitas Anggota Kelompok E-Commerce",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                const Divider(thickness: 1),
                const SizedBox(height: 10),
                ...anggota.map((a) => Align(
                      alignment: Alignment.centerLeft, // ✅ Box ikut rata kiri
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 200,
                          maxWidth: 280,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Nama : ${a["nama"]}",
                                textAlign: TextAlign.start,
                                style: const TextStyle(fontWeight: FontWeight.w500)),
                            Text("NIM   : ${a["nim"]}",
                                textAlign: TextAlign.start,
                                style: const TextStyle(fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    )),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Tutup"),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
          borderRadius: BorderRadius.circular(14),
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
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(14),
                  ),
                ),
                child: Image.network(product.image, fit: BoxFit.contain),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13)),
                  const SizedBox(height: 4),
                  Text("Rp${product.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 13,
                          color: Colors.red,
                          fontWeight: FontWeight.bold)),
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
                          image: product.image,
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
                    child: const Text("Beli",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
