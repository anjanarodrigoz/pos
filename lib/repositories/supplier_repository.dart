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
  Future<Result<List<Supplier>>> getAllSuppliers({bool activeOnly = false}) async {
    try {
      var query = _database.select(_database.suppliers);

      if (activeOnly) {
        query = query..where((s) => s.isActive.equals(true));
      }

      query = query..orderBy([(s) => OrderingTerm.asc(s.firstName)]);

      final suppliers = await query.get();
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

  /// Search suppliers by name or email
  Future<Result<List<Supplier>>> searchSuppliers(String query) async {
    try {
      final suppliers = await (_database.select(_database.suppliers)
            ..where((s) =>
                s.firstName.like('%$query%') |
                s.lastName.like('%$query%') |
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
    required String firstName,
    required String lastName,
    required String mobileNumber,
    String? email,
    String? fax,
    String? web,
    String? abn,
    String? acn,
    String? comment,
    String? street,
    String? city,
    String? state,
    String? areaCode,
    String? postalCode,
    String? country,
  }) async {
    try {
      final supplierId = IDGenerator.generateSupplierId();

      final companion = SuppliersCompanion.insert(
        id: supplierId,
        firstName: firstName,
        lastName: lastName,
        mobileNumber: Value(mobileNumber),
        email: Value(email),
        fax: Value(fax),
        web: Value(web),
        abn: Value(abn),
        acn: Value(acn),
        comment: Value(comment),
        street: Value(street),
        city: Value(city),
        state: Value(state),
        areaCode: Value(areaCode),
        postalCode: Value(postalCode),
        country: Value(country),
      );

      await _database.into(_database.suppliers).insert(companion);

      final supplier = await getSupplier(supplierId);
      AppLogger.info('Supplier created: $supplierId - $firstName $lastName');

      return supplier;
    } catch (e, stack) {
      AppLogger.error('Failed to create supplier', e, stack);
      return Result.failure(AppError.generic('Failed to create supplier'));
    }
  }

  /// Update supplier
  Future<Result<Supplier>> updateSupplier(Supplier supplier) async {
    try {
      await (_database.update(_database.suppliers)
            ..where((s) => s.id.equals(supplier.id)))
          .write(supplier.toCompanion(true));

      AppLogger.info('Supplier updated: ${supplier.id}');
      return await getSupplier(supplier.id);
    } catch (e, stack) {
      AppLogger.error('Failed to update supplier ${supplier.id}', e, stack);
      return Result.failure(AppError.generic('Failed to update supplier'));
    }
  }

  /// Delete supplier (soft delete)
  Future<Result<void>> deleteSupplier(String supplierId) async {
    try {
      await (_database.update(_database.suppliers)
            ..where((s) => s.id.equals(supplierId)))
          .write(const SuppliersCompanion(isActive: Value(false)));

      AppLogger.info('Supplier deleted (soft): $supplierId');
      return Result.success(null);
    } catch (e, stack) {
      AppLogger.error('Failed to delete supplier $supplierId', e, stack);
      return Result.failure(AppError.generic('Failed to delete supplier'));
    }
  }

  /// Restore supplier
  Future<Result<void>> restoreSupplier(String supplierId) async {
    try {
      await (_database.update(_database.suppliers)
            ..where((s) => s.id.equals(supplierId)))
          .write(const SuppliersCompanion(isActive: Value(true)));

      AppLogger.info('Supplier restored: $supplierId');
      return Result.success(null);
    } catch (e, stack) {
      AppLogger.error('Failed to restore supplier $supplierId', e, stack);
      return Result.failure(AppError.generic('Failed to restore supplier'));
    }
  }

  /// Watch all suppliers (reactive)
  Stream<List<Supplier>> watchAllSuppliers({bool activeOnly = false}) {
    var query = _database.select(_database.suppliers);

    if (activeOnly) {
      query = query..where((s) => s.isActive.equals(true));
    }

    return (query..orderBy([(s) => OrderingTerm.asc(s.firstName)])).watch();
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
