import 'package:pos/enums/enums.dart';

class InvoiceRow {
  static const String itemIdKey = 'Item Id';
  static const String nameKey = 'Name';
  static const String qtyKey = 'Qty';
  static const String netPriceKey = 'Net Price';
  static const String gstKey = 'GST';
  static const String itemPriceKey = 'Item Price';
  static const String totalKey = 'Total';

  Map<int, String> itemId;
  Map<InvoiceItemCategory, String> itemName;
  String qty;
  String netPrice;
  String gst;
  String itemPrice;
  String total;

  InvoiceRow(
      {required this.itemId,
      required this.itemName,
      this.qty = '',
      this.netPrice = '',
      this.gst = '',
      this.itemPrice = '',
      this.total = ''});
}

class InvoiceListRow {
  static const String invoideIdKey = 'Invoice ID';
  static const String customerNameKey = 'Customer Name';
  static const String customerIdKey = 'Customer ID';
  static const String dateKey = 'Date';
  static const String customerMobileNumberKey = 'Mobile Number';
  static const String areaCodeKey = 'Area Code';
  static const String totalNetPriceKey = 'Total Net';
  static const String totalGstKey = 'Total GST';
  static const String totalKey = 'Total';
  static const String outStandingKey = 'Out Standing';

  Map<int, String> itemId;
  Map<InvoiceItemCategory, String> itemName;
  String qty;
  String netPrice;
  String gst;
  String itemPrice;
  String total;

  InvoiceListRow(
      {required this.itemId,
      required this.itemName,
      this.qty = '',
      this.netPrice = '',
      this.gst = '',
      this.itemPrice = '',
      this.total = ''});
}
