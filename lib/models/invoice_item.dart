class InvoicedItem {
  static const String itemIdKey = 'itemId';
  static const String nameKey = 'name';
  static const String commentKey = 'comment';
  static const String netPriceKey = 'netPrice';
  static const String qtyKey = 'qty';
  static const String isPostedItemKey = 'isPostedItem';

  final String itemId;
  String name;
  String? comment;
  double netPrice;
  int qty;
  bool isPostedItem;

  InvoicedItem({
    required this.itemId,
    required this.name,
    this.comment,
    required this.netPrice,
    required this.qty,
    this.isPostedItem = false,
  });

  factory InvoicedItem.fromJson(Map<String, dynamic> json) {
    return InvoicedItem(
      itemId: json[itemIdKey],
      name: json[nameKey],
      comment: json[commentKey],
      netPrice: json[netPriceKey],
      qty: json[qtyKey],
      isPostedItem: json[isPostedItemKey],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      itemIdKey: itemId,
      nameKey: name,
      commentKey: comment,
      netPriceKey: netPrice,
      qtyKey: qty,
      isPostedItemKey: isPostedItem,
    };
  }

  double get netTotal => netPrice * qty;
}
