import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:pos/database/pos_database.dart';
import 'package:pos/services/logger_service.dart';
import 'package:pos/utils/result.dart';

/// Repository for supplier invoice operations
class SupplierInvoiceRepository {
  final POSDatabase _database;

  SupplierInvoiceRepository(this._database);

  /// Get all supplier invoices with optional filters
  Future<Result<List<SupplierInvoice>>> getAllInvoices({
    bool activeOnly = true,
    bool? isPaid,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      var query = _database.select(_database.supplierInvoices);

      if (activeOnly) {
        query = query..where((si) => si.isDeleted.equals(false));
      }

      if (isPaid != null) {
        query = query..where((si) => si.isPaid.equals(isPaid));
      }

      if (startDate != null) {
        query = query..where((si) => si.createdDate.isBiggerOrEqualValue(startDate));
      }

      if (endDate != null) {
        query = query..where((si) => si.createdDate.isSmallerOrEqualValue(endDate));
      }

      query = query..orderBy([(si) => OrderingTerm.desc(si.createdDate)]);

      final invoices = await query.get();
      return Result.success(invoices);
    } catch (e, stack) {
      AppLogger.error('Failed to get supplier invoices', e, stack);
      return Result.failure(AppError.generic('Failed to load supplier invoices'));
    }
  }

  /// Get single supplier invoice
  Future<Result<SupplierInvoice>> getInvoice(String invoiceId) async {
    try {
      final invoice = await (_database.select(_database.supplierInvoices)
            ..where((si) => si.invoiceId.equals(invoiceId)))
          .getSingle();

      return Result.success(invoice);
    } catch (e, stack) {
      AppLogger.error('Failed to get supplier invoice $invoiceId', e, stack);
      return Result.failure(AppError.notFound('Supplier invoice not found'));
    }
  }

  /// Get invoice items for a specific invoice
  Future<Result<List<SupplierInvoiceItem>>> getInvoiceItems(String invoiceId) async {
    try {
      final items = await (_database.select(_database.supplierInvoiceItems)
            ..where((sii) => sii.invoiceId.equals(invoiceId)))
          .get();

      return Result.success(items);
    } catch (e, stack) {
      AppLogger.error('Failed to get supplier invoice items for $invoiceId', e, stack);
      return Result.failure(AppError.generic('Failed to load invoice items'));
    }
  }

  /// Search supplier invoices by supplier name or invoice ID
  Future<Result<List<SupplierInvoice>>> searchInvoices(String query) async {
    try {
      final invoices = await (_database.select(_database.supplierInvoices)
            ..where((si) =>
                si.supplierName.like('%$query%') |
                si.invoiceId.like('%$query%')))
          .get();

      return Result.success(invoices);
    } catch (e, stack) {
      AppLogger.error('Failed to search supplier invoices', e, stack);
      return Result.failure(AppError.generic('Failed to search supplier invoices'));
    }
  }

  /// Get invoices for a specific supplier
  Future<Result<List<SupplierInvoice>>> getSupplierInvoices(String supplierId) async {
    try {
      final invoices = await (_database.select(_database.supplierInvoices)
            ..where((si) => si.supplierId.equals(supplierId))
            ..where((si) => si.isDeleted.equals(false))
            ..orderBy([(si) => OrderingTerm.desc(si.createdDate)]))
          .get();

      return Result.success(invoices);
    } catch (e, stack) {
      AppLogger.error('Failed to get invoices for supplier $supplierId', e, stack);
      return Result.failure(AppError.generic('Failed to load supplier invoices'));
    }
  }

