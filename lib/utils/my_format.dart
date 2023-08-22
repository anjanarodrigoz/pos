import 'package:intl/intl.dart';

class MyFormat {
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      symbol: '\$', // Currency symbol (optional)
      decimalDigits: 2, // Number of decimal places (optional)
    );

    return formatter.format(amount);
  }

  static String formatDate(DateTime dateTime) {
    final format = DateFormat('MMMM d, y');
    return format.format(dateTime);
  }
}
