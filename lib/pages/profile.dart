import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/menupage.dart';
import 'login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String alamat =
      "PT Tembilahan Berkah Jaya, Perumahan Rajawali Sakti, Simpang Baru, Kec. Tampan, Kota Pekanbaru, Riau 28293. (Rumah Batu) (Disamping Tower). TAMPAN, KOTA PEKANBARU, RIAU, ID 28293";

  String username = "User";
  String phone = "Belum ada nomor";
  String? profileImagePath;

  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isPicking = false;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      alamat = prefs.getString('alamat') ?? alamat;
      username = prefs.getString("username") ?? "User";
      phone = prefs.getString("phone") ?? "Belum ada nomor";
      profileImagePath = prefs.getString("profileImage");
    });
  }

  Future<void> _saveAlamat(String newAlamat) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('alamat', newAlamat);
  }

  Future<void> _savePhone(String newPhone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('phone', newPhone);
  }

  Future<void> _pickImage() async {
    if (_isPicking) return;
    _isPicking = true;

    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);

      if (picked != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("profileImage", picked.path);

        setState(() {
          profileImagePath = picked.path;
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    } finally {
      _isPicking = false;
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  void _showBiodataPopup() {
    _alamatController.text = alamat;
    _phoneController.text = phone;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Edit Biodata",
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _isPicking ? null : _pickImage,
                child: CircleAvatar(
                  radius: 45,
                  backgroundImage: profileImagePath != null
                      ? FileImage(File(profileImagePath!))
                      : null,
                  child: profileImagePath == null
                      ? const Icon(Icons.person, size: 45, color: Colors.grey)
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Nomor Telepon",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _alamatController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Alamat",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.home),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal")),
          ElevatedButton.icon(
            icon: const Icon(Icons.save),
            onPressed: () {
              setState(() {
                alamat = _alamatController.text;
                phone = _phoneController.text;
              });
              _saveAlamat(alamat);
              _savePhone(phone);
              Navigator.pop(context);
            },
            label: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Column(
          children: [
            // Bagian Profile Card (diperkecil)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                color: Colors.blue,
                elevation: 4,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _showBiodataPopup,
                        child: CircleAvatar(
                          radius: 30, // lebih kecil
                          backgroundColor: Colors.white,
                          backgroundImage: profileImagePath != null
                              ? FileImage(File(profileImagePath!))
                              : null,
                          child: profileImagePath == null
                              ? const Icon(Icons.person,
                                  size: 30, color: Colors.grey)
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(username,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white)),
                            const SizedBox(height: 4),
                            Text(phone,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.white70)),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Text("Member Gold",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11)),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Transaksi",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),

                    // Transaksi Card (icon tanpa label)
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _MenuIcon(
                                icon: Icons.payment,
                                onTap: () =>
                                    _openMenuPage(context, "Pembayaran")),
                            _MenuIcon(
                                icon: Icons.inventory,
                                onTap: () => _openMenuPage(context, "Proses")),
                            _MenuIcon(
                                icon: Icons.local_shipping,
                                onTap: () =>
                                    _openMenuPage(context, "Dikirim")),
                            _MenuIcon(
                                icon: Icons.inventory_2,
                                onTap: () =>
                                    _openMenuPage(context, "Sampai")),
                            _MenuIcon(
                                icon: Icons.reviews,
                                onTap: () =>
                                    _openMenuPage(context, "Review")),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Text("Alamat",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),

                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(alamat,
                            style: const TextStyle(fontSize: 14)),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: _logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(45),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.logout),
                    label: const Text("Logout"),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "© 2025 PT Tembilahan Berkah Jaya\nAll rights reserved",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
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
  final VoidCallback onTap;

  const _MenuIcon({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.blue.withOpacity(0.1),
        child: Icon(icon, color: Colors.blue),
      ),
    );
  }
}
