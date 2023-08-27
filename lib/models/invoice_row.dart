import 'package:pos/enums/enums.dart';

class InvoiceRow {
  static const String itemIdKey = 'Item Id';
  static const String nameKey = 'Name';
  static const String qtyKey = 'Qty';
  static const String netPriceKey = 'Net Price';
  static const String gstKey = 'GST';
  static const String itemPriceKey = 'Item Price';
  static const String totalKey = 'Total';

  String itemId;
  Map<InvoiceItemCategory, String> itemName;
  String qty;
  String netPrice;
  String gst;
  String itemPrice;
  String total;

  InvoiceRow(
      {this.itemId = '',
      required this.itemName,
      this.qty = '',
      this.netPrice = '',
      this.gst = '',
      this.itemPrice = '',
      this.total = ''});
}
