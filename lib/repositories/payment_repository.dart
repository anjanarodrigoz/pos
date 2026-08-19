import 'package:drift/drift.dart';
import 'package:pos/database/pos_database.dart';
import 'package:pos/services/logger_service.dart';
import 'package:pos/utils/id_generator.dart';
import 'package:pos/utils/result.dart';

/// Repository for payment operations
class PaymentRepository {
  final POSDatabase _database;

  PaymentRepository(this._database);

  /// Get all payments for an invoice
  Future<Result<List<Payment>>> getPaymentsByInvoice(String invoiceId) async {
    try {
      final payments = await (_database.select(_database.payments)
            ..where((p) => p.invoiceId.equals(invoiceId))
            ..orderBy([(p) => OrderingTerm.desc(p.date)]))
          .get();

      return Result.success(payments);
    } catch (e, stack) {
      AppLogger.error('Failed to get payments for invoice $invoiceId', e, stack);
      return Result.failure(AppError.generic('Failed to load payments'));
    }
  }

  /// Get single payment
  Future<Result<Payment>> getPayment(String paymentId) async {
    try {
      final payment = await (_database.select(_database.payments)
            ..where((p) => p.payId.equals(paymentId)))
          .getSingle();

      return Result.success(payment);
    } catch (e, stack) {
      AppLogger.error('Failed to get payment $paymentId', e, stack);
      return Result.failure(AppError.notFound('Payment not found'));
    }
  }

  /// Create payment
  Future<Result<String>> createPayment({
    required String invoiceId,
    required double amount,
    required String paymentMethod,
    String? comment,
  }) async {
    try {
      final paymentId = IDGenerator.generatePaymentId();

      final companion = PaymentsCompanion.insert(
        payId: paymentId,
        invoiceId: invoiceId,
        amount: amount,
        date: DateTime.now(),
        paymentMethod: paymentMethod,
        comment: Value(comment),
      );

      await _database.into(_database.payments).insert(companion);

      // Update invoice paid amount
      await _updateInvoicePaidAmount(invoiceId);

      AppLogger.info('Payment created: $paymentId for invoice $invoiceId');
      return Result.success(paymentId);
    } catch (e, stack) {
      AppLogger.error('Failed to create payment', e, stack);
      return Result.failure(AppError.generic('Failed to create payment'));
    }
  }

  /// Update invoice paid amount and status
  Future<void> _updateInvoicePaidAmount(String invoiceId) async {
    await _database.transaction(() async {
      // Calculate total paid
      final totalPaid = await (_database.selectOnly(_database.payments)
            ..addColumns([_database.payments.amount.sum()])
            ..where(_database.payments.invoiceId.equals(invoiceId)))
          .getSingle()
          .then((row) => row.read(_database.payments.amount.sum()) ?? 0.0);

      // Get invoice total
      final invoice = await (_database.select(_database.invoices)
            ..where((i) => i.invoiceId.equals(invoiceId)))
          .getSingle();

      // Update invoice
      final isPaid = totalPaid >= invoice.total;
      await (_database.update(_database.invoices)
            ..where((i) => i.invoiceId.equals(invoiceId)))
          .write(InvoicesCompanion(
        paidAmount: Value(totalPaid),
        isPaid: Value(isPaid),
      ));
    });
  }

  /// Delete payment
  Future<Result<void>> deletePayment(String paymentId) async {
    try {
      final payment = await getPayment(paymentId);
      if (!payment.isSuccess) {
        return Result.failure(AppError.notFound('Payment not found'));
      }

      await (_database.delete(_database.payments)
            ..where((p) => p.payId.equals(paymentId)))
          .go();

      // Update invoice paid amount
      await _updateInvoicePaidAmount(payment.data!.invoiceId);

      AppLogger.info('Payment deleted: $paymentId');
      return Result.success(null);
    } catch (e, stack) {
      AppLogger.error('Failed to delete payment $paymentId', e, stack);
      return Result.failure(AppError.generic('Failed to delete payment'));
    }
  }

  /// Get total payments in date range
  Future<Result<double>> getTotalPayments({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final total = await (_database.selectOnly(_database.payments)
            ..addColumns([_database.payments.amount.sum()])
            ..where(_database.payments.date.isBiggerOrEqualValue(startDate))
            ..where(_database.payments.date.isSmallerOrEqualValue(endDate)))
          .getSingle()
          .then((row) => row.read(_database.payments.amount.sum()) ?? 0.0);

      return Result.success(total);
    } catch (e, stack) {
      AppLogger.error('Failed to get total payments', e, stack);
      return Result.failure(AppError.generic('Failed to calculate total'));
    }
  }

  /// Watch payments for invoice (reactive)
  Stream<List<Payment>> watchPaymentsByInvoice(String invoiceId) {
    return (_database.select(_database.payments)
          ..where((p) => p.invoiceId.equals(invoiceId))
          ..orderBy([(p) => OrderingTerm.desc(p.date)]))
        .watch();
  }
}
