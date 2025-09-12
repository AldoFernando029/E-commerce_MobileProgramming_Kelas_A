import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _allProducts = [
    {
      "name": "Fjällräven Kånken No. 2",
      "price": "\$153,53",
      "image":
          "https://www.fjallraven.com/globalassets/catalogs/fjallraven/f232/f23222/f23222-046_1_kanken-backpack.png",
    },
    {
      "name": "Fjällräven Kånken High Coast Foldsack 24",
      "price": "\$102,64",
      "image":
          "https://www.fjallraven.com/globalassets/catalogs/fjallraven/f235/f23510/f23510-540_1_kanken.png",
    },
    {
      "name": "Fjällräven Kånken Classic",
      "price": "\$95,00",
      "image":
          "https://www.fjallraven.com/globalassets/catalogs/fjallraven/f230/f23012/f23012-560_1_fjallraven-kanken-classic.png",
    },
  ];

  List<Map<String, dynamic>> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _filteredProducts = _allProducts;
  }

  void _search(String query) {
    setState(() {
      _filteredProducts = _allProducts
          .where((p) => p["name"].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Cari produk...",
            hintStyle: GoogleFonts.poppins(fontSize: 14),
            border: InputBorder.none,
          ),
          onChanged: _search,
        ),
      ),
      body: _filteredProducts.isEmpty
          ? Center(
              child: Text(
                "Produk tidak ditemukan",
                style: GoogleFonts.poppins(fontSize: 14),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _filteredProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
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
                          product["image"],
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product["name"],
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product["price"],
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
    );
  }
}
