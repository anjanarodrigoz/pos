import 'address.dart';
import 'extra_charges.dart';
import 'invoice_item.dart';
import 'payment.dart';
import 'supply_invoice.dart';

class Invoice {
  static const String invoiceIdKey = 'invoiceId';
  static const String createdDateKey = 'createdDate';
  static const String isPaidKey = 'isPaid';
  static const String customerIdKey = 'customerId';
  static const String customerNameKey = 'customerName';
  static const String itemListKey = 'itemList';
  static const String extraChargesKey = 'extraCharges';
  static const String closeDateKey = 'closeDate';
  static const String commentsKey = 'comments';
  static const String paymentsKey = 'payments';
  static const String isDeletedKey = 'isDeleted';
  static const String billingAddressKey = 'billingAddress';
  static const String shippingAddressKey = 'shippingAddress';
  static const String gstPrecentageKey = 'gstPrecentage';
  static const String customerMobileKey = 'customerMobile';
  static const String totalKey = 'total';
  static const String netKey = 'netTotal';
  static const String gstKey = 'gstTotal';
  static const String paykey = 'toPay';

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
  List<Payment>? payments;
  Address? billingAddress;
  Address? shippingAddress;
  double totalNetPrice = 0.0;
  double totalItemPrice = 0.0;
  double totalExtraPrice = 0.0;
  double totalGstPrice = 0.0;
  double total = 0.0;
  double toPay = 0.0;
  double paidAmount = 0.0;
  Duration outStandingDates = const Duration(days: 0);

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
  }) {
    calOtherValues();
  }

  Invoice copyWith({
    bool? isPaid,
    bool? isDeleted,
    String? customerId,
    String? customerName,
    String? customerMobile,
    double? gstPrecentage,
    List<InvoicedItem>? itemList,
    List<ExtraCharges>? extraCharges,
    DateTime? closeDate,
    List<String>? comments,
    List<Payment>? payments,
    Address? billingAddress,
    Address? shippingAddress,
  }) {
    return Invoice(
      invoiceId: invoiceId,
      createdDate: createdDate,
      isPaid: isPaid ?? this.isPaid,
      isDeleted: isDeleted ?? this.isDeleted,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerMobile: customerMobile ?? this.customerMobile,
      gstPrecentage: gstPrecentage ?? this.gstPrecentage,
      itemList: itemList ?? this.itemList,
      extraCharges: extraCharges ?? this.extraCharges,
      closeDate: closeDate ?? this.closeDate,
      comments: comments ?? this.comments,
      payments: payments ?? this.payments,
      billingAddress: billingAddress ?? this.billingAddress,
      shippingAddress: shippingAddress ?? this.shippingAddress,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      customerMobileKey: customerMobile,
      gstPrecentageKey: gstPrecentage,
      invoiceIdKey: invoiceId,
      createdDateKey: createdDate.toIso8601String(),
      isPaidKey: isPaid,
      isDeletedKey: isDeleted,
      customerIdKey: customerId,
      customerNameKey: customerName,
      itemListKey: itemList.map((item) => item.toJson()).toList(),
      extraChargesKey: extraCharges?.map((charge) => charge.toJson()).toList(),
      closeDateKey: closeDate?.toIso8601String(),
      commentsKey: comments,
      paymentsKey: payments?.map((payment) => payment.toJson()).toList(),
      billingAddressKey: billingAddress?.toJson(),
      shippingAddressKey: shippingAddress?.toJson(),
    };
  }

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      customerMobile: json[customerMobileKey],
      gstPrecentage: json[gstPrecentageKey],
      invoiceId: json[invoiceIdKey],
      createdDate: DateTime.parse(json[createdDateKey]),
      isPaid: json[isPaidKey],
      isDeleted: json[isDeletedKey],
      customerId: json[customerIdKey],
      customerName: json[customerNameKey],
      itemList: (json[itemListKey] as List<dynamic>)
          .map((itemJson) => InvoicedItem.fromJson(itemJson))
          .toList(),
      extraCharges: (json[extraChargesKey] as List<dynamic>?)
          ?.map((chargeJson) => ExtraCharges.fromJson(chargeJson))
          .toList(),
      closeDate: json[closeDateKey] != null
          ? DateTime.parse(json[closeDateKey])
          : null,
      comments: json[commentsKey] != null
          ? (json[commentsKey] as List<dynamic>).cast<String>()
          : null,
      payments: (json[paymentsKey] as List<dynamic>?)
          ?.map((paymentJson) => Payment.fromJson(paymentJson))
          .toList(),
      billingAddress: Address.fromJson(json[billingAddressKey]),
      shippingAddress: Address.fromJson(json[shippingAddressKey]),
    );
  }

  calOtherValues() {
    for (InvoicedItem item in itemList) {
      totalItemPrice += item.netTotal;
    }

    for (ExtraCharges extra in extraCharges ?? []) {
      totalExtraPrice += extra.netTotal;
    }

    for (Payment payment in payments ?? []) {
      paidAmount += payment.amount;
    }

    totalNetPrice = totalExtraPrice + totalItemPrice;

    totalGstPrice = (totalNetPrice * gstPrecentage * 100).round() / 100;

    total = (totalNetPrice * (1 + gstPrecentage) * 100).round() / 100;

    toPay = total - paidAmount;

    outStandingDates = DateTime.now().difference(createdDate);
  }
}
