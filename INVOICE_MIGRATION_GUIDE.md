# Invoice Migration Guide: GetStorage → Drift Database

## Overview

This guide documents the migration of the Invoice feature from GetStorage to Drift database, following the same pattern as Customer, Supplier, Item, and Supplier Invoice features.

**Migration Date:** 2025-11-12
**Status:** ✅ Repository Created - Ready for Integration

---

## What Changed?

### Before (GetStorage)
```dart
import 'package:pos/database/invoice_db_service.dart';

final invoiceDB = InvoiceDB();
List<Invoice> invoices = await invoiceDB.getAllInvoices();
```

### After (Drift + Repository Pattern)
```dart
import 'package:pos/repositories/invoice_repository.dart';

final invoiceRepo = Get.find<InvoiceRepository>();
final result = await invoiceRepo.getAllInvoices();

if (result.isSuccess) {
  List<Invoice> invoices = result.data!;
} else {
  // Handle error: result.error
}
```

---

## API Migration Map

### READ Operations

| Old InvoiceDB Method | New InvoiceRepository Method | Notes |
|---------------------|------------------------------|-------|
| `getAllInvoices()` | `getAllInvoices({bool activeOnly, bool? isPaid})` | Returns `Result<List<Invoice>>` with filters |
| `getInvoice(String id)` | `getInvoice(String id)` | Returns `Result<Invoice>` |
| `searchInvoiceByDate(DateTimeRange, paidStatus)` | `searchInvoiceByDate(DateTimeRange, paidStatus)` | Same signature, returns `Result` |
| `getStreamInvoice()` | `watchInvoices({bool activeOnly})` | Stream support with filters |
| N/A | `getInvoicesWithCustomers()` | NEW: JOIN query with customer data |
| N/A | `getFullInvoiceData(String id)` | NEW: Complete invoice with items, payments, charges |
| N/A | `getInvoiceItems(String id)` | NEW: Get items for invoice |
| N/A | `getInvoicePayments(String id)` | NEW: Get payments for invoice |
| N/A | `getInvoiceExtraCharges(String id)` | NEW: Get extra charges |
| N/A | `searchInvoices(String query)` | NEW: Search by ID or customer name |
| N/A | `getCustomerInvoices(String customerId)` | NEW: All invoices for customer |

### CREATE Operations

| Old InvoiceDB Method | New InvoiceRepository Method | Notes |
|---------------------|------------------------------|-------|
| `addInvoice(Invoice)` | `createInvoice({...params})` | More parameters, returns `Result<String>` (invoiceId) |
| `generateInvoiceId()` | `IDGenerator.generateInvoiceId()` | Moved to util class |

### UPDATE Operations

| Old InvoiceDB Method | New InvoiceRepository Method | Notes |
|---------------------|------------------------------|-------|
| `updateInvoice(Invoice)` | `updateInvoice({...params})` | Partial updates supported |
| N/A | `addComment(String id, String comment)` | NEW: Add comment to invoice |

### PAYMENT Operations

| Old InvoiceDB Method | New InvoiceRepository Method | Notes |
|---------------------|------------------------------|-------|
| `addInvoicePayment(Payment, Invoice)` | `addPayment({invoiceId, amount, paymentMethod, ...})` | Returns `Result<String>` (payId) |
| `removeInvoicePayment(invoiceId, paymentId, context)` | `removePayment(invoiceId, paymentId)` | No context needed |
| `generatePayId()` | `IDGenerator.generatePaymentId()` | Moved to util class |

### DELETE Operations

| Old InvoiceDB Method | New InvoiceRepository Method | Notes |
|---------------------|------------------------------|-------|
| `deleteInvoice(Invoice)` | `deleteInvoice(String invoiceId)` | Returns `Result<void>`, handles stock return |

### REPORTING

| Old InvoiceDB Method | New InvoiceRepository Method | Notes |
|---------------------|------------------------------|-------|
| N/A | `getSalesReport({startDate, endDate})` | NEW: Sales analytics |
| N/A | `getStats()` | NEW: Invoice statistics |

### REACTIVE STREAMS

| Old InvoiceDB Method | New InvoiceRepository Method | Notes |
|---------------------|------------------------------|-------|
| `getStreamInvoice()` | `watchInvoices({bool activeOnly})` | Drift streams |
| N/A | `watchInvoice(String id)` | NEW: Watch single invoice |
| N/A | `watchInvoiceItems(String id)` | NEW: Watch invoice items |
| N/A | `watchInvoicePayments(String id)` | NEW: Watch payments |

---

## Code Examples

### Example 1: Get All Invoices

**Before:**
```dart
final invoiceDB = InvoiceDB();
List<Invoice> invoices = await invoiceDB.getAllInvoices();
```

**After:**
```dart
final invoiceRepo = Get.find<InvoiceRepository>();
final result = await invoiceRepo.getAllInvoices(activeOnly: true);

if (result.isSuccess) {
  List<Invoice> invoices = result.data!;
  // Use invoices
} else {
  print('Error: ${result.error?.message}');
}
```

