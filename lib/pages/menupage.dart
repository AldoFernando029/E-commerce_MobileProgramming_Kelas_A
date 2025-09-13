import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> transaksi = [
      {
        "title": "Belanja",
        "date": "12 Jun 2025",
        "product": "Fjällräven Kånken No. 2",
        "price": 153.53,
        "status": "Berhasil"
      },
      {
        "title": "Belanja",
        "date": "12 Jun 2025",
        "product": "Fjällräven Kånken No. 2",
        "price": 153.53,
        "status": "Berhasil"
      },
    ];

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pesanan Saya",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Status Pesanan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _StatusIcon(icon: Icons.payment, label: "Pembayaran"),
                _StatusIcon(icon: Icons.inventory, label: "Proses"),
                _StatusIcon(icon: Icons.local_shipping, label: "Dikirim"),
                _StatusIcon(icon: Icons.inventory_2, label: "Sampai"),
                _StatusIcon(icon: Icons.reviews, label: "Review"),
              ],
            ),
            const SizedBox(height: 20),

            // Daftar Transaksi
            Column(
              children: transaksi
                  .map((trx) => _TransaksiCard(
                        title: trx["title"],
                        date: trx["date"],
                        product: trx["product"],
                        price: trx["price"],
                        status: trx["status"],
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatusIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey[200],
          child: Icon(icon, color: Colors.black),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
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

  const _TransaksiCard({
    required this.title,
    required this.date,
    required this.product,
    required this.price,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.shopping_bag, color: Colors.black54),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      Text(date,
                          style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    ],
                  )
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.green.shade50,
                  border: Border.all(color: Colors.green),
                ),
                child: Text(
                  status,
                  style: const TextStyle(color: Colors.green, fontSize: 12),
                ),
              )
            ],
          ),
          const Divider(height: 20),
          Text(product,
              style: const TextStyle(fontSize: 14, color: Colors.black)),
          const SizedBox(height: 6),
          Text(
            "\$${price.toStringAsFixed(2)}",
            style: const TextStyle(
                fontSize: 14, color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
