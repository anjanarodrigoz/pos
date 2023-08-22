class ExtraCharges {
  static const String nameKey = 'name';
  static const String qtyKey = 'qty';
  static const String priceKey = 'price';
  static const String commentKey = 'comment';

  String name;
  int qty;
  double price;
  String? comment;

  ExtraCharges({
    required this.name,
    required this.qty,
    required this.price,
    this.comment,
  });

  factory ExtraCharges.fromJson(Map<String, dynamic> json) {
    return ExtraCharges(
      name: json[nameKey],
      qty: json[qtyKey],
      price: json[priceKey],
      comment: json[commentKey],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      nameKey: name,
      qtyKey: qty,
      priceKey: price,
      commentKey: comment,
    };
  }
}
