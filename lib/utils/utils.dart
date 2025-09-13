import 'dart:convert';
import 'package:http/http.dart' as http;

class Product {
  final int id;
  final String title;
  final String image;
  final double price;

  Product({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      price: (json['price'] as num).toDouble(),
    );
  }
}

Future<List<Product>> fetchProducts() async {
  final response = await http.get(Uri.parse("https://fakestoreapi.com/products"));
  if (response.statusCode == 200) {
    List data = jsonDecode(response.body);
    return data.map((e) => Product.fromJson(e)).toList();
  } else {
    throw Exception("Gagal load produk");
  }
}
