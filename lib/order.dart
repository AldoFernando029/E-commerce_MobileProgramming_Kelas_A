import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pesanan Saya",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ====== STATUS ORDER ======
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statusIcon(Icons.payment, "Pembayaran"),
                _statusIcon(Icons.timelapse, "Proses"),
                _statusIcon(Icons.local_shipping, "Dikirim"),
                _statusIcon(Icons.inventory, "Sampai"),
                _statusIcon(Icons.reviews, "Review"),
              ],
            ),
            const SizedBox(height: 20),

            // ====== LIST PESANAN ======
            _orderCard(
              title: "Fjällräven Kånken No. 2",
              date: "12 Jun 2025",
              price: "\$153,53",
              status: "Berhasil",
            ),
            const SizedBox(height: 12),
            _orderCard(
              title: "Fjällräven Kånken No. 2",
              date: "12 Jun 2025",
              price: "\$153,53",
              status: "Berhasil",
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk ikon status
  Widget _statusIcon(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey[200],
          child: Icon(icon, color: Colors.black),
        ),
        const SizedBox(height: 6),
        Text(label, style: GoogleFonts.poppins(fontSize: 12)),
      ],
    );
  }

  // Widget untuk card pesanan
  Widget _orderCard({
    required String title,
    required String date,
    required String price,
    required String status,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Row(
        children: [
          const Icon(Icons.shopping_bag, size: 36, color: Colors.black54),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Belanja",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  date,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  price,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green),
            ),
            child: Text(
              status,
              style: GoogleFonts.poppins(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
