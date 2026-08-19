# 🚀 Drift Database Setup Guide (New Project)

This is a **NEW project** with no existing data. This guide will help you set up Drift (SQLite) database from scratch.

---

## ✅ What's Already Done

Your database is **pre-configured** and ready to use:

- ✅ Database schema with 10 tables (customers, items, invoices, etc.)
- ✅ Type-safe queries with compile-time validation
- ✅ Repository pattern for clean code
- ✅ ACID transactions for data integrity
- ✅ Reactive streams for real-time UI updates
- ✅ Indexes for fast queries
- ✅ Foreign key constraints

---

## 📦 Step 1: Install Dependencies (2 minutes)

```bash
flutter pub get
```

This installs:
- `drift` - Type-safe SQLite wrapper
- `sqlite3_flutter_libs` - Native SQLite for desktop
- `drift_dev` - Code generator
- `build_runner` - Build tool

---

## 🏗️ Step 2: Generate Database Code (2 minutes)

Run this command to generate the database code:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This creates `pos_database.g.dart` with all the database logic.

**During development, use watch mode:**
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

This auto-generates code when you modify the schema.

---

## 🎯 Step 3: Initialize Database in Your App

Update your `main.dart` or create a database provider:

```dart
import 'package:pos/database/pos_database.dart';

// Create database instance (singleton)
final database = POSDatabase();

// In your main.dart or app initialization
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize encryption service
  await EncryptionService.initialize();

  // Database is automatically initialized on first use
  // No manual setup needed!

  runApp(MyApp());
}
```

---

## 💡 Step 4: Use Repositories in Your Code

### Example: Customer Operations

```dart
import 'package:pos/repositories/customer_repository.dart';
import 'package:pos/database/pos_database.dart';

final database = POSDatabase();
final customerRepo = CustomerRepository(database);

// Create customer
final result = await customerRepo.createCustomer(
  firstName: 'John',
  lastName: 'Doe',
  email: 'john@example.com',
  mobileNumber: '+1234567890',
);

if (result.isSuccess) {
  print('Customer created: ${result.data!.id}');
} else {
  print('Error: ${result.error!.message}');
}

// Get all customers
final customersResult = await customerRepo.getAllCustomers();
final customers = customersResult.data ?? [];

// Search customers
final searchResult = await customerRepo.getAllCustomers(
  searchQuery: 'john',
);

// Watch customers (reactive - auto-updates UI)
customerRepo.watchAllCustomers().listen((customers) {
  print('Customers updated: ${customers.length}');
});
```

### Example: Item/Inventory Operations

```dart
import 'package:pos/repositories/item_repository.dart';

final itemRepo = ItemRepository(database);

// Create item
await itemRepo.createItem(
  name: 'Product A',
  price: 99.99,
  quantity: 100,
  description: 'Great product',
  category: 'Electronics',
);

// Update stock
await itemRepo.updateStock('ITEM-ABC123', -5); // Sold 5 items

// Get low stock items
final lowStock = await itemRepo.getLowStockItems(threshold: 10);

// Search items
final searchResult = await itemRepo.searchItems('laptop');
```

### Example: Invoice Operations

```dart
import 'package:pos/repositories/invoice_repository.dart';

final invoiceRepo = InvoiceRepository(database);

// Create invoice
final invoiceId = await invoiceRepo.createInvoice(
  customerId: 'CUST-ABC123',
  customerName: 'John Doe',
  email: 'john@example.com',
  items: [
    InvoiceItemData(
      itemId: 'ITEM-ABC123',
      itemName: 'Product A',
      quantity: 2,
      netPrice: 99.99,
    ),
  ],
  extraCharges: [
    ExtraChargeData(
      description: 'Delivery Fee',
      amount: 10.00,
    ),
  ],
);

// Add payment
await invoiceRepo.addPayment(
  invoiceId: invoiceId.data!,
  amount: 100.00,
  paymentMethod: 'cash',
  comment: 'Paid in full',
);

// Get sales report
final report = await invoiceRepo.getSalesReport(
  startDate: DateTime(2024, 1, 1),
  endDate: DateTime.now(),
);

print('Total Sales: \$${report.data!.totalSales}');
print('Total Paid: \$${report.data!.totalPaid}');
print('Outstanding: \$${report.data!.totalOutstanding}');
```

---

## 🎮 Step 5: Use with GetX Controllers

```dart
import 'package:get/get.dart';
import 'package:pos/repositories/customer_repository.dart';

class CustomerController extends GetxController {
  final CustomerRepository _repository;

  final RxList<Customer> customers = <Customer>[].obs;
  final RxBool isLoading = false.obs;

  CustomerController(this._repository);

  @override
  void onInit() {
    super.onInit();

    // Watch customers (reactive - auto-updates)
    _repository.watchAllCustomers().listen((customerList) {
      customers.value = customerList;
    });
  }

  Future<void> createCustomer(String firstName, String lastName) async {
    isLoading.value = true;

    final result = await _repository.createCustomer(
      firstName: firstName,
      lastName: lastName,
    );

    if (result.isSuccess) {
      Get.snackbar('Success', 'Customer created');
    } else {
      Get.snackbar('Error', result.error!.message);
    }

    isLoading.value = false;
  }

  Future<void> searchCustomers(String query) async {
    final result = await _repository.getAllCustomers(searchQuery: query);
    if (result.isSuccess) {
      customers.value = result.data!;
    }
  }
}

// Usage in your app
final database = POSDatabase();
final customerController = Get.put(
  CustomerController(CustomerRepository(database))
);
```

---

## 📊 Database Schema

