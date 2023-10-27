import '../utils/val.dart';

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

  factory ExtraCharges.fromJson(Map<String, dynamic> json) {
    return ExtraCharges(
      name: json[nameKey],
      qty: json[qtyKey],
      price: json[priceKey],
      comment: json[commentKey],
    );
  }

  ExtraCharges updateQuantity({required int qty}) {
    return ExtraCharges(name: name, qty: qty + this.qty, price: price);
  }

  Map<String, dynamic> toJson() {
    return {
      nameKey: name,
      qtyKey: qty,
      priceKey: price,
      commentKey: comment,
    };
  }

  double get gst => (price * Val.gstPrecentage);

  double get totalGst => gst * qty;

  double get netTotal => price * qty;

  double get itemPrice =>
      double.parse((price * Val.gstTotalPrecentage).toStringAsFixed(2));

  double get totalPrice => itemPrice * qty;
}
