import '../utils/val.dart';

class Item {
  static const String idKey = 'id';
  static const String nameKey = 'name';
  static const String descriptionKey = 'description';
  static const String commentKey = 'comment';
  static const String priceKey = 'price';
  static const String buyingPriceKey = 'buying_price';
  static const String priceTwoKey = 'price_two';
  static const String priceThreeKey = 'price_three';
  static const String priceFourKey = 'price_four';
  static const String priceFiveKey = 'price_five';
  static const String qtyKey = 'qty';
  static const String lastInDateKey = 'lastInDate';
  static const String lastOutDateKey = 'lastOutDate';

  String id;
  String name;
  String? description;
  String? comment;
  double price;
  double buyingPrice;
  double priceTwo;
  double priceThree;
  double priceFour;
  double priceFive;
  int qty;
  DateTime? lastInDate;
  DateTime? lastOutDate;

  Item({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    this.comment,
    this.buyingPrice = 0,
    this.priceTwo = 0,
    this.priceThree = 0,
    this.priceFour = 0,
    this.priceFive = 0,
    this.qty = 0,
    this.lastInDate,
    this.lastOutDate,
  });

  Item copyWith({
    String? name,
    String? description,
    String? comment,
    double? price,
    double? priceTwo,
    double? priceThree,
    double? priceFour,
    double? priceFive,
    double? buyingPrice,
    int? qty,
    DateTime? lastInDate,
    DateTime? lastOutDate,
  }) {
    return Item(
      buyingPrice: buyingPrice ?? this.buyingPrice,
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      comment: comment ?? this.comment,
      price: price ?? this.price,
      priceTwo: priceTwo ?? this.priceTwo,
      priceThree: priceThree ?? this.priceThree,
      priceFour: priceFour ?? this.priceFour,
      priceFive: priceFive ?? this.priceFive,
      qty: qty ?? this.qty,
      lastInDate: lastInDate ?? this.lastInDate,
      lastOutDate: lastOutDate ?? this.lastOutDate,
    );
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json[idKey],
      buyingPrice: json[buyingPriceKey] ?? 0.00,
      name: json[nameKey],
      description: json[descriptionKey],
      comment: json[commentKey],
      price: json[priceKey],
      priceTwo: json[priceTwoKey],
      priceThree: json[priceThreeKey],
      priceFour: json[priceFourKey],
      priceFive: json[priceFiveKey],
      qty: json[qtyKey] ?? 0,
      lastInDate: json[lastInDateKey] != null
          ? DateTime.parse(json[lastInDateKey])
          : null,
      lastOutDate: json[lastOutDateKey] != null
          ? DateTime.parse(json[lastOutDateKey])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      idKey: id,
      nameKey: name,
      buyingPriceKey: buyingPrice,
      descriptionKey: description,
      commentKey: comment,
      priceKey: price,
      priceTwoKey: priceTwo,
      priceThreeKey: priceThree,
      priceFourKey: priceFour,
      priceFiveKey: priceFive,
      qtyKey: qty,
      lastInDateKey: lastInDate?.toIso8601String(),
      lastOutDateKey: lastOutDate?.toIso8601String(),
    };
  }

  get netBuyingStock => double.parse((buyingPrice * qty).toStringAsFixed(2));

  get gstBuyingStock =>
      double.parse((buyingPrice * Val.gstPrecentage * qty).toStringAsFixed(2));

  get totalBuyingStock => double.parse(
      (buyingPrice * Val.gstTotalPrecentage * qty).toStringAsFixed(2));

  get netStock => double.parse((price * qty).toStringAsFixed(2));

  get gstStock =>
      double.parse((price * Val.gstPrecentage * qty).toStringAsFixed(2));

  get totalStock =>
      double.parse((price * Val.gstTotalPrecentage * qty).toStringAsFixed(2));
}
