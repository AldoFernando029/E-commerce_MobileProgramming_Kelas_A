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
        title: const Text("Biodata"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _isPicking ? null : _pickImage,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: profileImagePath != null
                      ? FileImage(File(profileImagePath!))
                      : null,
                  child: profileImagePath == null
                      ? const Icon(Icons.person, size: 40, color: Colors.grey)
                      : null,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Nama: $username",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text("Member: Gold"),
              const SizedBox(height: 12),
              const Text(
                "Nomor Telepon:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Masukkan nomor telepon",
                ),
              ),
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
                phone = _phoneController.text;
              });
              _saveAlamat(alamat);
              _savePhone(phone);
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
        child: Column(
          children: [
            Expanded(
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
                            child: CircleAvatar(
                              radius: 30,
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                username,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                phone,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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

            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(
                  onPressed: _logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Logout"),
                ),
              ),
            )
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
