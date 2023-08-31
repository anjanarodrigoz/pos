class ExtraCharges {
  static const String nameKey = 'name';
  static const String qtyKey = 'qty';
  static const String priceKey = 'price';
  static const String commentKey = 'comment';
  static const String idKey = 'id';

  late String id;
  String name;
  int qty;
  double price;
  String? comment;

  ExtraCharges({
    required this.name,
    required this.qty,
    required this.price,
    this.comment,
  }) {
    id = '${DateTime.now().millisecondsSinceEpoch}';
  }

  double get netTotal => price * qty;

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
