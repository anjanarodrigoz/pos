import 'package:drift/drift.dart';
import 'package:pos/database/pos_database.dart';
import 'package:pos/services/encryption_service.dart';
import 'package:pos/services/logger_service.dart';
import 'package:pos/utils/id_generator.dart';
import 'package:pos/utils/result.dart';

/// Repository for customer operations using Drift database
/// Replaces CustomerDB (GetStorage) with type-safe, queryable database
class CustomerRepository {
  final POSDatabase _database;

  CustomerRepository(this._database);

  /// Get all customers with optional search
  Future<Result<List<Customer>>> getAllCustomers({String? searchQuery}) async {
    try {
      if (searchQuery != null && searchQuery.isNotEmpty) {
        return Result.success(await _database.searchCustomers(searchQuery));
      }

      final customers = await _database.select(_database.customers).get();
      return Result.success(customers);
    } catch (e, stack) {
      AppLogger.error('Failed to get customers', e, stack);
      return Result.failure(
        AppError.generic('Failed to load customers: ${e.toString()}'),
      );
    }
  }

  /// Get customer by ID
  Future<Result<Customer>> getCustomer(String customerId) async {
    try {
      final customer = await (_database.select(_database.customers)
            ..where((c) => c.id.equals(customerId)))
          .getSingle();

      return Result.success(customer);
    } catch (e, stack) {
      AppLogger.error('Failed to get customer $customerId', e, stack);
      return Result.failure(
        AppError.notFound('Customer not found'),
      );
    }
  }

  /// Create new customer
  Future<Result<Customer>> createCustomer({
    required String firstName,
    required String lastName,
    String? email,
    String? mobileNumber,
  }) async {
    try {
      final customerId = IDGenerator.generateCustomerId();

      // Encrypt PII data
      final encryptedEmail = email != null ? EncryptionService.encryptString(email) : null;
      final encryptedMobile =
          mobileNumber != null ? EncryptionService.encryptString(mobileNumber) : null;

      final companion = CustomersCompanion.insert(
        id: customerId,
        firstName: firstName,
        lastName: lastName,
        email: Value(email), // Store plain for searching, encrypted in encryptedData
        mobileNumber: Value(mobileNumber),
        encryptedData: Value(
          // Store encrypted JSON with all PII
          EncryptionService.encryptString('{"email":"$email","mobile":"$mobileNumber"}'),
        ),
      );

      await _database.into(_database.customers).insert(companion);

      final customer = await getCustomer(customerId);
      AppLogger.info('Customer created: $customerId');

      return customer;
    } catch (e, stack) {
      AppLogger.error('Failed to create customer', e, stack);
      return Result.failure(
        AppError.generic('Failed to create customer: ${e.toString()}'),
      );
    }
  }

  /// Update customer
  Future<Result<Customer>> updateCustomer({
    required String customerId,
    String? firstName,
    String? lastName,
    String? email,
    String? mobileNumber,
  }) async {
    try {
      final updates = CustomersCompanion(
        id: Value(customerId),
        firstName: firstName != null ? Value(firstName) : const Value.absent(),
        lastName: lastName != null ? Value(lastName) : const Value.absent(),
        email: email != null ? Value(email) : const Value.absent(),
        mobileNumber: mobileNumber != null ? Value(mobileNumber) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      );

      await (_database.update(_database.customers)
            ..where((c) => c.id.equals(customerId)))
          .write(updates);

      final customer = await getCustomer(customerId);
      AppLogger.info('Customer updated: $customerId');

      return customer;
    } catch (e, stack) {
      AppLogger.error('Failed to update customer $customerId', e, stack);
      return Result.failure(
        AppError.generic('Failed to update customer: ${e.toString()}'),
      );
    }
  }

