import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'pos_database.g.dart';

// Tables
class Customers extends Table {
  TextColumn get id => text()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get email => text().nullable()();
  TextColumn get mobileNumber => text().nullable()();
  TextColumn get fax => text().nullable()();
  TextColumn get web => text().nullable()();
  TextColumn get abn => text().nullable()();
  TextColumn get acn => text().nullable()();
  TextColumn get comment => text().nullable()();

  // Billing/Delivery Address
  TextColumn get billingStreet => text().nullable()();
  TextColumn get billingCity => text().nullable()();
  TextColumn get billingState => text().nullable()();
  TextColumn get billingAreaCode => text().nullable()();
  TextColumn get billingPostalCode => text().nullable()();
  TextColumn get billingCountry => text().nullable()();

  // Postal Address
  TextColumn get postalStreet => text().nullable()();
  TextColumn get postalCity => text().nullable()();
  TextColumn get postalState => text().nullable()();
  TextColumn get postalAreaCode => text().nullable()();
  TextColumn get postalPostalCode => text().nullable()();
  TextColumn get postalCountry => text().nullable()();

  TextColumn get encryptedData => text().nullable()(); // For additional encrypted PII
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Items extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get itemCode => text().unique()(); // Unique item code for each item

  // Pricing - only selling price
  RealColumn get price => real()(); // Selling price

  // Inventory - quantity can ONLY be updated via supply invoices, NOT directly editable
  IntColumn get quantity => integer().withDefault(const Constant(0))();

