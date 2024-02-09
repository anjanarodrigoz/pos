enum Paymethod { cash, card, bankTransfer, cheque, pdCheque }

class Payment {
  static const String payIdKey = 'payId';
  static const String dateKey = 'date';
  static const String amountKey = 'amount';
  static const String paymethodKey = 'paymethod';
  static const String commentKey = 'commentKey';
  static const String timeKey = 'timeKey';

  String payId;
  DateTime date;
  double amount;
  Paymethod paymethod;
  String comment;
  String? invoiceId;
  String? customerName;
  String? customerId;

  Payment({
    this.payId = '0000',
    required this.date,
    required this.amount,
    required this.paymethod,
    this.comment = '',
    this.invoiceId,
    this.customerId,
    this.customerName,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
        comment: json[commentKey] ?? '',
        payId: json[payIdKey],
        date: DateTime.parse(json[dateKey]),
        amount: json[amountKey],
        paymethod: Paymethod.values.byName(json[paymethodKey]));
  }

  Map<String, dynamic> toJson() {
    return {
      payIdKey: payId,
      dateKey: date.toIso8601String(),
      amountKey: amount,
      paymethodKey: paymethod.name,
      commentKey: comment
    };
  }

  Payment copyWith(
      {String? payId,
      DateTime? date,
      double? amount,
      Paymethod? paymethod,
      String? comment}) {
    return Payment(
      comment: comment ?? this.comment,
      payId: payId ?? this.payId,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      paymethod: paymethod ?? this.paymethod,
    );
  }
}

extension PaymethodExtension on Paymethod {
  String get displayName {
    switch (this) {
      case Paymethod.cash:
        return 'Cash';
      case Paymethod.card:
        return 'Card';
      case Paymethod.bankTransfer:
        return 'Bank Transfer';
      case Paymethod.cheque:
        return 'Cheque';
      case Paymethod.pdCheque:
        return 'PD Cheque';
      default:
        throw ArgumentError('Invalid enum value: $this');
    }
  }
}
