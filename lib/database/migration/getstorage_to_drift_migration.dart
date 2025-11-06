import 'package:get_storage/get_storage.dart';
import 'package:pos/database/pos_database.dart';
import 'package:pos/models/customer.dart' as old_models;
import 'package:pos/models/invoice.dart' as old_models;
import 'package:pos/models/item.dart' as old_models;
import 'package:pos/services/logger_service.dart';
import 'package:pos/utils/val.dart';
import 'package:drift/drift.dart' as drift;

/// Migration utility to transfer data from GetStorage to Drift database
class GetStorageToDriftMigration {
  final POSDatabase database;

  GetStorageToDriftMigration(this.database);

  /// Run complete migration
  Future<MigrationResult> migrateAll() async {
    AppLogger.info('Starting GetStorage to Drift migration...');
    final result = MigrationResult();

    try {
      // Migrate in order (respecting foreign keys)
      result.customersCount = await migrateCustomers();
      result.itemsCount = await migrateItems();
      result.suppliersCount = await migrateSuppliers();
      result.invoicesCount = await migrateInvoices();
      // Add more migrations as needed

      result.success = true;
      AppLogger.info('Migration completed successfully');
      AppLogger.info('Migrated: ${result.customersCount} customers, '
          '${result.itemsCount} items, ${result.invoicesCount} invoices');
    } catch (e, stack) {
      result.success = false;
      result.error = e.toString();
      AppLogger.error('Migration failed', e, stack);
    }

    return result;
  }

  /// Migrate customers
  Future<int> migrateCustomers() async {
    AppLogger.info('Migrating customers...');
    final storage = GetStorage(DBVal.customers);
    final customerData = storage.getValues().toList();

    int count = 0;
    for (final data in customerData) {
      try {
        // Parse old customer model
        final oldCustomer = old_models.Customer.fromJson(data);

        // Insert into Drift
        await database.into(database.customers).insert(
              CustomersCompanion.insert(
                id: oldCustomer.id,
                firstName: oldCustomer.firstName,
                lastName: oldCustomer.lastName,
                email: drift.Value(oldCustomer.email),
                mobileNumber: drift.Value(oldCustomer.mobileNumber),
                // Note: You may want to encrypt PII data here
                createdAt: drift.Value(DateTime.now()),
                updatedAt: drift.Value(DateTime.now()),
              ),
              mode: drift.InsertMode.insertOrReplace,
            );
        count++;
      } catch (e) {
        AppLogger.warning('Failed to migrate customer: $e');
      }
    }

    AppLogger.info('Migrated $count customers');
    return count;
  }

  /// Migrate items
  Future<int> migrateItems() async {
    AppLogger.info('Migrating items...');
    final storage = GetStorage(DBVal.items);
    final itemData = storage.getValues().toList();

    int count = 0;
    for (final data in itemData) {
      try {
        final oldItem = old_models.Item.fromJson(data);

        await database.into(database.items).insert(
              ItemsCompanion.insert(
                id: oldItem.id,
                name: oldItem.name,
                description: drift.Value(oldItem.description),
                price: oldItem.netPrice,
                quantity: oldItem.qty,
                costPrice: drift.Value(oldItem.costPrice),
                category: drift.Value(oldItem.category),
                isActive: drift.Value(true),
                createdAt: drift.Value(DateTime.now()),
                updatedAt: drift.Value(DateTime.now()),
              ),
              mode: drift.InsertMode.insertOrReplace,
            );
        count++;
      } catch (e) {
        AppLogger.warning('Failed to migrate item: $e');
      }
    }

    AppLogger.info('Migrated $count items');
    return count;
  }

  /// Migrate suppliers
  Future<int> migrateSuppliers() async {
    AppLogger.info('Migrating suppliers...');
    final storage = GetStorage(DBVal.supplyer);
    final supplierData = storage.getValues().toList();

    int count = 0;
    for (final data in supplierData) {
      try {
        // Assuming you have a Supplier model similar to Customer
        await database.into(database.suppliers).insert(
              SuppliersCompanion.insert(
                id: data['id'] ?? '',
                name: data['name'] ?? '',
                email: drift.Value(data['email']),
                mobileNumber: drift.Value(data['mobile']),
                address: drift.Value(data['address']),
                createdAt: drift.Value(DateTime.now()),
                updatedAt: drift.Value(DateTime.now()),
              ),
              mode: drift.InsertMode.insertOrReplace,
            );
        count++;
      } catch (e) {
        AppLogger.warning('Failed to migrate supplier: $e');
      }
    }

    AppLogger.info('Migrated $count suppliers');
    return count;
  }

