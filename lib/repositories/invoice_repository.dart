import 'package:drift/drift.dart';
import 'package:pos/database/pos_database.dart';
import 'package:pos/services/logger_service.dart';
import 'package:pos/utils/id_generator.dart';
import 'package:pos/utils/result.dart';

/// Repository for invoice operations using Drift database
class InvoiceRepository {
  final POSDatabase _database;

  InvoiceRepository(this._database);

  /// Get all invoices
  Future<Result<List<Invoice>>> getAllInvoices() async {
    try {
      final invoices = await _database.select(_database.invoices).get();
      return Result.success(invoices);
    } catch (e, stack) {
      AppLogger.error('Failed to get invoices', e, stack);
      return Result.failure(AppError.generic('Failed to load invoices'));
    }
  }

  /// Get invoices with customer data (JOIN)
  Future<Result<List<InvoiceWithCustomer>>> getInvoicesWithCustomers({
    DateTime? startDate,
    DateTime? endDate,
    bool? isPaid,
  }) async {
    try {
      final start = startDate ?? DateTime(2000, 1, 1);
      final end = endDate ?? DateTime.now();

      final invoices = await _database.getInvoicesWithCustomers(
        startDate: start,
        endDate: end,
        isPaid: isPaid,
      );

      return Result.success(invoices);
    } catch (e, stack) {
      AppLogger.error('Failed to get invoices with customers', e, stack);
      return Result.failure(AppError.generic('Failed to load invoices'));
    }
  }

  /// Get single invoice
  Future<Result<Invoice>> getInvoice(String invoiceId) async {
    try {
      final invoice = await (_database.select(_database.invoices)
            ..where((i) => i.invoiceId.equals(invoiceId)))
          .getSingle();

      return Result.success(invoice);
    } catch (e, stack) {
      AppLogger.error('Failed to get invoice $invoiceId', e, stack);
      return Result.failure(AppError.notFound('Invoice not found'));
    }
  }

  /// Get full invoice data (invoice + items + payments + charges)
  Future<Result<FullInvoiceData>> getFullInvoiceData(String invoiceId) async {
    try {
      final data = await _database.getFullInvoiceData(invoiceId);
      return Result.success(data);
    } catch (e, stack) {
      AppLogger.error('Failed to get full invoice data $invoiceId', e, stack);
      return Result.failure(AppError.notFound('Invoice not found'));
    }
  }

  /// Create invoice with items (atomic transaction)
  Future<Result<String>> createInvoice({
    required String customerId,
    required String customerName,
    required List<InvoiceItemData> items,
    List<ExtraChargeData>? extraCharges,
    String? customerMobile,
    String? email,
  }) async {
    try {
      final invoiceId = IDGenerator.generateInvoiceId();

      // Calculate totals
      double totalNet = 0.0;
      for (final item in items) {
        totalNet += item.netPrice * item.quantity;
      }

      if (extraCharges != null) {
        for (final charge in extraCharges) {
          totalNet += charge.amount;
        }
      }

      const gstPercentage = 0.1;
      final totalGst = totalNet * gstPercentage;
      final total = totalNet + totalGst;

      // Create invoice
      await _database.createInvoiceWithItems(
        invoice: InvoicesCompanion.insert(
          invoiceId: invoiceId,
          customerId: customerId,
          createdDate: DateTime.now(),
          totalNet: totalNet,
          totalGst: totalGst,
          total: total,
          gstPercentage: gstPercentage,
          customerName: customerName,
          customerMobile: Value(customerMobile),
          email: Value(email),
        ),
        items: items
            .map((item) => InvoiceItemsCompanion.insert(
                  invoiceId: invoiceId,
                  itemId: item.itemId,
                  itemName: item.itemName,
                  quantity: item.quantity,
                  netPrice: item.netPrice,
                  comment: Value(item.comment),
                ))
            .toList(),
        charges: extraCharges
                ?.map((charge) => ExtraChargesCompanion.insert(
                      invoiceId: invoiceId,
                      description: charge.description,
                      amount: charge.amount,
                    ))
                .toList() ??
            [],
      );

      AppLogger.info('Invoice created: $invoiceId');
      return Result.success(invoiceId);
    } catch (e, stack) {
      AppLogger.error('Failed to create invoice', e, stack);
      return Result.failure(AppError.generic('Failed to create invoice: ${e.toString()}'));
    }
  }

