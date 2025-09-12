import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Status Bar", style: GoogleFonts.poppins(fontSize: 14)),
                Text(
                  "Profil",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Profile Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      "https://i.pravatar.cc/150?img=3",
                    ), // dummy foto
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Muhammad Aldi Rifky Pasaribu",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "Member Gold",
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Alamat
            Text(
              "Alamat",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "PT Tembilahan Berkah Jaya, Perumahan Rajawali Sakti, Simpang Baru, Kec. Tampan, Kota Pekanbaru, RIAU, ID 28293",
                style: GoogleFonts.poppins(fontSize: 12),
              ),
            ),
            const SizedBox(height: 16),

            // Menu Transaksi
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
                foregroundColor: Colors.black,
              ),
              child: const Text("Transaksi"),
            ),
            const SizedBox(height: 12),

            // Ikon status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _ProfileIcon(icon: Icons.payment, label: "Pembayaran"),
                _ProfileIcon(icon: Icons.work, label: "Proses"),
                _ProfileIcon(icon: Icons.local_shipping, label: "Dikirim"),
                _ProfileIcon(icon: Icons.check_circle, label: "Sampai"),
                _ProfileIcon(icon: Icons.reviews, label: "Review"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ProfileIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.black54),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }
}
