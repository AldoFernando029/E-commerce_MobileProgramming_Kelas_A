class Order {
  final String title;
  final String date;
  final double price;
  final String image; 
  int quantity;

  // ✅ Tambahkan flag untuk checkbox
  bool isSelected;

  Order({
    required this.title,
    required this.date,
    required this.price,
    required this.image,
    this.quantity = 1,
    this.isSelected = false, // ✅ default false biar gak null
  });

   Map<String, dynamic> toJson() => {
        "title": title,
        "date": date,
        "price": price,
        "image": image,
        "quantity": quantity,
        "isSelected": isSelected,
      };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        title: json["title"],
        date: json["date"],
        price: json["price"],
        image: json["image"],
        quantity: json["quantity"],
        isSelected: json["isSelected"] ?? false,
      );
}