### Example 2: Create Invoice

**Before:**
```dart
final invoice = Invoice(
  invoiceId: invoiceDB.generateInvoiceId(),
  customerId: 'CUST-001',
  customerName: 'John Doe',
  itemList: itemList,
  extraCharges: charges,
  // ... more fields
);

await invoiceDB.addInvoice(invoice);
```

**After:**
```dart
final result = await invoiceRepo.createInvoice(
  customerId: 'CUST-001',
  customerName: 'John Doe',
  items: items.map((item) => InvoiceItemData(
    itemId: item.itemId,
    itemName: item.name,
    quantity: item.qty,
    netPrice: item.netPrice,
    comment: item.comment,
    isPostedItem: item.isPostedItem,
  )).toList(),
  extraCharges: charges?.map((c) => ExtraChargeData(
    description: c.name,
    amount: c.price * c.qty,
  )).toList(),
  customerMobile: '0412345678',
  email: 'john@example.com',
  gstPercentage: 0.1,
  billingAddress: billingAddress?.toJson(),
  shippingAddress: shippingAddress?.toJson(),
  comments: ['Initial comment'],
);

if (result.isSuccess) {
  String invoiceId = result.data!;
  print('Invoice created: $invoiceId');
}
```

### Example 3: Add Payment

**Before:**
```dart
final payment = Payment(
  payId: InvoiceDB.generatePayId(),
  date: DateTime.now(),
  amount: 100.0,
  paymethod: Paymethod.cash,
  comment: 'Payment received',
);

await invoiceDB.addInvoicePayment(payment, invoice);
await InvoiceDB.saveLastPayId(payment.payId);
```

**After:**
```dart
final result = await invoiceRepo.addPayment(
  invoiceId: 'INV-2511-0001',
  amount: 100.0,
  paymentMethod: 'cash',
  comment: 'Payment received',
  date: DateTime.now(),
);

if (result.isSuccess) {
  String payId = result.data!;
  print('Payment added: $payId');
}
```

### Example 4: Search Invoices by Date

**Before:**
```dart
final dateRange = DateTimeRange(
  start: DateTime(2025, 1, 1),
  end: DateTime(2025, 12, 31),
);

List<Invoice> invoices = await invoiceDB.searchInvoiceByDate(
  dateRange,
  ReportPaymentFilter.unpaid,
);
```

**After:**
```dart
final dateRange = DateTimeRange(
  start: DateTime(2025, 1, 1),
  end: DateTime(2025, 12, 31),
);

final result = await invoiceRepo.searchInvoiceByDate(
  dateRange,
  ReportPaymentFilter.unpaid,
);

if (result.isSuccess) {
  List<Invoice> invoices = result.data!;
}
```

### Example 5: Delete Invoice

**Before:**
```dart
final invoice = invoiceDB.getInvoice(invoiceId);
await invoiceDB.deleteInvoice(invoice);
```

**After:**
```dart
final result = await invoiceRepo.deleteInvoice(invoiceId);

if (result.isSuccess) {
  print('Invoice deleted successfully');
} else {
  print('Error: ${result.error?.message}');
}
```

### Example 6: Watch Invoices (Reactive)

**Before:**
```dart
Stream<List<Invoice>> stream = invoiceDB.getStreamInvoice();

stream.listen((invoices) {
  // Update UI
});
```

**After:**
```dart
Stream<List<Invoice>> stream = invoiceRepo.watchInvoices(activeOnly: true);

stream.listen((invoices) {
  // Update UI
});
```

---

## Migration Checklist

### Files That Need Migration

- [ ] `/lib/Pages/invoice_manager/invoice_page.dart`
- [ ] `/lib/Pages/invoice_manager/invoice_edit_page.dart`
- [ ] `/lib/Pages/invoice_manager/save_invoice_page.dart`
- [ ] `/lib/Pages/invoice_manager/search_invoice_page.dart`
- [ ] `/lib/Pages/invoice_draft_manager/invoice_draft_page.dart`
- [ ] `/lib/Pages/invoice_draft_manager/invoice_customer_select.dart`
- [ ] `/lib/controllers/invoice_edit_controller.dart`
- [ ] `/lib/controllers/invoice_draft_contorller.dart`
- [ ] `/lib/controllers/report_controller.dart` (Invoice report queries)
- [ ] `/lib/Pages/payment_manager/payment_pdage.dart`
- [ ] Any other files importing `invoice_db_service.dart`

### Migration Steps

1. ✅ **Create InvoiceRepository** with all InvoiceDB methods
2. ✅ **Register in GetX** (already done in main.dart:74)
3. ⏳ **Update Import Statements**
   ```dart
   // Remove:
   import 'package:pos/database/invoice_db_service.dart';

   // Add:
   import 'package:pos/repositories/invoice_repository.dart';
   ```

4. ⏳ **Replace GetX Service Locator**
   ```dart
   // Remove:
   final invoiceDB = InvoiceDB();

   // Add:
   final invoiceRepo = Get.find<InvoiceRepository>();
   ```

