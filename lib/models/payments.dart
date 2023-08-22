enum Paymethod { cash, card, bankTransfer, cheque }

class Payments {
  static const String payIdKey = 'payId';
  static const String dateKey = 'date';
  static const String amountKey = 'amount';
  static const String paymethodKey = 'paymethod';

  String payId;
  DateTime date;
  double amount;
  Paymethod paymethod;

  Payments({
    required this.payId,
    required this.date,
    required this.amount,
    required this.paymethod,
  });

  factory Payments.fromJson(Map<String, dynamic> json) {
    return Payments(
      payId: json[payIdKey],
      date: DateTime.parse(json[dateKey]),
      amount: json[amountKey],
      paymethod: Paymethod.values
          .firstWhere((e) => e.toString() == 'Paymethod.${json[paymethodKey]}'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      payIdKey: payId,
      dateKey: date.toIso8601String(),
      amountKey: amount,
      paymethodKey: paymethod.toString().split('.').last,
    };
  }
}
