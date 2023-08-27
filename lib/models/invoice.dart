import 'address.dart';
import 'extra_charges.dart';
import 'invoice_item.dart';
import 'payments.dart';

class Invoice {
  static const String _invoiceIdKey = 'invoiceId';
  static const String _createdDateKey = 'createdDate';
  static const String _isPaidKey = 'isPaid';
  static const String _customerIdKey = 'customerId';
  static const String _customerNameKey = 'customerName';
  static const String _itemListKey = 'itemList';
  static const String _extraChargesKey = 'extraCharges';
  static const String _closeDateKey = 'closeDate';
  static const String _commentsKey = 'comments';
  static const String _paymentsKey = 'payments';
  static const String _isDeletedKey = 'isDeleted';
  static const String _billingAddressKey = 'billingAddress';
  static const String _shippingAddressKey = 'shippingAddress';
  static const String _gstPrecentage = 'gstPrecentage';
  static const String _customerMobile = 'customerMobile';

  final String invoiceId;
  final DateTime createdDate;
  bool isPaid;
  bool isDeleted;
  String customerId;
  String customerName;
  String customerMobile;
  double gstPrecentage;
  List<InvoicedItem> itemList;
  List<ExtraCharges>? extraCharges;
  DateTime? closeDate;
  List<String>? comments;
  List<Payments>? payments;
  Address? billingAddress;
  Address? shippingAddress;

  Invoice({
    required this.customerMobile,
    required this.invoiceId,
    required this.createdDate,
    required this.gstPrecentage,
    this.isPaid = false,
    this.isDeleted = false,
    required this.customerId,
    required this.customerName,
    required this.itemList,
    this.extraCharges,
    this.closeDate,
    this.comments,
    this.payments,
    this.billingAddress,
    this.shippingAddress,
  });

  Map<String, dynamic> toJson() {
    return {
      _customerMobile: customerMobile,
      _gstPrecentage: gstPrecentage,
      _invoiceIdKey: invoiceId,
      _createdDateKey: createdDate.toIso8601String(),
      _isPaidKey: isPaid,
      _isDeletedKey: isDeleted,
      _customerIdKey: customerId,
      _customerNameKey: customerName,
      _itemListKey: itemList.map((item) => item.toJson()).toList(),
      _extraChargesKey: extraCharges?.map((charge) => charge.toJson()).toList(),
      _closeDateKey: closeDate?.toIso8601String(),
      _commentsKey: comments,
      _paymentsKey: payments?.map((payment) => payment.toJson()).toList(),
      _billingAddressKey: billingAddress?.toJson(),
      _shippingAddressKey: shippingAddress?.toJson(),
    };
  }

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      customerMobile: json[_customerMobile],
      gstPrecentage: json[_gstPrecentage],
      invoiceId: json[_invoiceIdKey],
      createdDate: DateTime.parse(json[_createdDateKey]),
      isPaid: json[_isPaidKey],
      isDeleted: json[_isDeletedKey],
      customerId: json[_customerIdKey],
      customerName: json[_customerNameKey],
      itemList: (json[_itemListKey] as List<dynamic>)
          .map((itemJson) => InvoicedItem.fromJson(itemJson))
          .toList(),
      extraCharges: (json[_extraChargesKey] as List<dynamic>?)
          ?.map((chargeJson) => ExtraCharges.fromJson(chargeJson))
          .toList(),
      closeDate: json[_closeDateKey] != null
          ? DateTime.parse(json[_closeDateKey])
          : null,
      comments: json[_commentsKey] != null
          ? (json[_commentsKey] as List<dynamic>).cast<String>()
          : null,
      payments: (json[_paymentsKey] as List<dynamic>?)
          ?.map((paymentJson) => Payments.fromJson(paymentJson))
          .toList(),
      billingAddress: Address.fromJson(json[_billingAddressKey]),
      shippingAddress: Address.fromJson(json[_shippingAddressKey]),
    );
  }

  calculteTotalNetPrice() {
    double totalNetPrice = 0;
    double totalGstPrice = 0;
    double total = 0;
    for (InvoicedItem item in itemList) {
      totalNetPrice += item.netTotal;
    }

    for (ExtraCharges extra in extraCharges ?? []) {
      totalNetPrice += extra.netTotal;
    }

    totalGstPrice = totalNetPrice * gstPrecentage;

    total = totalNetPrice * (1 + gstPrecentage);

    return [totalNetPrice, totalGstPrice, total];
  }
}

// Define InvoicedItem, ExtraCharges, Payments, and Address classes as before
