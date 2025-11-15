import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart' show DateTimeRange;
import 'package:pos/database/pos_database.dart';
import 'package:pos/enums/enums.dart';
import 'package:pos/services/logger_service.dart';
import 'package:pos/utils/id_generator.dart';
import 'package:pos/utils/result.dart';

/// Repository for invoice operations using Drift database
/// Migrated from GetStorage to Drift database
class InvoiceRepository {
  final POSDatabase _database;

  InvoiceRepository(this._database);

  // ==================== READ OPERATIONS ====================

  /// Get all invoices with optional filters
  Future<Result<List<Invoice>>> getAllInvoices({
    bool activeOnly = true,
    bool? isPaid,
  }) async {
    try {
      var query = _database.select(_database.invoices);

      if (activeOnly) {
        query = query..where((i) => i.isDeleted.equals(false));
      }

      if (isPaid != null) {
        query = query..where((i) => i.isPaid.equals(isPaid));
      }

      query = query..orderBy([(i) => OrderingTerm.desc(i.createdDate)]);

      final invoices = await query.get();
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

  /// Search invoices by date range and payment filter
  /// Replaces: InvoiceDB.searchInvoiceByDate
  Future<Result<List<Invoice>>> searchInvoiceByDate(
    DateTimeRange dateTimeRange,
    ReportPaymentFilter paidStatus, {
    bool getAllUnpaidInvoice = false,
  }) async {
    try {
      var query = _database.select(_database.invoices)
        ..where((i) => i.isDeleted.equals(false));

      // Get all unpaid invoices (ignore date filter)
      if (getAllUnpaidInvoice) {
        query = query..where((i) => i.isPaid.equals(false));
        final invoices = await query.get();
        return Result.success(invoices);
      }

      // Apply date filter
      query = query
        ..where((i) => i.createdDate.isBiggerOrEqualValue(dateTimeRange.start))
        ..where((i) => i.createdDate.isSmallerOrEqualValue(dateTimeRange.end));

      // Apply payment filter
      if (paidStatus != ReportPaymentFilter.all) {
        bool isPaid = paidStatus == ReportPaymentFilter.paid;
        query = query..where((i) => i.isPaid.equals(isPaid));
      }

      query = query..orderBy([(i) => OrderingTerm.desc(i.createdDate)]);

      final invoices = await query.get();
      return Result.success(invoices);
    } catch (e, stack) {
      AppLogger.error('Failed to search invoices by date', e, stack);
      return Result.failure(AppError.generic('Failed to search invoices'));
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

  /// Get invoice items for a specific invoice
  Future<Result<List<InvoiceItem>>> getInvoiceItems(String invoiceId) async {
    try {
      final items = await (_database.select(_database.invoiceItems)
            ..where((ii) => ii.invoiceId.equals(invoiceId)))
          .get();

      return Result.success(items);
    } catch (e, stack) {
      AppLogger.error('Failed to get invoice items for $invoiceId', e, stack);
      return Result.failure(AppError.generic('Failed to load invoice items'));
    }
  }

  /// Get payments for a specific invoice
  Future<Result<List<Payment>>> getInvoicePayments(String invoiceId) async {
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

  /// Get extra charges for a specific invoice
  Future<Result<List<ExtraCharge>>> getInvoiceExtraCharges(String invoiceId) async {
    try {
      final charges = await (_database.select(_database.extraCharges)
            ..where((ec) => ec.invoiceId.equals(invoiceId)))
          .get();

      return Result.success(charges);
    } catch (e, stack) {
      AppLogger.error('Failed to get extra charges for invoice $invoiceId', e, stack);
      return Result.failure(AppError.generic('Failed to load extra charges'));
    }
  }

  /// Search invoices by invoice ID or customer name
  Future<Result<List<Invoice>>> searchInvoices(String query) async {
    try {
      final invoices = await (_database.select(_database.invoices)
            ..where((i) =>
                i.invoiceId.like('%$query%') |
                i.customerName.like('%$query%'))
            ..where((i) => i.isDeleted.equals(false))
            ..orderBy([(i) => OrderingTerm.desc(i.createdDate)]))
          .get();

      return Result.success(invoices);
    } catch (e, stack) {
      AppLogger.error('Failed to search invoices', e, stack);
      return Result.failure(AppError.generic('Failed to search invoices'));
    }
  }

  /// Get invoices for a specific customer
  Future<Result<List<Invoice>>> getCustomerInvoices(String customerId) async {
    try {
      final invoices = await (_database.select(_database.invoices)
            ..where((i) => i.customerId.equals(customerId))
            ..where((i) => i.isDeleted.equals(false))
            ..orderBy([(i) => OrderingTerm.desc(i.createdDate)]))
          .get();

      return Result.success(invoices);
    } catch (e, stack) {
      AppLogger.error('Failed to get invoices for customer $customerId', e, stack);
      return Result.failure(AppError.generic('Failed to load customer invoices'));
    }
  }

  // ==================== CREATE OPERATIONS ====================

  /// Create invoice with items and extra charges (atomic transaction)
  /// Replaces: InvoiceDB.addInvoice
  Future<Result<String>> createInvoice({
    String? invoiceId,
    required String customerId,
    required String customerName,
    required List<InvoiceItemData> items,
    List<ExtraChargeData>? extraCharges,
    String? customerMobile,
    String? email,
    double? gstPercentage,
    Map<String, dynamic>? billingAddress,
    Map<String, dynamic>? shippingAddress,
    List<String>? comments,
  }) async {
    try {
      final finalInvoiceId = invoiceId ?? IDGenerator.generateInvoiceId();

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

      final gst = gstPercentage ?? 0.1; // Default 10% GST
      final totalGst = (totalNet * gst * 100).round() / 100;
      final total = ((totalNet + totalGst) * 100).round() / 100;

      // Create invoice
      await _database.createInvoiceWithItems(
        invoice: InvoicesCompanion.insert(
          invoiceId: finalInvoiceId,
          customerId: customerId,
          createdDate: DateTime.now(),
          totalNet: totalNet,
          totalGst: totalGst,
          total: total,
          gstPercentage: gst,
          customerName: customerName,
          customerMobile: Value(customerMobile),
          email: Value(email),
          billingAddressJson: Value(billingAddress != null ? jsonEncode(billingAddress) : null),
          shippingAddressJson: Value(shippingAddress != null ? jsonEncode(shippingAddress) : null),
          commentsJson: Value(comments != null ? jsonEncode(comments) : null),
        ),
        items: items
            .map((item) => InvoiceItemsCompanion.insert(
                  invoiceId: finalInvoiceId,
                  itemId: item.itemId,
                  itemName: item.itemName,
                  quantity: item.quantity,
                  netPrice: item.netPrice,
                  comment: Value(item.comment),
                  isPostedItem: Value(item.isPostedItem ?? false),
                ))
            .toList(),
        charges: extraCharges
                ?.map((charge) => ExtraChargesCompanion.insert(
                      invoiceId: finalInvoiceId,
                      description: charge.description,
                      amount: charge.amount,
                    ))
                .toList() ??
            [],
      );

      AppLogger.info('Invoice created: $finalInvoiceId for customer $customerId');
      return Result.success(finalInvoiceId);
    } catch (e, stack) {
      AppLogger.error('Failed to create invoice', e, stack);
      return Result.failure(AppError.generic('Failed to create invoice: ${e.toString()}'));
    }
  }

  // ==================== UPDATE OPERATIONS ====================

  /// Update invoice details
  /// Replaces: InvoiceDB.updateInvoice
  Future<Result<Invoice>> updateInvoice({
    required String invoiceId,
    String? customerName,
    String? customerMobile,
    String? email,
    bool? isPaid,
    DateTime? closeDate,
    Map<String, dynamic>? billingAddress,
    Map<String, dynamic>? shippingAddress,
    List<String>? comments,
  }) async {
    try {
      await (_database.update(_database.invoices)
            ..where((i) => i.invoiceId.equals(invoiceId)))
          .write(InvoicesCompanion(
            customerName: customerName != null ? Value(customerName) : const Value.absent(),
            customerMobile: customerMobile != null ? Value(customerMobile) : const Value.absent(),
            email: email != null ? Value(email) : const Value.absent(),
            isPaid: isPaid != null ? Value(isPaid) : const Value.absent(),
            closeDate: closeDate != null ? Value(closeDate) : const Value.absent(),
            billingAddressJson: billingAddress != null
                ? Value(jsonEncode(billingAddress))
                : const Value.absent(),
            shippingAddressJson: shippingAddress != null
                ? Value(jsonEncode(shippingAddress))
                : const Value.absent(),
            commentsJson: comments != null
                ? Value(jsonEncode(comments))
                : const Value.absent(),
          ));

      AppLogger.info('Invoice updated: $invoiceId');
      return await getInvoice(invoiceId);
    } catch (e, stack) {
      AppLogger.error('Failed to update invoice $invoiceId', e, stack);
      return Result.failure(AppError.generic('Failed to update invoice'));
    }
  }

  /// Add comment to invoice
  Future<Result<void>> addComment(String invoiceId, String comment) async {
    try {
      final invoiceResult = await getInvoice(invoiceId);
      if (!invoiceResult.isSuccess) {
        return Result.failure(AppError.notFound('Invoice not found'));
      }

      final invoice = invoiceResult.data!;
      List<String> comments = [];

      if (invoice.commentsJson != null) {
        comments = List<String>.from(jsonDecode(invoice.commentsJson!));
      }

      comments.add(comment);

      await (_database.update(_database.invoices)
            ..where((i) => i.invoiceId.equals(invoiceId)))
          .write(InvoicesCompanion(
            commentsJson: Value(jsonEncode(comments)),
          ));

      AppLogger.info('Comment added to invoice $invoiceId');
      return Result.success(null);
    } catch (e, stack) {
      AppLogger.error('Failed to add comment to invoice $invoiceId', e, stack);
      return Result.failure(AppError.generic('Failed to add comment'));
    }
  }

  // ==================== PAYMENT OPERATIONS ====================

  /// Add payment to invoice
  /// Replaces: InvoiceDB.addInvoicePayment
  Future<Result<String>> addPayment({
    required String invoiceId,
    required double amount,
    required String paymentMethod,
    String? comment,
    DateTime? date,
  }) async {
    try {
      final payId = IDGenerator.generatePaymentId();

      await _database.into(_database.payments).insert(
            PaymentsCompanion.insert(
              payId: payId,
              invoiceId: invoiceId,
              amount: amount,
              date: date ?? DateTime.now(),
              paymentMethod: paymentMethod,
              comment: Value(comment),
            ),
          );

      // Update invoice paid status and paid amount
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

      AppLogger.info('Payment $payId added to invoice $invoiceId: \$$amount');
      return Result.success(payId);
    } catch (e, stack) {
      AppLogger.error('Failed to add payment to invoice $invoiceId', e, stack);
      return Result.failure(AppError.generic('Failed to add payment'));
    }
  }

  /// Remove payment from invoice
  /// Replaces: InvoiceDB.removeInvoicePayment
  Future<Result<void>> removePayment(String invoiceId, String paymentId) async {
    try {
      // Delete the payment
      await (_database.delete(_database.payments)
            ..where((p) => p.payId.equals(paymentId)))
          .go();

      // Recalculate paid status
      final totalPaid = await _getTotalPaid(invoiceId);
      final invoice = await getInvoice(invoiceId);

      if (invoice.isSuccess) {
        final currentInvoice = invoice.data!;
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

      AppLogger.info('Payment $paymentId removed from invoice $invoiceId');
      return Result.success(null);
    } catch (e, stack) {
      AppLogger.error('Failed to remove payment $paymentId from invoice $invoiceId', e, stack);
      return Result.failure(AppError.generic('Failed to remove payment'));
    }
  }

  // ==================== DELETE OPERATIONS ====================

  /// Delete invoice (soft delete) and return items to stock
  /// Replaces: InvoiceDB.deleteInvoice
  Future<Result<void>> deleteInvoice(String invoiceId) async {
    try {
      // Get invoice items to return to stock
      final itemsResult = await getInvoiceItems(invoiceId);

      if (itemsResult.isSuccess) {
        // Return items to stock
        for (final invoiceItem in itemsResult.data!) {
          await _returnItemToStock(invoiceItem.itemId, invoiceItem.quantity);
        }
      }

      // Soft delete: mark as deleted and clear data
      await (_database.update(_database.invoices)
            ..where((i) => i.invoiceId.equals(invoiceId)))
          .write(InvoicesCompanion(
            isDeleted: const Value(true),
            commentsJson: Value(jsonEncode(['This invoice has been deleted'])),
          ));

      // Delete related items, payments, and charges (cascade will handle this)
      // But we'll do it explicitly for clarity
      await (_database.delete(_database.invoiceItems)
            ..where((ii) => ii.invoiceId.equals(invoiceId)))
          .go();

      await (_database.delete(_database.payments)
            ..where((p) => p.invoiceId.equals(invoiceId)))
          .go();

      await (_database.delete(_database.extraCharges)
            ..where((ec) => ec.invoiceId.equals(invoiceId)))
          .go();

      AppLogger.info('Invoice deleted (soft): $invoiceId');
      return Result.success(null);
    } catch (e, stack) {
      AppLogger.error('Failed to delete invoice $invoiceId', e, stack);
      return Result.failure(AppError.generic('Failed to delete invoice'));
    }
  }

  /// Return item to stock when invoice is deleted
  Future<void> _returnItemToStock(String itemId, int quantity) async {
    try {
      final item = await (_database.select(_database.items)
            ..where((i) => i.id.equals(itemId)))
          .getSingle();

      final newQuantity = item.quantity + quantity;

      await (_database.update(_database.items)
            ..where((i) => i.id.equals(itemId)))
          .write(ItemsCompanion(
            quantity: Value(newQuantity),
            updatedAt: Value(DateTime.now()),
          ));

      AppLogger.info('Returned item $itemId to stock: ${item.quantity} -> $newQuantity');
    } catch (e, stack) {
      AppLogger.error('Failed to return item $itemId to stock', e, stack);
    }
  }

  // ==================== REPORTING & ANALYTICS ====================

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

  /// Get invoice statistics
  Future<Result<InvoiceStats>> getStats() async {
    try {
      // Total invoices
      final totalInvoices = await (_database.selectOnly(_database.invoices)
            ..addColumns([_database.invoices.invoiceId.count()])
            ..where(_database.invoices.isDeleted.equals(false)))
          .getSingle()
          .then((row) => row.read(_database.invoices.invoiceId.count()) ?? 0);

      // Total amount
      final totalAmount = await (_database.selectOnly(_database.invoices)
            ..addColumns([_database.invoices.total.sum()])
            ..where(_database.invoices.isDeleted.equals(false)))
          .getSingle()
          .then((row) => row.read(_database.invoices.total.sum()) ?? 0.0);

      // Unpaid amount
      final unpaidAmount = await (_database.selectOnly(_database.invoices)
            ..addColumns([_database.invoices.total.sum()])
            ..where(_database.invoices.isPaid.equals(false))
            ..where(_database.invoices.isDeleted.equals(false)))
          .getSingle()
          .then((row) => row.read(_database.invoices.total.sum()) ?? 0.0);

      // Outstanding invoices (to pay)
      final outstanding = await (_database.selectOnly(_database.invoices)
            ..addColumns([
              (_database.invoices.total - _database.invoices.paidAmount).sum()
            ])
            ..where(_database.invoices.isDeleted.equals(false)))
          .getSingle()
          .then((row) => row.read(
              (_database.invoices.total - _database.invoices.paidAmount).sum()) ?? 0.0);

      return Result.success(InvoiceStats(
        totalInvoices: totalInvoices,
        totalAmount: totalAmount,
        unpaidAmount: unpaidAmount,
        outstandingAmount: outstanding,
      ));
    } catch (e, stack) {
      AppLogger.error('Failed to get invoice stats', e, stack);
      return Result.failure(AppError.generic('Failed to get stats'));
    }
  }

  // ==================== REACTIVE STREAMS ====================

  /// Watch invoices (reactive stream)
  /// Replaces: InvoiceDB.getStreamInvoice
  Stream<List<Invoice>> watchInvoices({bool activeOnly = true}) {
    var query = _database.select(_database.invoices);

    if (activeOnly) {
      query = query..where((i) => i.isDeleted.equals(false));
    }

    return (query..orderBy([(i) => OrderingTerm.desc(i.createdDate)])).watch();
  }

  /// Watch single invoice
  Stream<Invoice> watchInvoice(String invoiceId) {
    return (_database.select(_database.invoices)
          ..where((i) => i.invoiceId.equals(invoiceId)))
        .watchSingle();
  }

  /// Watch invoice items for a specific invoice
  Stream<List<InvoiceItem>> watchInvoiceItems(String invoiceId) {
    return (_database.select(_database.invoiceItems)
          ..where((ii) => ii.invoiceId.equals(invoiceId)))
        .watch();
  }

  /// Watch payments for a specific invoice
  Stream<List<Payment>> watchInvoicePayments(String invoiceId) {
    return (_database.select(_database.payments)
          ..where((p) => p.invoiceId.equals(invoiceId))
          ..orderBy([(p) => OrderingTerm.desc(p.date)]))
        .watch();
  }

  // ==================== HELPER METHODS ====================

  /// Get total paid for invoice
  Future<double> _getTotalPaid(String invoiceId) async {
    final result = await (_database.selectOnly(_database.payments)
          ..addColumns([_database.payments.amount.sum()])
          ..where(_database.payments.invoiceId.equals(invoiceId)))
        .getSingle();

    return result.read(_database.payments.amount.sum()) ?? 0.0;
  }
}

// ==================== HELPER DATA CLASSES ====================

/// Helper class for invoice item data during creation
class InvoiceItemData {
  final String itemId;
  final String itemName;
  final int quantity;
  final double netPrice;
  final String? comment;
  final bool? isPostedItem;

  InvoiceItemData({
    required this.itemId,
    required this.itemName,
    required this.quantity,
    required this.netPrice,
    this.comment,
    this.isPostedItem,
  });
}

/// Helper class for extra charge data during creation
class ExtraChargeData {
  final String description;
  final double amount;

  ExtraChargeData({
    required this.description,
    required this.amount,
  });
}

/// Invoice statistics
class InvoiceStats {
  final int totalInvoices;
  final double totalAmount;
  final double unpaidAmount;
  final double outstandingAmount;

  InvoiceStats({
    required this.totalInvoices,
    required this.totalAmount,
    required this.unpaidAmount,
    required this.outstandingAmount,
  });

  double get paidAmount => totalAmount - unpaidAmount;
}
