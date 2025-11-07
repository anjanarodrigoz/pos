import 'package:drift/drift.dart';
import 'package:pos/database/pos_database.dart';
import 'package:pos/services/logger_service.dart';
import 'package:pos/utils/id_generator.dart';
import 'package:pos/utils/result.dart';

/// Repository for supplier operations
class SupplierRepository {
  final POSDatabase _database;

  SupplierRepository(this._database);

  /// Get all suppliers
  Future<Result<List<Supplier>>> getAllSuppliers() async {
    try {
      final suppliers = await (_database.select(_database.suppliers)
            ..orderBy([(s) => OrderingTerm.asc(s.name)]))
          .get();

      return Result.success(suppliers);
    } catch (e, stack) {
      AppLogger.error('Failed to get suppliers', e, stack);
      return Result.failure(AppError.generic('Failed to load suppliers'));
    }
  }

  /// Get single supplier
  Future<Result<Supplier>> getSupplier(String supplierId) async {
    try {
      final supplier = await (_database.select(_database.suppliers)
            ..where((s) => s.id.equals(supplierId)))
          .getSingle();

      return Result.success(supplier);
    } catch (e, stack) {
      AppLogger.error('Failed to get supplier $supplierId', e, stack);
      return Result.failure(AppError.notFound('Supplier not found'));
    }
  }

  /// Search suppliers by name
  Future<Result<List<Supplier>>> searchSuppliers(String query) async {
    try {
      final suppliers = await (_database.select(_database.suppliers)
            ..where((s) =>
                s.name.like('%$query%') |
                s.email.like('%$query%') |
                s.mobileNumber.like('%$query%')))
          .get();

      return Result.success(suppliers);
    } catch (e, stack) {
      AppLogger.error('Failed to search suppliers', e, stack);
      return Result.failure(AppError.generic('Failed to search suppliers'));
    }
  }

  /// Create supplier
  Future<Result<Supplier>> createSupplier({
    required String name,
    String? email,
    String? mobileNumber,
    String? address,
  }) async {
    try {
      final supplierId = IDGenerator.generateSupplierId();

      final companion = SuppliersCompanion.insert(
        id: supplierId,
        name: name,
        email: Value(email),
        mobileNumber: Value(mobileNumber),
        address: Value(address),
      );

      await _database.into(_database.suppliers).insert(companion);

      final supplier = await getSupplier(supplierId);
      AppLogger.info('Supplier created: $supplierId - $name');

      return supplier;
    } catch (e, stack) {
      AppLogger.error('Failed to create supplier', e, stack);
      return Result.failure(AppError.generic('Failed to create supplier'));
    }
  }

  /// Update supplier
  Future<Result<Supplier>> updateSupplier({
    required String supplierId,
    String? name,
    String? email,
    String? mobileNumber,
    String? address,
  }) async {
    try {
      final updates = SuppliersCompanion(
        id: Value(supplierId),
        name: name != null ? Value(name) : const Value.absent(),
        email: email != null ? Value(email) : const Value.absent(),
        mobileNumber:
            mobileNumber != null ? Value(mobileNumber) : const Value.absent(),
        address: address != null ? Value(address) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      );

      await (_database.update(_database.suppliers)
            ..where((s) => s.id.equals(supplierId)))
          .write(updates);

      final supplier = await getSupplier(supplierId);
      AppLogger.info('Supplier updated: $supplierId');

      return supplier;
    } catch (e, stack) {
      AppLogger.error('Failed to update supplier $supplierId', e, stack);
      return Result.failure(AppError.generic('Failed to update supplier'));
    }
  }

  /// Delete supplier
  Future<Result<void>> deleteSupplier(String supplierId) async {
    try {
      // Check if supplier has invoices
      final invoiceCount = await (_database
              .selectOnly(_database.supplierInvoices)
            ..addColumns([_database.supplierInvoices.invoiceId.count()])
            ..where(_database.supplierInvoices.supplierId.equals(supplierId)))
          .getSingle()
          .then((row) =>
              row.read(_database.supplierInvoices.invoiceId.count()) ?? 0);

      if (invoiceCount > 0) {
        return Result.failure(AppError.validation(
          'Cannot delete supplier with existing invoices',
        ));
      }

      await (_database.delete(_database.suppliers)
            ..where((s) => s.id.equals(supplierId)))
          .go();

      AppLogger.info('Supplier deleted: $supplierId');
      return Result.success(null);
    } catch (e, stack) {
      AppLogger.error('Failed to delete supplier $supplierId', e, stack);
      return Result.failure(AppError.generic('Failed to delete supplier'));
    }
  }

  /// Watch all suppliers (reactive)
  Stream<List<Supplier>> watchAllSuppliers() {
    return (_database.select(_database.suppliers)
          ..orderBy([(s) => OrderingTerm.asc(s.name)]))
        .watch();
  }

  /// Watch single supplier
  Stream<Supplier> watchSupplier(String supplierId) {
    return (_database.select(_database.suppliers)
          ..where((s) => s.id.equals(supplierId)))
        .watchSingle();
  }

  /// Get supplier statistics
  Future<Result<SupplierStats>> getSupplierStats(String supplierId) async {
    try {
      // Total invoices
      final totalInvoices = await (_database
              .selectOnly(_database.supplierInvoices)
            ..addColumns([_database.supplierInvoices.invoiceId.count()])
            ..where(_database.supplierInvoices.supplierId.equals(supplierId))
            ..where(_database.supplierInvoices.isDeleted.equals(false)))
          .getSingle()
          .then((row) =>
              row.read(_database.supplierInvoices.invoiceId.count()) ?? 0);

      // Total amount
      final totalAmount = await (_database
              .selectOnly(_database.supplierInvoices)
            ..addColumns([_database.supplierInvoices.total.sum()])
            ..where(_database.supplierInvoices.supplierId.equals(supplierId))
            ..where(_database.supplierInvoices.isDeleted.equals(false)))
          .getSingle()
          .then(
              (row) => row.read(_database.supplierInvoices.total.sum()) ?? 0.0);

      // Unpaid amount
      final unpaidAmount = await (_database
              .selectOnly(_database.supplierInvoices)
            ..addColumns([_database.supplierInvoices.total.sum()])
            ..where(_database.supplierInvoices.supplierId.equals(supplierId))
            ..where(_database.supplierInvoices.isPaid.equals(false))
            ..where(_database.supplierInvoices.isDeleted.equals(false)))
          .getSingle()
          .then(
              (row) => row.read(_database.supplierInvoices.total.sum()) ?? 0.0);

      return Result.success(SupplierStats(
        totalInvoices: totalInvoices,
        totalAmount: totalAmount,
        unpaidAmount: unpaidAmount,
      ));
    } catch (e, stack) {
      AppLogger.error('Failed to get supplier stats $supplierId', e, stack);
      return Result.failure(AppError.generic('Failed to get stats'));
    }
  }
}

class SupplierStats {
  final int totalInvoices;
  final double totalAmount;
  final double unpaidAmount;

  SupplierStats({
    required this.totalInvoices,
    required this.totalAmount,
    required this.unpaidAmount,
  });

  double get paidAmount => totalAmount - unpaidAmount;
}
