import 'dart:convert';
import 'package:http/http.dart' as http;

class Product {
  final int id;
  final String title;
  final String image;
  final double price;
  final String description;
  final String category;
  final double rating; 
  final int ratingCount; 

  Product({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.description,
    required this.category,
    required this.rating,
    required this.ratingCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      title: json['title'] ?? "Tanpa Judul",
      image: json['image'] ?? "",
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] ?? "Deskripsi tidak tersedia",
      category: json['category'] ?? "Umum",
      rating: (json['rating'] != null && json['rating']['rate'] != null)
          ? (json['rating']['rate'] as num).toDouble()
          : 0.0,
      ratingCount: (json['rating'] != null && json['rating']['count'] != null)
          ? (json['rating']['count'] as num).toInt()
          : 0,
    );
  }
}

Future<List<Product>> fetchProducts() async {
  final response =
      await http.get(Uri.parse("https://fakestoreapi.com/products"));
  if (response.statusCode == 200) {
    List data = jsonDecode(response.body);
    return data.map((e) => Product.fromJson(e)).toList();
  } else {
    throw Exception("Gagal load produk");
  }
}
