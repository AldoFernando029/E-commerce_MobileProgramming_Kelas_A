class Order {
  final String title;
  final String date;
  final double price;
  final String image;
  int quantity;

  int statusIndex;

  bool isSelected;

  Order({
    required this.title,
    required this.date,
    required this.price,
    required this.image,
    this.quantity = 1,
    this.statusIndex = 0,
    this.isSelected = false,
  });

  Map<String, dynamic> toJson() => {
        "title": title,
        "date": date,
        "price": price,
        "image": image,
        "quantity": quantity,
        "statusIndex": statusIndex,
        "isSelected": isSelected,
      };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        title: json["title"],
        date: json["date"],
        price: (json["price"] as num).toDouble(),
        image: json["image"],
        quantity: json["quantity"] ?? 1,
        statusIndex: json["statusIndex"] ?? 0,
        isSelected: json["isSelected"] ?? false,
      );
}
