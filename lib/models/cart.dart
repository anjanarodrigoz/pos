import 'dart:math';

import '../utils/val.dart';
import 'invoice_item.dart';

class Cart {
  static const String itemIdKey = 'itemId';
  static const String nameKey = 'name';
  static const String cartIdKey = 'cartId';
  static const String commentKey = 'comment';
  static const String netPriceKey = 'netPrice';
  static const String qtyKey = 'qty';
  static const String isPostedItemKey = 'isPostedItem';

  final String itemId;
  String? cartId;
  String name;
  String? comment;
  double price;
  int qty;
  bool isPostedItem;

  Cart({
    required this.itemId,
    required this.name,
    this.comment,
    this.cartId,
    required this.price,
    required this.qty,
    this.isPostedItem = false,
  });

  Cart copyWith({
    String? itemId,
    String? cartId,
    String? name,
    String? comment,
    double? netPrice,
    int? qty,
    bool? isPostedItem,
  }) {
    return Cart(
      itemId: itemId ?? this.itemId,
      cartId: cartId ?? this.cartId,
      name: name ?? this.name,
      comment: comment ?? this.comment,
      price: netPrice ?? this.price,
      qty: qty ?? this.qty,
      isPostedItem: isPostedItem ?? this.isPostedItem,
    );
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      itemId: json[itemIdKey],
      name: json[nameKey],
      comment: json[commentKey],
      price: json[netPriceKey],
      cartId: json[cartIdKey],
      qty: json[qtyKey],
      isPostedItem: json[isPostedItemKey],
    );
  }

  factory Cart.fromInvoiceItem(InvoicedItem item) {
    return Cart(
        cartId: generateUniqueItemId(),
        itemId: item.itemId,
        name: item.name,
        price: item.netPrice,
        qty: item.qty,
        isPostedItem: item.isPostedItem,
        comment: item.comment);
  }

  Map<String, dynamic> toJson() {
    return {
      itemIdKey: itemId,
      nameKey: name,
      commentKey: comment,
      netPriceKey: price,
      qtyKey: qty,
      cartIdKey: cartId,
      isPostedItemKey: isPostedItem,
    };
  }

  static String generateUniqueItemId() {
    final random = Random();
    return '${DateTime.now().millisecondsSinceEpoch}_${random.nextInt(10000)}';
  }

  double get gst => (price * Val.gstPrecentage);

  double get totalGst => gst * qty;

  double get netTotal => price * qty;

  double get itemPrice => price * Val.gstTotalPrecentage;

  double get totalPrice => itemPrice * qty;
}
