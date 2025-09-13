class Order {
  final String title;
  final String date;
  final double price;
  final String image; // ✅ tambahkan image
  int quantity;

  Order({
    required this.title,
    required this.date,
    required this.price,
    required this.image, // ✅ wajib isi
    this.quantity = 1,
  });
}