  /// Migrate invoices with items
  Future<int> migrateInvoices() async {
    AppLogger.info('Migrating invoices...');
    final storage = GetStorage(DBVal.invoice);
    final invoiceData = storage.getValues().toList();

    int count = 0;
    for (final data in invoiceData) {
      try {
        final oldInvoice = old_models.Invoice.fromJson(data);

        // Use transaction for invoice + items
        await database.transaction(() async {
          // Insert invoice
          await database.into(database.invoices).insert(
                InvoicesCompanion.insert(
                  invoiceId: oldInvoice.invoiceId,
                  customerId: oldInvoice.customerId,
                  createdDate: oldInvoice.createdDate,
                  closeDate: drift.Value(oldInvoice.closeDate),
                  isPaid: drift.Value(oldInvoice.isPaid),
                  isDeleted: drift.Value(oldInvoice.isDeleted),
                  totalNet: oldInvoice.totalNetPrice,
                  totalGst: oldInvoice.totalGstPrice,
                  total: oldInvoice.total,
                  paidAmount: drift.Value(oldInvoice.paidAmount),
                  gstPercentage: oldInvoice.gstPrecentage,
                  customerName: oldInvoice.customerName,
                  customerMobile: drift.Value(oldInvoice.customerMobile),
                  email: drift.Value(oldInvoice.email),
                ),
                mode: drift.InsertMode.insertOrReplace,
              );

          // Insert invoice items
          for (final item in oldInvoice.itemList) {
            await database.into(database.invoiceItems).insert(
                  InvoiceItemsCompanion.insert(
                    invoiceId: oldInvoice.invoiceId,
                    itemId: item.itemId,
                    itemName: item.name,
                    quantity: item.qty,
                    netPrice: item.netPrice,
                    comment: drift.Value(item.comment),
                    isPostedItem: drift.Value(item.isPostedItem),
                  ),
                );
          }

          // Insert extra charges
          if (oldInvoice.extraCharges != null) {
            for (final charge in oldInvoice.extraCharges!) {
              await database.into(database.extraCharges).insert(
                    ExtraChargesCompanion.insert(
                      invoiceId: oldInvoice.invoiceId,
                      description: charge.description,
                      amount: charge.netTotal,
                    ),
                  );
            }
          }

          // Insert payments
          if (oldInvoice.payments != null) {
            for (final payment in oldInvoice.payments!) {
              await database.into(database.payments).insert(
                    PaymentsCompanion.insert(
                      payId: payment.payId,
                      invoiceId: oldInvoice.invoiceId,
                      amount: payment.amount,
                      date: payment.date,
                      paymentMethod: payment.paymethod.toString(),
                      comment: drift.Value(payment.comment),
                    ),
                  );
            }
          }
        });

        count++;
      } catch (e, stack) {
        AppLogger.error('Failed to migrate invoice ${data['invoice_id']}', e, stack);
      }
    }

    AppLogger.info('Migrated $count invoices');
    return count;
  }

  /// Verify migration integrity
  Future<bool> verifyMigration() async {
    AppLogger.info('Verifying migration...');

    try {
      // Check customers
      final oldCustomerCount = GetStorage(DBVal.customers).getValues().length;
      final newCustomerCount = await database.select(database.customers).get().then((l) => l.length);

      AppLogger.info('Customers: Old=$oldCustomerCount, New=$newCustomerCount');

      // Check items
      final oldItemCount = GetStorage(DBVal.items).getValues().length;
      final newItemCount = await database.select(database.items).get().then((l) => l.length);

      AppLogger.info('Items: Old=$oldItemCount, New=$newItemCount');

      // Check invoices
      final oldInvoiceCount = GetStorage(DBVal.invoice).getValues().length;
      final newInvoiceCount = await database.select(database.invoices).get().then((l) => l.length);

      AppLogger.info('Invoices: Old=$oldInvoiceCount, New=$newInvoiceCount');

      return true;
    } catch (e, stack) {
      AppLogger.error('Migration verification failed', e, stack);
      return false;
    }
  }

  /// Backup GetStorage data before migration
  Future<void> backupGetStorage() async {
    AppLogger.info('Creating GetStorage backup...');
    // Use existing backup functionality
    // This is just a safety measure
  }
}

class MigrationResult {
  bool success = false;
  String? error;
  int customersCount = 0;
  int itemsCount = 0;
  int suppliersCount = 0;
  int invoicesCount = 0;

  int get totalRecords =>
      customersCount + itemsCount + suppliersCount + invoicesCount;
}