  /// Delete customer
  Future<Result<void>> deleteCustomer(String customerId) async {
    try {
      // Check if customer has any invoices
      final invoiceCount = await (_database.selectOnly(_database.invoices)
            ..addColumns([_database.invoices.invoiceId.count()])
            ..where(_database.invoices.customerId.equals(customerId)))
          .getSingle()
          .then((row) => row.read(_database.invoices.invoiceId.count()) ?? 0);

      if (invoiceCount > 0) {
        return Result.failure(
          AppError.validation(
            'Cannot delete customer with existing invoices ($invoiceCount found)',
          ),
        );
      }

      await (_database.delete(_database.customers)
            ..where((c) => c.id.equals(customerId)))
          .go();

      AppLogger.info('Customer deleted: $customerId');
      return Result.success(null);
    } catch (e, stack) {
      AppLogger.error('Failed to delete customer $customerId', e, stack);
      return Result.failure(
        AppError.generic('Failed to delete customer: ${e.toString()}'),
      );
    }
  }

  /// Get customer outstanding balance
  Future<Result<double>> getOutstandingBalance(String customerId) async {
    try {
      final balance = await _database.getCustomerOutstandingBalance(customerId);
      return Result.success(balance);
    } catch (e, stack) {
      AppLogger.error('Failed to get customer balance $customerId', e, stack);
      return Result.failure(
        AppError.generic('Failed to get balance: ${e.toString()}'),
      );
    }
  }

  /// Get customer's recent invoices
  Future<Result<List<Invoice>>> getCustomerInvoices(
    String customerId, {
    int limit = 10,
  }) async {
    try {
      final invoices = await (_database.select(_database.invoices)
            ..where((i) => i.customerId.equals(customerId))
            ..orderBy([(i) => OrderingTerm.desc(i.createdDate)])
            ..limit(limit))
          .get();

      return Result.success(invoices);
    } catch (e, stack) {
      AppLogger.error('Failed to get customer invoices $customerId', e, stack);
      return Result.failure(
        AppError.generic('Failed to get invoices: ${e.toString()}'),
      );
    }
  }

  /// Watch customers (reactive stream for GetX)
  Stream<List<Customer>> watchAllCustomers() {
    return _database.select(_database.customers).watch();
  }

  /// Watch single customer
  Stream<Customer> watchCustomer(String customerId) {
    return (_database.select(_database.customers)
          ..where((c) => c.id.equals(customerId)))
        .watchSingle();
  }

  /// Get customer statistics
  Future<Result<CustomerStats>> getCustomerStats(String customerId) async {
    try {
      // Total invoices
      final totalInvoices = await (_database.selectOnly(_database.invoices)
            ..addColumns([_database.invoices.invoiceId.count()])
            ..where(_database.invoices.customerId.equals(customerId)))
          .getSingle()
          .then((row) => row.read(_database.invoices.invoiceId.count()) ?? 0);

      // Total spent
      final totalSpent = await (_database.selectOnly(_database.invoices)
            ..addColumns([_database.invoices.total.sum()])
            ..where(_database.invoices.customerId.equals(customerId))
            ..where(_database.invoices.isDeleted.equals(false)))
          .getSingle()
          .then((row) => row.read(_database.invoices.total.sum()) ?? 0.0);

      // Outstanding balance
      final outstanding = await _database.getCustomerOutstandingBalance(customerId);

      // Last invoice date
      final lastInvoice = await (_database.select(_database.invoices)
            ..where((i) => i.customerId.equals(customerId))
            ..orderBy([(i) => OrderingTerm.desc(i.createdDate)])
            ..limit(1))
          .getSingleOrNull();

      return Result.success(
        CustomerStats(
          totalInvoices: totalInvoices,
          totalSpent: totalSpent,
          outstandingBalance: outstanding,
          lastInvoiceDate: lastInvoice?.createdDate,
        ),
      );
    } catch (e, stack) {
      AppLogger.error('Failed to get customer stats $customerId', e, stack);
      return Result.failure(
        AppError.generic('Failed to get stats: ${e.toString()}'),
      );
    }
  }
}

class CustomerStats {
  final int totalInvoices;
  final double totalSpent;
  final double outstandingBalance;
  final DateTime? lastInvoiceDate;

  CustomerStats({
    required this.totalInvoices,
    required this.totalSpent,
    required this.outstandingBalance,
    this.lastInvoiceDate,
  });
}
