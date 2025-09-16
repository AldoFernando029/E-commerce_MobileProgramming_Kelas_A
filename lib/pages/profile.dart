import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/menupage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String alamat =
      "PT Tembilahan Berkah Jaya, Perumahan Rajawali Sakti, Simpang Baru, Kec. Tampan, Kota Pekanbaru, Riau 28293. (Rumah Batu) (Disamping Tower). TAMPAN, KOTA PEKANBARU, RIAU, ID 28293";

  final TextEditingController _alamatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAlamat();
  }

  Future<void> _loadAlamat() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      alamat = prefs.getString('alamat') ?? alamat;
    });
  }

  Future<void> _saveAlamat(String newAlamat) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('alamat', newAlamat);
  }

  void _showBiodataPopup() {
    _alamatController.text = alamat;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Biodata"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage("assets/profile.jpg"),
              ),
              const SizedBox(height: 12),
              const Text(
                "Nama: Muhammad Aldi Rifky Pasaribu",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text("Member: Gold"),
              const SizedBox(height: 12),
              const Text(
                "Alamat:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _alamatController,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                alamat = _alamatController.text;
              });
              _saveAlamat(alamat);
              Navigator.pop(context);
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile info
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _showBiodataPopup, 
                      child: const CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage("assets/profile.jpg"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Muhammad Aldi Rifky Pasaribu",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "Member Gold",
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Transaksi",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _MenuIcon(
                    icon: Icons.payment,
                    label: "Pembayaran",
                    onTap: () => _openMenuPage(context, "Pembayaran"),
                  ),
                  _MenuIcon(
                    icon: Icons.inventory,
                    label: "Proses",
                    onTap: () => _openMenuPage(context, "Proses"),
                  ),
                  _MenuIcon(
                    icon: Icons.local_shipping,
                    label: "Dikirim",
                    onTap: () => _openMenuPage(context, "Dikirim"),
                  ),
                  _MenuIcon(
                    icon: Icons.inventory_2,
                    label: "Sampai",
                    onTap: () => _openMenuPage(context, "Sampai"),
                  ),
                  _MenuIcon(
                    icon: Icons.reviews,
                    label: "Review",
                    onTap: () => _openMenuPage(context, "Review"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openMenuPage(BuildContext context, String status) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MenuPage(),
        settings: RouteSettings(arguments: status),
      ),
    );
  }
}

class _MenuIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuIcon({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: Icon(icon, color: Colors.black),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
