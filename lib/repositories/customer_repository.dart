import 'package:drift/drift.dart';
import 'package:pos/database/pos_database.dart';
import 'package:pos/services/logger_service.dart';
import 'package:pos/utils/id_generator.dart';
import 'package:pos/utils/result.dart';

/// Repository for customer operations using Drift database
class CustomerRepository {
  final POSDatabase _database;

  CustomerRepository(this._database);

  /// Get all customers with optional search
  Future<Result<List<Customer>>> getAllCustomers({String? searchQuery}) async {
    try {
      var query = _database.select(_database.customers);

      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query..where((c) =>
          c.firstName.like('%$searchQuery%') |
          c.lastName.like('%$searchQuery%') |
          c.email.like('%$searchQuery%') |
          c.mobileNumber.like('%$searchQuery%'));
      }

      query = query..orderBy([(c) => OrderingTerm.asc(c.firstName)]);
      final customers = await query.get();
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

  /// Create new customer with full details
  Future<Result<Customer>> createCustomer({
    required String firstName,
    required String lastName,
    required String mobileNumber,
    String? email,
    String? fax,
    String? web,
    String? abn,
    String? acn,
    String? comment,
    // Billing address
    String? billingStreet,
    String? billingCity,
    String? billingState,
    String? billingAreaCode,
    String? billingPostalCode,
    String? billingCountry,
    // Postal address
    String? postalStreet,
    String? postalCity,
    String? postalState,
    String? postalAreaCode,
    String? postalPostalCode,
    String? postalCountry,
  }) async {
    try {
      // Generate auto-incremental customer ID
      final count = await (_database.selectOnly(_database.customers)
            ..addColumns([_database.customers.id.count()]))
          .getSingle()
          .then((row) => row.read(_database.customers.id.count()) ?? 0);

      final customerId = 'CUST-${(count + 1).toString().padLeft(4, '0')}';

      final companion = CustomersCompanion.insert(
        id: customerId,
        firstName: firstName,
        lastName: lastName,
        mobileNumber: Value(mobileNumber),
        email: Value(email),
        fax: Value(fax),
        web: Value(web),
        abn: Value(abn),
        acn: Value(acn),
        comment: Value(comment),
        // Billing address
        billingStreet: Value(billingStreet),
        billingCity: Value(billingCity),
        billingState: Value(billingState),
        billingAreaCode: Value(billingAreaCode),
        billingPostalCode: Value(billingPostalCode),
        billingCountry: Value(billingCountry),
        // Postal address
        postalStreet: Value(postalStreet),
        postalCity: Value(postalCity),
        postalState: Value(postalState),
        postalAreaCode: Value(postalAreaCode),
        postalPostalCode: Value(postalPostalCode),
        postalCountry: Value(postalCountry),
      );

      await _database.into(_database.customers).insert(companion);

      final customer = await getCustomer(customerId);
      AppLogger.info('Customer created: $customerId - $firstName $lastName');

      return customer;
    } catch (e, stack) {
      AppLogger.error('Failed to create customer', e, stack);
      return Result.failure(
        AppError.generic('Failed to create customer: ${e.toString()}'),
      );
    }
  }

  /// Update customer
  Future<Result<Customer>> updateCustomer(Customer customer) async {
    try {
      await (_database.update(_database.customers)
            ..where((c) => c.id.equals(customer.id)))
          .write(customer.toCompanion(true));

      final updated = await getCustomer(customer.id);
      AppLogger.info('Customer updated: ${customer.id}');

      return updated;
    } catch (e, stack) {
      AppLogger.error('Failed to update customer ${customer.id}', e, stack);
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

  /// Watch all customers (reactive stream)
  Stream<List<Customer>> watchAllCustomers() {
    return (_database.select(_database.customers)
          ..orderBy([(c) => OrderingTerm.asc(c.firstName)]))
        .watch();
  }

  /// Watch single customer
  Stream<Customer> watchCustomer(String customerId) {
    return (_database.select(_database.customers)
          ..where((c) => c.id.equals(customerId)))
        .watchSingle();
  }

  /// Get customer count
  Future<Result<int>> getCustomerCount() async {
    try {
      final count = await (_database.selectOnly(_database.customers)
            ..addColumns([_database.customers.id.count()]))
          .getSingle()
          .then((row) => row.read(_database.customers.id.count()) ?? 0);
      return Result.success(count);
    } catch (e, stack) {
      AppLogger.error('Failed to get customer count', e, stack);
      return Result.failure(AppError.generic('Failed to count customers'));
    }
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
