import 'package:intl/intl.dart';

class MyFormat {
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      symbol: '\$', // Currency symbol (optional)
      // Number of decimal places (optional)
    );

    return formatter.format(amount);
  }

  static String formatPrice(double amount) {
    final formatter = NumberFormat.currency(
      symbol: '', // Currency symbol (optional)
      decimalDigits: 2, // Number of decimal places (optional)
    );

    return formatter.format(amount);
  }

  static String formatDate(DateTime dateTime) {
    final format = DateFormat('dd MMM yy, HH:mm aa');
    return format.format(dateTime);
  }

  static String formatDateOne(DateTime dateTime) {
    final format = DateFormat('dd/MM/yyyy');
    return format.format(dateTime);
  }

  static String formatTime(DateTime dateTime) {
    final format = DateFormat('HH:mm aa');
    return format.format(dateTime);
  }
}
