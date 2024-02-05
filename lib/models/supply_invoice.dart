import 'address.dart';
import 'extra_charges.dart';
import 'invoice_item.dart';

class SupplyInvoice {
  static const String invoiceIdKey = 'invoiceId';
  static const String referenceIdKey = 'referenceId';
  static const String createdDateKey = 'createdDate';
  static const String supplyerIdKey = 'supplyerId';
  static const String supplyerNameKey = 'supplyerName';
  static const String itemListKey = 'itemList';
  static const String extraChargesKey = 'extraCharges';
  static const String commentsKey = 'comments';
  static const String billingAddressKey = 'billingAddress';
  static const String gstPrecentageKey = 'gstPrecentage';
  static const String supplyerMobileKey = 'supplyerMobile';
  static const String totalKey = 'total';
  static const String netKey = 'netTotal';
  static const String gstKey = 'gstTotal';
  static const String emailKey = 'email';
  static const String isReturnNoteKey = 'isReturnNote';

  final String invoiceId;
  final DateTime createdDate;
  String supplyerId;
  String? referenceId;
  String email;
  String supplyerName;
  String supplyerMobile;
  double gstPrecentage;
  List<InvoicedItem> itemList;
  List<ExtraCharges>? extraCharges;
  List<String>? comments;
  Address? billingAddress;
  double totalNetPrice = 0.0;
  double totalItemPrice = 0.0;
  double totalExtraPrice = 0.0;
  double totalGstPrice = 0.0;
  double total = 0.0;
  bool isReturnNote;

  SupplyInvoice({
    required this.email,
    required this.supplyerMobile,
    required this.invoiceId,
    required this.createdDate,
    required this.gstPrecentage,
    required this.supplyerId,
    required this.supplyerName,
    required this.itemList,
    this.referenceId,
    this.isReturnNote = false,
    this.extraCharges,
    this.comments,
    this.billingAddress,
  }) {
    calOtherValues();
  }

  SupplyInvoice copyWith({
    String? realInvoiceId,
    String? supplyerId,
    String? supplyerName,
    String? supplyerMobile,
    double? gstPrecentage,
    bool? isReturnNote,
    List<InvoicedItem>? itemList,
    List<ExtraCharges>? extraCharges,
    DateTime? closeDate,
    List<String>? comments,
    Address? billingAddress,
    String? email,
  }) {
    return SupplyInvoice(
      isReturnNote: isReturnNote ?? this.isReturnNote,
      email: email ?? this.email,
      referenceId: realInvoiceId,
      invoiceId: invoiceId,
      createdDate: createdDate,
      supplyerId: supplyerId ?? this.supplyerId,
      supplyerName: supplyerName ?? this.supplyerName,
      supplyerMobile: supplyerMobile ?? this.supplyerMobile,
      gstPrecentage: gstPrecentage ?? this.gstPrecentage,
      itemList: itemList ?? this.itemList,
      extraCharges: extraCharges ?? this.extraCharges,
      comments: comments ?? this.comments,
      billingAddress: billingAddress ?? this.billingAddress,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      email: email,
      isReturnNoteKey: isReturnNote,
      supplyerMobileKey: supplyerMobile,
      gstPrecentageKey: gstPrecentage,
      invoiceIdKey: invoiceId,
      referenceIdKey: referenceId,
      createdDateKey: createdDate.toIso8601String(),
      supplyerIdKey: supplyerId,
      supplyerNameKey: supplyerName,
      itemListKey: itemList.map((item) => item.toJson()).toList(),
      extraChargesKey: extraCharges?.map((charge) => charge.toJson()).toList(),
      commentsKey: comments,
      billingAddressKey: billingAddress?.toJson(),
    };
  }

  factory SupplyInvoice.fromJson(Map<String, dynamic> json) {
    return SupplyInvoice(
      isReturnNote: json[isReturnNoteKey] ?? false,
      email: json[emailKey] ?? '',
      supplyerMobile: json[supplyerMobileKey],
      gstPrecentage: json[gstPrecentageKey],
      invoiceId: json[invoiceIdKey],
      referenceId: json[referenceIdKey],
      createdDate: DateTime.parse(json[createdDateKey]),
      supplyerId: json[supplyerIdKey],
      supplyerName: json[supplyerNameKey],
      itemList: (json[itemListKey] as List<dynamic>)
          .map((itemJson) => InvoicedItem.fromJson(itemJson))
          .toList(),
      extraCharges: (json[extraChargesKey] as List<dynamic>?)
          ?.map((chargeJson) => ExtraCharges.fromJson(chargeJson))
          .toList(),
      comments: json[commentsKey] != null
          ? (json[commentsKey] as List<dynamic>).cast<String>()
          : null,
      billingAddress: Address.fromJson(json[billingAddressKey]),
    );
  }

  calOtherValues() {
    for (InvoicedItem item in itemList) {
      totalItemPrice += item.netTotal;
    }

    for (ExtraCharges extra in extraCharges ?? []) {
      totalExtraPrice += extra.netTotal;
    }

    totalNetPrice = totalExtraPrice + totalItemPrice;

    totalGstPrice = (totalNetPrice * gstPrecentage * 100).round() / 100;

    total = (totalNetPrice * (1 + gstPrecentage) * 100).round() / 100;
  }
}
