import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'search.dart';
import 'profile.dart';
import 'order.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1; // default ke Home

  final List<Widget> _pages = [
    const ProfilePage(),
    const HomeContent(),
    const SearchPage(),
    const OrderPage(), // halaman Pesanan
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Search"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: "Pesanan",
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ====== HEADER ======
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "9:41",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Row(
                  children: [
                    Icon(Icons.signal_cellular_alt, size: 16),
                    SizedBox(width: 4),
                    Icon(Icons.wifi, size: 16),
                    SizedBox(width: 4),
                    Icon(Icons.battery_full, size: 16),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ====== SEARCH & CART ======
            Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: true,
                    onTap: () {
                      // pindah ke search page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchPage(),
                        ),
                      );
                    },
                    decoration: InputDecoration(
                      hintText: "Mau Belanja Apa?",
                      hintStyle: GoogleFonts.poppins(fontSize: 13),
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ====== Banner ======
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Temukan Gaya & Kenyamanan dengan Fjällräven Kånken",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Image.network(
                        "https://www.fjallraven.com/globalassets/catalogs/fjallraven/f230/f23012/f23012-560_1_fjallraven-kanken-classic.png",
                        width: 100,
                      ),
                      const SizedBox(width: 16),
                      Image.network(
                        "https://www.fjallraven.com/globalassets/catalogs/fjallraven/f235/f23510/f23510-540_1_kanken.png",
                        width: 100,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ====== Produk Grid ======
            GridView.builder(
              itemCount: 4,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final harga = index == 0 ? "\$153,53" : "\$102,64";
                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Image.network(
                          "https://www.fjallraven.com/globalassets/catalogs/fjallraven/f232/f23222/f23222-046_1_kanken-backpack.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        index == 0
                            ? "Fjällräven Kånken No. 2"
                            : "Fjällräven Kånken High\nCoast Foldsack 24",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        harga,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
