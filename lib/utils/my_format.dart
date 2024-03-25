import 'package:flutter/material.dart';
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
    final format = DateFormat('dd-MM-yyyy');
    return format.format(dateTime);
  }

  static String formatDateTwo(DateTime dateTime) {
    final format = DateFormat('yyyy/MM/dd');
    return format.format(dateTime);
  }

  static String formatTime(DateTime dateTime) {
    final format = DateFormat('HH:mm aa');
    return format.format(dateTime);
  }

  static String divideStringIntoLines(String input, {int lineLength = 45}) {
    List<String> lines = [];

    input = input.replaceAll('\n', '');

    int i = 0;

    while (input.length > lineLength) {
      lines.add(input.substring(i, i + lineLength));

      input = input.substring(lineLength);
    }

    lines.add(input);
    return lines.join('\n');
  }

  static String reportDateTimeFormat(DateTimeRange dateTimeRange) {
    DateTime start = dateTimeRange.start;
    DateTime end = dateTimeRange.end.subtract(const Duration(days: 1));

    return '${MyFormat.formatDateTwo(start)} - ${MyFormat.formatDateTwo(end)}';
  }

  static String getMonthName(int month) {
    DateTime date = DateTime(2022, month);
    return DateFormat.MMMM().format(date);
  }
}
