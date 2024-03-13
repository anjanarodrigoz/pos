class StockSoldRequired {
  final String itemId;
  String name;
  int sold;
  int required;

  StockSoldRequired(
      {required this.itemId,
      required this.name,
      required this.sold,
      required this.required});

  StockSoldRequired updateQuantity({
    int sold = 0,
    int required = 0,
  }) {
    return StockSoldRequired(
        itemId: itemId,
        name: name,
        sold: this.sold + sold,
        required: this.required + required);
  }
}