  // Additional info
  TextColumn get category => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  // Timestamps
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Invoices extends Table {
  TextColumn get invoiceId => text()();
  TextColumn get customerId => text().references(Customers, #id)();
  DateTimeColumn get createdDate => dateTime()();
  DateTimeColumn get closeDate => dateTime().nullable()();
  BoolColumn get isPaid => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  RealColumn get totalNet => real()();
  RealColumn get totalGst => real()();
  RealColumn get total => real()();
  RealColumn get paidAmount => real().withDefault(const Constant(0))();
  RealColumn get gstPercentage => real()();
  TextColumn get billingAddressJson => text().nullable()();
  TextColumn get shippingAddressJson => text().nullable()();
  TextColumn get customerName => text()();
  TextColumn get customerMobile => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get commentsJson => text().nullable()(); // JSON array of comments

  @override
  Set<Column> get primaryKey => {invoiceId};
}

class InvoiceItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get invoiceId => text().references(Invoices, #invoiceId, onDelete: KeyAction.cascade)();
  TextColumn get itemId => text().references(Items, #id)();
  TextColumn get itemName => text()();
  IntColumn get quantity => integer()();
  RealColumn get netPrice => real()();
  TextColumn get comment => text().nullable()();
  BoolColumn get isPostedItem => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Payments extends Table {
  TextColumn get payId => text()();
  TextColumn get invoiceId => text().references(Invoices, #invoiceId, onDelete: KeyAction.cascade)();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  TextColumn get paymentMethod => text()(); // cash, card, transfer
  TextColumn get comment => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {payId};
}

class ExtraCharges extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get invoiceId => text().references(Invoices, #invoiceId, onDelete: KeyAction.cascade)();
  TextColumn get description => text()();
  RealColumn get amount => real()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Suppliers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get email => text().nullable()();
  TextColumn get mobileNumber => text().nullable()();
  TextColumn get address => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class SupplierInvoices extends Table {
  TextColumn get invoiceId => text()();
  TextColumn get supplierId => text().references(Suppliers, #id)();
  DateTimeColumn get createdDate => dateTime()();
  RealColumn get total => real()();
  BoolColumn get isPaid => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get supplierName => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {invoiceId};
}

class Quotations extends Table {
  TextColumn get quotationId => text()();
  TextColumn get customerId => text().references(Customers, #id)();
  DateTimeColumn get createdDate => dateTime()();
  RealColumn get total => real()();
  TextColumn get status => text()(); // draft, sent, accepted, rejected
  TextColumn get customerName => text()();
  DateTimeColumn get expiryDate => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {quotationId};
}

class CreditNotes extends Table {
  TextColumn get creditNoteId => text()();
  TextColumn get invoiceId => text().references(Invoices, #invoiceId)();
  TextColumn get customerId => text().references(Customers, #id)();
  DateTimeColumn get createdDate => dateTime()();
  RealColumn get amount => real()();
  TextColumn get reason => text().nullable()();
  TextColumn get customerName => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {creditNoteId};
}

// Database
@DriftDatabase(tables: [
  Customers,
  Items,
  Invoices,
  InvoiceItems,
  Payments,
  ExtraCharges,
  Suppliers,
  SupplierInvoices,
  Quotations,
  CreditNotes,
])
class POSDatabase extends _$POSDatabase {
  POSDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();

          // Create indexes for better query performance
          await customStatement('''
            CREATE INDEX idx_invoices_customer ON invoices(customer_id);
            CREATE INDEX idx_invoices_date ON invoices(created_date);
            CREATE INDEX idx_invoices_paid ON invoices(is_paid);
            CREATE INDEX idx_invoice_items_invoice ON invoice_items(invoice_id);
            CREATE INDEX idx_payments_invoice ON payments(invoice_id);
            CREATE INDEX idx_items_name ON items(name);
            CREATE INDEX idx_items_code ON items(item_code);
            CREATE INDEX idx_customers_email ON customers(email);
          ''');
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Migration from v1 to v2: Rename barcode to itemCode, remove cost/buying prices
          if (from == 1 && to == 2) {
            // Create new items table with updated schema
            await customStatement('''
              CREATE TABLE items_new (
                id TEXT NOT NULL PRIMARY KEY,
                name TEXT NOT NULL,
                description TEXT,
                item_code TEXT NOT NULL UNIQUE,
                price REAL NOT NULL,
                quantity INTEGER NOT NULL DEFAULT 0,
                category TEXT,
                is_active INTEGER NOT NULL DEFAULT 1,
                created_at INTEGER NOT NULL DEFAULT (strftime('%s', 'now')),
                updated_at INTEGER NOT NULL DEFAULT (strftime('%s', 'now'))
              )
            ''');

            // Copy data from old table to new table
            // barcode -> item_code, ignore costPrice and other removed fields
            await customStatement('''
              INSERT INTO items_new (id, name, description, item_code, price, quantity, category, is_active, created_at, updated_at)
              SELECT id, name, description,
                     COALESCE(barcode, 'ITEM-' || substr(id, -8)) as item_code,
                     price, quantity, category, is_active, created_at, updated_at
              FROM items
            ''');

            // Drop old table
            await customStatement('DROP TABLE items');

            // Rename new table
            await customStatement('ALTER TABLE items_new RENAME TO items');

            // Recreate index
            await customStatement('CREATE INDEX idx_items_name ON items(name)');
            await customStatement('CREATE INDEX idx_items_code ON items(item_code)');
          }
        },
      );

  // Complex queries with JOINs
  Future<List<InvoiceWithCustomer>> getInvoicesWithCustomers({
    required DateTime startDate,
    required DateTime endDate,
    bool? isPaid,
  }) async {
    final query = select(invoices).join([
      leftOuterJoin(customers, customers.id.equalsExp(invoices.customerId)),
    ])
      ..where(invoices.createdDate.isBiggerOrEqualValue(startDate))
      ..where(invoices.createdDate.isSmallerOrEqualValue(endDate));

    if (isPaid != null) {
      query.where(invoices.isPaid.equals(isPaid));
    }

    query.orderBy([OrderingTerm.desc(invoices.createdDate)]);

    return query.map((row) {
      return InvoiceWithCustomer(
        invoice: row.readTable(invoices),
        customer: row.readTableOrNull(customers),
      );
    }).get();
  }

  // Get invoice with all related data
  Future<FullInvoiceData> getFullInvoiceData(String invoiceId) async {
    final invoice = await (select(invoices)
          ..where((t) => t.invoiceId.equals(invoiceId)))
        .getSingle();

    final items = await (select(invoiceItems)
          ..where((t) => t.invoiceId.equals(invoiceId)))
        .get();

    final paymentsData = await (select(payments)
          ..where((t) => t.invoiceId.equals(invoiceId)))
        .get();

    final charges = await (select(extraCharges)
          ..where((t) => t.invoiceId.equals(invoiceId)))
        .get();

    return FullInvoiceData(
      invoice: invoice,
      items: items,
      payments: paymentsData,
      extraCharges: charges,
    );
  }

  // Search customers by name or email (full-text search)
  Future<List<Customer>> searchCustomers(String query) async {
    return (select(customers)
          ..where((c) =>
              c.firstName.like('%$query%') |
              c.lastName.like('%$query%') |
              c.email.like('%$query%')))
        .get();
  }

  // Get customer outstanding balance
  Future<double> getCustomerOutstandingBalance(String customerId) async {
    final result = await (selectOnly(invoices)
          ..addColumns([invoices.total.sum()])
          ..where(invoices.customerId.equals(customerId))
          ..where(invoices.isPaid.equals(false))
          ..where(invoices.isDeleted.equals(false)))
        .getSingle();

    return result.read(invoices.total.sum()) ?? 0.0;
  }

  // Update stock quantity (transaction)
  Future<void> updateStockQuantity(String itemId, int quantityChange) async {
    await transaction(() async {
      final item = await (select(items)..where((i) => i.id.equals(itemId))).getSingle();

      final newQuantity = item.quantity + quantityChange;

      if (newQuantity < 0) {
        throw Exception('Insufficient stock for item ${item.name}');
      }

      await (update(items)..where((i) => i.id.equals(itemId)))
          .write(ItemsCompanion(quantity: Value(newQuantity)));
    });
  }

  // Create invoice with items (atomic transaction)
  Future<void> createInvoiceWithItems({
    required InvoicesCompanion invoice,
    required List<InvoiceItemsCompanion> items,
    required List<ExtraChargesCompanion> charges,
  }) async {
    await transaction(() async {
      // Insert invoice
      await into(invoices).insert(invoice);

      // Insert items
      for (final item in items) {
        await into(invoiceItems).insert(item);

        // Update stock
        if (item.itemId.present) {
          await updateStockQuantity(item.itemId.value, -item.quantity.value);
        }
      }

      // Insert extra charges
      for (final charge in charges) {
        await into(extraCharges).insert(charge);
      }
    });
  }

  // Sales report query
  Future<SalesReport> getSalesReport({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final totalSales = await (selectOnly(invoices)
          ..addColumns([invoices.total.sum()])
          ..where(invoices.createdDate.isBiggerOrEqualValue(startDate))
          ..where(invoices.createdDate.isSmallerOrEqualValue(endDate))
          ..where(invoices.isDeleted.equals(false)))
        .getSingle();

    final totalInvoices = await (selectOnly(invoices)
          ..addColumns([invoices.invoiceId.count()])
          ..where(invoices.createdDate.isBiggerOrEqualValue(startDate))
          ..where(invoices.createdDate.isSmallerOrEqualValue(endDate))
          ..where(invoices.isDeleted.equals(false)))
        .getSingle();

    final totalPaid = await (selectOnly(invoices)
          ..addColumns([invoices.total.sum()])
          ..where(invoices.createdDate.isBiggerOrEqualValue(startDate))
          ..where(invoices.createdDate.isSmallerOrEqualValue(endDate))
          ..where(invoices.isPaid.equals(true))
          ..where(invoices.isDeleted.equals(false)))
        .getSingle();

    return SalesReport(
      totalSales: totalSales.read(invoices.total.sum()) ?? 0.0,
      totalInvoices: totalInvoices.read(invoices.invoiceId.count()) ?? 0,
      totalPaid: totalPaid.read(invoices.total.sum()) ?? 0.0,
      startDate: startDate,
      endDate: endDate,
    );
  }
}

// Helper classes
class InvoiceWithCustomer {
  final Invoice invoice;
  final Customer? customer;

  InvoiceWithCustomer({required this.invoice, this.customer});
}

class FullInvoiceData {
  final Invoice invoice;
  final List<InvoiceItem> items;
  final List<Payment> payments;
  final List<ExtraCharge> extraCharges;

  FullInvoiceData({
    required this.invoice,
    required this.items,
    required this.payments,
    required this.extraCharges,
  });
}

class SalesReport {
  final double totalSales;
  final int totalInvoices;
  final double totalPaid;
  final DateTime startDate;
  final DateTime endDate;

  SalesReport({
    required this.totalSales,
    required this.totalInvoices,
    required this.totalPaid,
    required this.startDate,
    required this.endDate,
  });

  double get totalOutstanding => totalSales - totalPaid;
}

// Connection
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'pos_db.sqlite'));
    return NativeDatabase(file);
  });
}