  /// Add payment to invoice
  Future<Result<void>> addPayment({
    required String invoiceId,
    required double amount,
    required String paymentMethod,
    String? comment,
  }) async {
    try {
      final payId = IDGenerator.generatePaymentId();

      await _database.into(_database.payments).insert(
            PaymentsCompanion.insert(
              payId: payId,
              invoiceId: invoiceId,
              amount: amount,
              date: DateTime.now(),
              paymentMethod: paymentMethod,
              comment: Value(comment),
            ),
          );

      // Update invoice paid status
      final invoice = await getInvoice(invoiceId);
      if (invoice.isSuccess) {
        final currentInvoice = invoice.data!;
        final totalPaid = await _getTotalPaid(invoiceId);

        final isPaid = totalPaid >= currentInvoice.total;

        await (_database.update(_database.invoices)
              ..where((i) => i.invoiceId.equals(invoiceId)))
            .write(
          InvoicesCompanion(
            paidAmount: Value(totalPaid),
            isPaid: Value(isPaid),
            closeDate: isPaid ? Value(DateTime.now()) : const Value.absent(),
          ),
        );
      }

      AppLogger.info('Payment added to invoice $invoiceId: \$$amount');
      return Result.success(null);
    } catch (e, stack) {
      AppLogger.error('Failed to add payment to invoice $invoiceId', e, stack);
      return Result.failure(AppError.generic('Failed to add payment'));
    }
  }

  /// Delete invoice (soft delete)
  Future<Result<void>> deleteInvoice(String invoiceId) async {
    try {
      await (_database.update(_database.invoices)
            ..where((i) => i.invoiceId.equals(invoiceId)))
          .write(const InvoicesCompanion(isDeleted: Value(true)));

      AppLogger.info('Invoice deleted: $invoiceId');
      return Result.success(null);
    } catch (e, stack) {
      AppLogger.error('Failed to delete invoice $invoiceId', e, stack);
      return Result.failure(AppError.generic('Failed to delete invoice'));
    }
  }

  /// Get sales report
  Future<Result<SalesReport>> getSalesReport({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final report = await _database.getSalesReport(
        startDate: startDate,
        endDate: endDate,
      );

      return Result.success(report);
    } catch (e, stack) {
      AppLogger.error('Failed to get sales report', e, stack);
      return Result.failure(AppError.generic('Failed to generate report'));
    }
  }

  /// Watch invoices (reactive stream)
  Stream<List<Invoice>> watchInvoices() {
    return _database.select(_database.invoices).watch();
  }

  /// Watch single invoice
  Stream<Invoice> watchInvoice(String invoiceId) {
    return (_database.select(_database.invoices)
          ..where((i) => i.invoiceId.equals(invoiceId)))
        .watchSingle();
  }

  /// Helper: Get total paid for invoice
  Future<double> _getTotalPaid(String invoiceId) async {
    final result = await (_database.selectOnly(_database.payments)
          ..addColumns([_database.payments.amount.sum()])
          ..where(_database.payments.invoiceId.equals(invoiceId)))
        .getSingle();

    return result.read(_database.payments.amount.sum()) ?? 0.0;
  }
}

// Helper data classes
class InvoiceItemData {
  final String itemId;
  final String itemName;
  final int quantity;
  final double netPrice;
  final String? comment;

  InvoiceItemData({
    required this.itemId,
    required this.itemName,
    required this.quantity,
    required this.netPrice,
    this.comment,
  });
}

class ExtraChargeData {
  final String description;
  final double amount;

  ExtraChargeData({
    required this.description,
    required this.amount,
  });
}