Your database has 10 tables:

1. **Customers** - Customer master data
2. **Items** - Products/inventory
3. **Invoices** - Sales invoices
4. **InvoiceItems** - Invoice line items
5. **Payments** - Payment records
6. **ExtraCharges** - Additional fees
7. **Suppliers** - Supplier master
8. **SupplierInvoices** - Purchase orders
9. **Quotations** - Sales quotes
10. **CreditNotes** - Returns/refunds

All tables have:
- Primary keys
- Foreign key relationships
- Indexes for fast queries
- Timestamps (created_at, updated_at)

---

## 🔍 Common Queries

### Get Invoices with Customer Data (JOIN)

```dart
final result = await invoiceRepo.getInvoicesWithCustomers(
  startDate: DateTime(2024, 1, 1),
  endDate: DateTime.now(),
  isPaid: false,
);

for (final item in result.data!) {
  print('Invoice: ${item.invoice.invoiceId}');
  print('Customer: ${item.customer?.firstName}');
}
```

### Get Full Invoice (with items, payments, charges)

```dart
final result = await invoiceRepo.getFullInvoiceData('INV-2511-1234');

if (result.isSuccess) {
  final data = result.data!;
  print('Invoice: ${data.invoice.invoiceId}');
  print('Items: ${data.items.length}');
  print('Payments: ${data.payments.length}');
}
```

### Customer Outstanding Balance

```dart
final result = await customerRepo.getOutstandingBalance('CUST-ABC123');
print('Outstanding: \$${result.data}');
```

### Low Stock Alert

```dart
final result = await itemRepo.getLowStockItems(threshold: 10);
print('Low stock items: ${result.data!.length}');
```

---

## 🗂️ Database File Location

Your SQLite database is stored at:

- **Windows:** `C:\Users\<User>\Documents\pos_db.sqlite`
- **macOS:** `~/Documents/pos_db.sqlite`
- **Linux:** `~/.local/share/<app>/pos_db.sqlite`

It's a single file - easy to backup!

---

## 🔐 Backup & Restore

### Backup

```dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

Future<File> backupDatabase() async {
  final dbFolder = await getApplicationDocumentsDirectory();
  final dbFile = File(p.join(dbFolder.path, 'pos_db.sqlite'));

  final backupName = 'backup_${DateTime.now().millisecondsSinceEpoch}.sqlite';
  final backupPath = p.join(dbFolder.path, backupName);

  return await dbFile.copy(backupPath);
}
```

### Restore

```dart
Future<void> restoreDatabase(String backupPath) async {
  final dbFolder = await getApplicationDocumentsDirectory();
  final dbFile = File(p.join(dbFolder.path, 'pos_db.sqlite'));

  // Close database first
  await database.close();

  // Restore backup
  final backupFile = File(backupPath);
  await backupFile.copy(dbFile.path);

  // Reopen database
  // App restart recommended
}
```

---

## 🔄 Schema Updates (Future Changes)

When you need to add/modify tables:

1. **Update schema** in `lib/database/pos_database.dart`
2. **Increment `schemaVersion`**
3. **Add migration** in `onUpgrade` method
4. **Regenerate code:** `flutter pub run build_runner build`

Example:

```dart
@override
int get schemaVersion => 2; // Increment version

@override
MigrationStrategy get migration => MigrationStrategy(
  onUpgrade: (Migrator m, int from, int to) async {
    if (from == 1) {
      // Add new column
      await m.addColumn(customers, customers.taxId);
    }
  },
);
```

---

## 🐛 Troubleshooting

### Build Runner Errors

```bash
# Clean and rebuild
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### "Table doesn't exist" Error

The database file might be from an old schema. Delete it:

```bash
# macOS/Linux
rm ~/Documents/pos_db.sqlite

# Windows
del %USERPROFILE%\Documents\pos_db.sqlite
```

### Foreign Key Errors

Ensure parent records exist:
1. Create customer before invoice
2. Create item before adding to invoice
3. Delete child records before parent

---

## 📚 Available Repositories

All repositories are in `lib/repositories/`:

- ✅ **CustomerRepository** - Customer operations
- ✅ **ItemRepository** - Inventory management
- ✅ **InvoiceRepository** - Invoice & payment operations
- ⏳ **SupplierRepository** - (TODO: Create if needed)
- ⏳ **QuotationRepository** - (TODO: Create if needed)
- ⏳ **CreditNoteRepository** - (TODO: Create if needed)

You can create more repositories following the same pattern!

---

## ⚡ Performance Tips

1. **Use indexes** - Already added for common queries
2. **Use transactions** - For multi-step operations
3. **Use streams** - For reactive UI updates
4. **Paginate** - For large lists (implement LIMIT/OFFSET)
5. **Batch inserts** - For bulk data

---

## 🎯 Next Steps

1. ✅ Run `flutter pub get`
2. ✅ Run `flutter pub run build_runner build`
3. ✅ Initialize database in `main.dart`
4. ✅ Use repositories in your controllers
5. ✅ Test CRUD operations
6. ✅ Build your POS features!

---

## 📖 Learn More

- [Drift Documentation](https://drift.simonbinder.eu/)
- [SQL Tutorial](https://www.sqlitetutorial.net/)
- [Flutter Desktop](https://docs.flutter.dev/platform-integration/desktop)

---

## 🎉 You're All Set!

Your POS system now has:
- ✅ Production-ready database
- ✅ Type-safe queries
- ✅ ACID transactions
- ✅ Reactive UI updates
- ✅ Fast performance
- ✅ Easy backup/restore

Start building your features! 🚀