5. ⏳ **Update Method Calls** using the API map above

6. ⏳ **Handle Result Type**
   - All repository methods return `Result<T>`
   - Check `result.isSuccess` before accessing `result.data`
   - Handle errors with `result.error`

7. ⏳ **Test Each Feature**
   - Create invoice
   - View invoice
   - Edit invoice
   - Add payment
   - Remove payment
   - Delete invoice
   - Search invoices
   - Generate reports

8. ⏳ **Remove Old Code**
   - Delete or deprecate `invoice_db_service.dart`
   - Remove GetStorage references

---

## Key Differences

### 1. Result Type Pattern
All repository methods return `Result<T>` for type-safe error handling:
```dart
final result = await invoiceRepo.getInvoice(invoiceId);

result.fold(
  (error) => print('Error: ${error.message}'),
  (invoice) => print('Success: ${invoice.invoiceId}'),
);
```

### 2. Drift Table Models
The Drift database returns `Invoice` objects from the Drift schema, not the old model class. Key differences:
- Drift `Invoice` fields match the Invoices table schema
- JSON fields: `commentsJson`, `billingAddressJson`, `shippingAddressJson`
- No computed properties (like `toPay`, `outstandingDates`)
- Need to calculate totals from invoice + items + payments

### 3. Separate Item/Payment/Charge Queries
Unlike GetStorage where everything was in one JSON object:
```dart
// Get complete invoice data
final fullData = await invoiceRepo.getFullInvoiceData(invoiceId);

// Or get separately
final invoice = await invoiceRepo.getInvoice(invoiceId);
final items = await invoiceRepo.getInvoiceItems(invoiceId);
final payments = await invoiceRepo.getInvoicePayments(invoiceId);
final charges = await invoiceRepo.getInvoiceExtraCharges(invoiceId);
```

### 4. No Context Required
Old InvoiceDB methods often required `BuildContext`. The new repository doesn't need it.

### 5. Automatic Stock Management
When deleting an invoice, the repository automatically returns items to stock.

---

## Helper Classes

### InvoiceItemData
Used when creating invoices:
```dart
InvoiceItemData(
  itemId: 'ITM-001',
  itemName: 'Product Name',
  quantity: 5,
  netPrice: 100.0,
  comment: 'Optional comment',
  isPostedItem: false,
)
```

### ExtraChargeData
Used for extra charges:
```dart
ExtraChargeData(
  description: 'Shipping fee',
  amount: 15.0,
)
```

### InvoiceStats
Returned by `getStats()`:
```dart
class InvoiceStats {
  final int totalInvoices;
  final double totalAmount;
  final double unpaidAmount;
  final double outstandingAmount;
  double get paidAmount => totalAmount - unpaidAmount;
}
```

---

## Testing

### Unit Test Example
```dart
void main() {
  late POSDatabase database;
  late InvoiceRepository repository;

  setUp(() {
    database = POSDatabase(); // Use in-memory for tests
    repository = InvoiceRepository(database);
  });

  test('should create invoice successfully', () async {
    final result = await repository.createInvoice(
      customerId: 'CUST-001',
      customerName: 'Test Customer',
      items: [
        InvoiceItemData(
          itemId: 'ITM-001',
          itemName: 'Test Item',
          quantity: 1,
          netPrice: 100.0,
        ),
      ],
    );

    expect(result.isSuccess, true);
    expect(result.data, isNotNull);
  });
}
```

---

## Troubleshooting

### Issue 1: "Cannot find InvoiceRepository"
**Solution:** Make sure you're using `Get.find<InvoiceRepository>()` and that it's registered in `main.dart`.

### Issue 2: "Result type is not handled"
**Solution:** All methods return `Result<T>`. Check `result.isSuccess` before accessing data:
```dart
if (result.isSuccess) {
  var data = result.data!;
} else {
  print(result.error?.message);
}
```

### Issue 3: "Invoice model doesn't have field X"
**Solution:** Drift `Invoice` model is different from old model. Use helper methods:
- `getInvoiceItems()` for items
- `getInvoicePayments()` for payments
- Calculate `toPay` = `invoice.total - invoice.paidAmount`

### Issue 4: "Database not initialized"
**Solution:** Ensure `main.dart` initializes the database before using repositories.

---

## Benefits of Migration

✅ **Type Safety** - Compile-time validation of SQL queries
✅ **Better Performance** - Indexed queries, efficient JOINs
✅ **Atomic Transactions** - Invoice + items + charges created together
✅ **Reactive Streams** - Real-time UI updates with `.watch()`
✅ **Error Handling** - Result type for consistent error management
✅ **Scalability** - Relational data model scales better
✅ **Testability** - Easy to mock repository interface
✅ **Maintainability** - Clean architecture pattern

---

## Support

For questions or issues with the migration:
1. Check this guide for API mappings
2. Review `customer_repository.dart` for working examples
3. Review `supplier_invoice_repository.dart` for similar patterns
4. Check Drift documentation: https://drift.simonbinder.eu/

---

**Migration Status:** Repository created ✅ | Integration pending ⏳