  /// Create supplier invoice with items
  Future<Result<SupplierInvoice>> createInvoice({
    required String supplierId,
    required String supplierName,
    required List<InvoiceItemData> items,
    required double gstPercentage,
    String? supplierMobile,
    String? supplierEmail,
    String? referenceId,
    List<ExtraChargeData>? extraCharges,
    List<String>? comments,
    Map<String, dynamic>? billingAddress,
    bool isReturnNote = false,
  }) async {
    try {
      // Generate auto-incremental invoice ID
      final count = await (_database.selectOnly(_database.supplierInvoices)
            ..addColumns([_database.supplierInvoices.invoiceId.count()]))
          .getSingle()
          .then((row) => row.read(_database.supplierInvoices.invoiceId.count()) ?? 0);

      final invoiceId = 'SINV-${(count + 1).toString().padLeft(4, '0')}';

      // Calculate totals
      double totalNet = 0.0;
      for (var item in items) {
        totalNet += item.quantity * item.buyingPrice;
      }

      // Add extra charges to net total
      if (extraCharges != null) {
        for (var charge in extraCharges) {
          totalNet += charge.amount;
        }
      }

      final totalGst = (totalNet * gstPercentage * 100).round() / 100;
      final total = ((totalNet + totalGst) * 100).round() / 100;

      // Create invoice
      final companion = SupplierInvoicesCompanion.insert(
        invoiceId: invoiceId,
        supplierId: supplierId,
        createdDate: DateTime.now(),
        totalNet: totalNet,
        totalGst: totalGst,
        total: total,
        gstPercentage: gstPercentage,
        supplierName: supplierName,
        supplierMobile: Value(supplierMobile),
        supplierEmail: Value(supplierEmail),
        referenceId: Value(referenceId),
        extraChargesJson: Value(extraCharges != null ? jsonEncode(extraCharges.map((e) => e.toJson()).toList()) : null),
        commentsJson: Value(comments != null ? jsonEncode(comments) : null),
        billingAddressJson: Value(billingAddress != null ? jsonEncode(billingAddress) : null),
        isReturnNote: Value(isReturnNote),
      );

      await _database.into(_database.supplierInvoices).insert(companion);

      // Insert invoice items and update item quantities
      for (var item in items) {
        final itemCompanion = SupplierInvoiceItemsCompanion.insert(
          invoiceId: invoiceId,
          itemId: item.itemId,
          itemName: item.itemName,
          quantity: item.quantity,
          buyingPrice: item.buyingPrice,
          netPrice: item.quantity * item.buyingPrice,
          comment: Value(item.comment),
        );

        await _database.into(_database.supplierInvoiceItems).insert(itemCompanion);

        // Update item quantity (add to existing quantity)
        await _updateItemQuantity(item.itemId, item.quantity, isReturnNote);
      }

      AppLogger.info('Supplier invoice created: $invoiceId for supplier $supplierId');
      return await getInvoice(invoiceId);
    } catch (e, stack) {
      AppLogger.error('Failed to create supplier invoice', e, stack);
      return Result.failure(AppError.generic('Failed to create supplier invoice'));
    }
  }

  /// Update item quantity when adding supplier invoice
  Future<void> _updateItemQuantity(String itemId, int quantity, bool isReturnNote) async {
    final item = await (_database.select(_database.items)
          ..where((i) => i.id.equals(itemId)))
        .getSingle();

    int newQuantity;
    if (isReturnNote) {
      // Return note decreases quantity
      newQuantity = item.quantity - quantity;
    } else {
      // Normal invoice increases quantity
      newQuantity = item.quantity + quantity;
    }

    await (_database.update(_database.items)
          ..where((i) => i.id.equals(itemId)))
        .write(ItemsCompanion(
          quantity: Value(newQuantity),
          updatedAt: Value(DateTime.now()),
        ));

    AppLogger.info('Updated item $itemId quantity: ${item.quantity} -> $newQuantity');
  }

  /// Update supplier invoice
  Future<Result<SupplierInvoice>> updateInvoice(SupplierInvoice invoice) async {
    try {
      await (_database.update(_database.supplierInvoices)
            ..where((si) => si.invoiceId.equals(invoice.invoiceId)))
          .write(SupplierInvoicesCompanion(
            supplierName: Value(invoice.supplierName),
            supplierMobile: Value(invoice.supplierMobile),
            supplierEmail: Value(invoice.supplierEmail),
            isPaid: Value(invoice.isPaid),
            referenceId: Value(invoice.referenceId),
            extraChargesJson: Value(invoice.extraChargesJson),
            commentsJson: Value(invoice.commentsJson),
            billingAddressJson: Value(invoice.billingAddressJson),
            updatedAt: Value(DateTime.now()),
          ));

      AppLogger.info('Supplier invoice updated: ${invoice.invoiceId}');
      return await getInvoice(invoice.invoiceId);
    } catch (e, stack) {
      AppLogger.error('Failed to update supplier invoice ${invoice.invoiceId}', e, stack);
      return Result.failure(AppError.generic('Failed to update supplier invoice'));
    }
  }

  /// Mark invoice as paid
  Future<Result<SupplierInvoice>> markAsPaid(String invoiceId, bool isPaid) async {
    try {
      await (_database.update(_database.supplierInvoices)
            ..where((si) => si.invoiceId.equals(invoiceId)))
          .write(SupplierInvoicesCompanion(
            isPaid: Value(isPaid),
            updatedAt: Value(DateTime.now()),
          ));

      AppLogger.info('Supplier invoice $invoiceId marked as paid: $isPaid');
      return await getInvoice(invoiceId);
    } catch (e, stack) {
      AppLogger.error('Failed to mark supplier invoice as paid $invoiceId', e, stack);
      return Result.failure(AppError.generic('Failed to update payment status'));
    }
  }

