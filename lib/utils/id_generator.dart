import 'dart:math';
import 'package:uuid/uuid.dart';

/// Secure ID generation utilities
/// Generates non-predictable IDs for security
class IDGenerator {
  static const _uuid = Uuid();

  /// Generate a UUID v4 (cryptographically random)
  /// Example: "550e8400-e29b-41d4-a716-446655440000"
  static String generateUUID() {
    return _uuid.v4();
  }

  /// Generate a short alphanumeric ID
  /// Example with prefix "CUST": "CUST-A3X9K2"
  /// Uses characters that are easy to read (no confusing 0/O, 1/I, etc.)
  static String generateShortId({String prefix = '', int length = 8}) {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // No confusing chars
    final random = Random.secure();
    final id = List.generate(
      length,
      (_) => chars[random.nextInt(chars.length)],
    ).join();

    return prefix.isEmpty ? id : '$prefix-$id';
  }

  /// Generate a human-friendly invoice ID
  /// Format: INV-YYMM-XXXX (e.g., "INV-2511-3847")
  static String generateInvoiceId() {
    final timestamp = DateTime.now();
    final year = timestamp.year.toString().substring(2);
    final month = timestamp.month.toString().padLeft(2, '0');
    final random = Random.secure();
    final randomPart = List.generate(
      4,
      (_) => random.nextInt(10),
    ).join();

    return 'INV-$year$month-$randomPart';
  }

  /// Generate a customer ID
  /// Format: CUST-XXXXXX (e.g., "CUST-A3X9K2")
  static String generateCustomerId() {
    return generateShortId(prefix: 'CUST', length: 6);
  }

  /// Generate a payment ID
  /// Format: PAY-YYMM-XXXX (e.g., "PAY-2511-8372")
  static String generatePaymentId() {
    final timestamp = DateTime.now();
    final year = timestamp.year.toString().substring(2);
    final month = timestamp.month.toString().padLeft(2, '0');
    final random = Random.secure();
    final randomPart = List.generate(
      4,
      (_) => random.nextInt(10),
    ).join();

    return 'PAY-$year$month-$randomPart';
  }

  /// Generate a quotation ID
  /// Format: QUO-YYMM-XXXX (e.g., "QUO-2511-9234")
  static String generateQuotationId() {
    final timestamp = DateTime.now();
    final year = timestamp.year.toString().substring(2);
    final month = timestamp.month.toString().padLeft(2, '0');
    final random = Random.secure();
    final randomPart = List.generate(
      4,
      (_) => random.nextInt(10),
    ).join();

    return 'QUO-$year$month-$randomPart';
  }

  /// Generate a credit note ID
  /// Format: CN-YYMM-XXXX (e.g., "CN-2511-7451")
  static String generateCreditNoteId() {
    final timestamp = DateTime.now();
    final year = timestamp.year.toString().substring(2);
    final month = timestamp.month.toString().padLeft(2, '0');
    final random = Random.secure();
    final randomPart = List.generate(
      4,
      (_) => random.nextInt(10),
    ).join();

    return 'CN-$year$month-$randomPart';
  }

  /// Generate a supplier ID
  /// Format: SUP-XXXXXX (e.g., "SUP-K9M2N7")
  static String generateSupplierId() {
    return generateShortId(prefix: 'SUP', length: 6);
  }

  /// Generate a supplier invoice ID
  /// Format: SINV-YYMM-XXXX (e.g., "SINV-2511-6283")
  static String generateSupplierInvoiceId() {
    final timestamp = DateTime.now();
    final year = timestamp.year.toString().substring(2);
    final month = timestamp.month.toString().padLeft(2, '0');
    final random = Random.secure();
    final randomPart = List.generate(
      4,
      (_) => random.nextInt(10),
    ).join();

    return 'SINV-$year$month-$randomPart';
  }

  /// Generate an item/product ID
  /// Format: ITEM-XXXXXX (e.g., "ITEM-H7P3R9")
  static String generateItemId() {
    return generateShortId(prefix: 'ITEM', length: 6);
  }

  /// Generate a numeric code (for verification, etc.)
  /// Uses cryptographically secure random
  static String generateNumericCode(int length) {
    final random = Random.secure();
    return List.generate(
      length,
      (_) => random.nextInt(10),
    ).join();
  }
}
