# Database Migration and Cleanup Plan

## ✅ Completed Migrations (Using Drift Repositories)

### Invoice Module - 100% Complete
- `InvoiceRepository` replaces `InvoiceDB`
- All invoice pages migrated to Drift
- Controller updated to use `InvoiceRepository`

### Customer Module - 100% Complete
- `CustomerRepository` replaces `CustomerDB`
- Customer selection/view pages use Drift

### Item Module - 100% Complete
- `ItemRepository` replaces `ItemDB`
- Item selection page uses Drift

### Supplier Module - 100% Complete
- `SupplierRepository` replaces `SupplierDB`
- Supplier features use Drift

### Supplier Invoice Module - 100% Complete
- `SupplierInvoiceRepository` replaces `SupplierInvoiceDB`
- Supplier invoice features use Drift

---

## 🔄 Pending Migrations (Still Using GetStorage)

### Files Still Using Old DB Services:

1. **lib/controllers/invoice_edit_controller.dart**
   - Uses: `InvoiceDB`, `ItemDB`
   - Status: Can be migrated but edit controller uses CartDB

2. **lib/controllers/report_controller.dart**
   - Uses: `InvoiceDB`, `CustomerDB`, `ItemDB`
   - Status: Reports module not yet migrated

3. **lib/controllers/suppy_invoice_draft_controller.dart**
   - Uses: `InvoiceDB`, `ItemDB`, `SupplierDB`
   - Status: Supplier invoice draft not migrated

4. **lib/widgets/item_select_widget.dart**
   - Uses: `ItemDB`
   - Status: Can migrate to ItemRepository

5. **lib/Pages/payment_manager/payment_pdage.dart**
   - Uses: `InvoiceDB`
   - Status: Payment module not migrated

---

## 🗑️ Files That Can Be Removed AFTER Full Migration

### GetStorage Database Services (Obsolete):
```
❌ lib/database/customer_db_service.dart - Replaced by CustomerRepository
❌ lib/database/invoice_db_service.dart - Replaced by InvoiceRepository
❌ lib/database/item_db_service.dart - Replaced by ItemRepository
❌ lib/database/supplyer_db_service.dart - Replaced by SupplierRepository
❌ lib/database/supplyer_invoice_db_service.dart - Replaced by SupplierInvoiceRepository
```

### Other Obsolete Services:
```
❌ lib/database/commnets_db_service.dart - Comments now stored with invoices in Drift
❌ lib/database/extra_charges_db_service.dart - Extra charges stored with invoices in Drift
```

### Keep for Now (Still Used):
```
✅ lib/database/Cart_db_service.dart - Used for temporary cart (not persistent data)
✅ lib/database/store_db.dart - Store settings
✅ lib/database/user_db_serivce.dart - User authentication
✅ lib/database/quatation_db_serive.dart - Quotations not yet migrated
✅ lib/database/credit_db_serive.dart - Credit notes not yet migrated
✅ lib/database/main_db.dart - Main database interface
✅ lib/database/abstract_db.dart - Abstract interface
```

---

## 📋 Migration Priority Queue

1. **High Priority** (Blocks cleanup):
   - Migrate `invoice_edit_controller.dart` to remove ItemDB dependency
   - Migrate `item_select_widget.dart` to use ItemRepository

2. **Medium Priority**:
   - Migrate Reports module (`report_controller.dart`)
   - Migrate Quotations module
   - Migrate Credit Notes module

3. **Low Priority**:
   - Migrate Supplier Invoice Draft
   - Migrate Payment Manager

---

## 🚀 When Full Migration Complete:

Run this to safely remove obsolete files:
```bash
# Remove obsolete GetStorage database services
rm lib/database/customer_db_service.dart
rm lib/database/invoice_db_service.dart
rm lib/database/item_db_service.dart
rm lib/database/supplyer_db_service.dart
rm lib/database/supplyer_invoice_db_service.dart
rm lib/database/commnets_db_service.dart
rm lib/database/extra_charges_db_service.dart

# Update imports in remaining files
# Search and remove any lingering imports
```

---

## ✅ Current Status

**Invoice Module**: Fully migrated to Drift ✅
**Ready for Removal**: 0 files (wait for complete migration)
**Blocking Issues**: Reports, Quotations, Credit Notes still use GetStorage

---

*Last Updated: 2025-11-14*
