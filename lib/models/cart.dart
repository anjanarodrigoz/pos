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
  double netPrice;
  int qty;
  bool isPostedItem;

  Cart({
    required this.itemId,
    required this.name,
    this.comment,
    this.cartId,
    required this.netPrice,
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
      netPrice: netPrice ?? this.netPrice,
      qty: qty ?? this.qty,
      isPostedItem: isPostedItem ?? this.isPostedItem,
    );
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      itemId: json[itemIdKey],
      name: json[nameKey],
      comment: json[commentKey],
      netPrice: json[netPriceKey],
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
        netPrice: item.netPrice,
        qty: item.qty,
        comment: item.comment);
  }

  Map<String, dynamic> toJson() {
    return {
      itemIdKey: itemId,
      nameKey: name,
      commentKey: comment,
      netPriceKey: netPrice,
      qtyKey: qty,
      cartIdKey: cartId,
      isPostedItemKey: isPostedItem,
    };
  }

  static String generateUniqueItemId() {
    final random = Random();
    return '${DateTime.now().millisecondsSinceEpoch}_${random.nextInt(10000)}';
  }

  double get gst => (netPrice * Val.gstPrecentage);

  double get totalGst => gst * qty;

  double get netTotal => netPrice * qty;

  double get itemPrice => netPrice * Val.gstTotalPrecentage;

  double get totalPrice => itemPrice * qty;
}