  /// Delete supplier invoice (soft delete)
  Future<Result<void>> deleteInvoice(String invoiceId) async {
    try {
      await (_database.update(_database.supplierInvoices)
            ..where((si) => si.invoiceId.equals(invoiceId)))
          .write(SupplierInvoicesCompanion(
            isDeleted: const Value(true),
            updatedAt: Value(DateTime.now()),
          ));

      AppLogger.info('Supplier invoice deleted (soft): $invoiceId');
      return Result.success(null);
    } catch (e, stack) {
      AppLogger.error('Failed to delete supplier invoice $invoiceId', e, stack);
      return Result.failure(AppError.generic('Failed to delete supplier invoice'));
    }
  }

  /// Watch all supplier invoices (reactive)
  Stream<List<SupplierInvoice>> watchAllInvoices({bool activeOnly = true}) {
    var query = _database.select(_database.supplierInvoices);

    if (activeOnly) {
      query = query..where((si) => si.isDeleted.equals(false));
    }

    return (query..orderBy([(si) => OrderingTerm.desc(si.createdDate)])).watch();
  }

  /// Watch single supplier invoice
  Stream<SupplierInvoice> watchInvoice(String invoiceId) {
    return (_database.select(_database.supplierInvoices)
          ..where((si) => si.invoiceId.equals(invoiceId)))
        .watchSingle();
  }

  /// Watch invoice items for a specific invoice
  Stream<List<SupplierInvoiceItem>> watchInvoiceItems(String invoiceId) {
    return (_database.select(_database.supplierInvoiceItems)
          ..where((sii) => sii.invoiceId.equals(invoiceId)))
        .watch();
  }

  /// Get supplier invoice statistics
  Future<Result<SupplierInvoiceStats>> getStats() async {
    try {
      // Total invoices
      final totalInvoices = await (_database.selectOnly(_database.supplierInvoices)
            ..addColumns([_database.supplierInvoices.invoiceId.count()])
            ..where(_database.supplierInvoices.isDeleted.equals(false)))
          .getSingle()
          .then((row) => row.read(_database.supplierInvoices.invoiceId.count()) ?? 0);

      // Total amount
      final totalAmount = await (_database.selectOnly(_database.supplierInvoices)
            ..addColumns([_database.supplierInvoices.total.sum()])
            ..where(_database.supplierInvoices.isDeleted.equals(false)))
          .getSingle()
          .then((row) => row.read(_database.supplierInvoices.total.sum()) ?? 0.0);

      // Unpaid amount
      final unpaidAmount = await (_database.selectOnly(_database.supplierInvoices)
            ..addColumns([_database.supplierInvoices.total.sum()])
            ..where(_database.supplierInvoices.isPaid.equals(false))
            ..where(_database.supplierInvoices.isDeleted.equals(false)))
          .getSingle()
          .then((row) => row.read(_database.supplierInvoices.total.sum()) ?? 0.0);

      return Result.success(SupplierInvoiceStats(
        totalInvoices: totalInvoices,
        totalAmount: totalAmount,
        unpaidAmount: unpaidAmount,
      ));
    } catch (e, stack) {
      AppLogger.error('Failed to get supplier invoice stats', e, stack);
      return Result.failure(AppError.generic('Failed to get stats'));
    }
  }
}

/// Helper class for invoice item data
class InvoiceItemData {
  final String itemId;
  final String itemName;
  final int quantity;
  final double buyingPrice;
  final String? comment;

  InvoiceItemData({
    required this.itemId,
    required this.itemName,
    required this.quantity,
    required this.buyingPrice,
    this.comment,
  });
}

/// Helper class for extra charge data
class ExtraChargeData {
  final String description;
  final double amount;

  ExtraChargeData({
    required this.description,
    required this.amount,
  });

  Map<String, dynamic> toJson() => {
    'description': description,
    'amount': amount,
  };

  factory ExtraChargeData.fromJson(Map<String, dynamic> json) => ExtraChargeData(
    description: json['description'],
    amount: json['amount'],
  );

  double get netTotal => amount;
}

/// Supplier invoice statistics
class SupplierInvoiceStats {
  final int totalInvoices;
  final double totalAmount;
  final double unpaidAmount;

  SupplierInvoiceStats({
    required this.totalInvoices,
    required this.totalAmount,
    required this.unpaidAmount,
  });

  double get paidAmount => totalAmount - unpaidAmount;
}
