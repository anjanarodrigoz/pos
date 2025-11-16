# Database Migration and Cleanup Plan

## ✅ Completed Migrations (Using Drift Repositories)

### Invoice Module - 100% Complete ✅
- `InvoiceRepository` replaces `InvoiceDB`
- All invoice pages migrated to Drift
- Controllers updated to use `InvoiceRepository`

### Credit Note Module - 100% Complete ✅
- Uses `InvoiceRepository` (stores as invoices with CN- prefix)
- All credit note pages migrated
- Controllers updated

### Quotation Module - 100% Complete ✅
- Uses `InvoiceRepository` (stores as invoices with QUO- prefix)
- All quotation pages migrated
- Controllers updated

### Payment Module - 100% Complete ✅
- Payment page migrated to Drift
- Enum conversion working correctly

### Customer Module - 100% Complete ✅
- `CustomerRepository` replaces `CustomerDB`
- Customer selection/view pages use Drift

### Item Module - 100% Complete ✅
- `ItemRepository` replaces `ItemDB`
- Item selection widget uses Drift
- ItemCode now user-facing identifier

### Supplier Module - 100% Complete ✅
- `SupplierRepository` replaces `SupplierDB`
- Supplier features use Drift

### Template System - 100% Complete ✅
- `ExtraChargeTemplateRepository` replaces `ExtraChargeDB`
- `CommentTemplateRepository` replaces `CommentsDB`
- Templates stored in Drift database

---

## ❌ CANNOT Remove Yet - Still Actively Used

### 1. **ItemDB** (`lib/database/item_db_service.dart`)
**Used by:**
- ✗ `lib/controllers/report_controller.dart` (lines 726, 953, 1002) - Item reports
- ✗ `lib/database/Cart_db_service.dart` - Cart operations
- ✗ `lib/database/supplyer_invoice_db_service.dart` (lines 78, 89) - Supplier invoice stock updates
- ✗ `lib/database/main_db.dart` (line 37) - Backup/restore system

**Must migrate before removal:**
- Update report_controller.dart to use ItemRepository
- Update Cart_db_service.dart to use ItemRepository
- Update supplier invoice operations to use Drift

---

### 2. **InvoiceDB** (`lib/database/invoice_db_service.dart`)
**Used by:**
- ✗ `lib/controllers/invoice_edit_controller.dart` (line 108) - Invoice editing
- ✗ `lib/database/invoice_db_service.dart` (line 69) - Self-reference for delete operations
- ✗ `lib/database/main_db.dart` (line 36) - Backup/restore system

**Must migrate before removal:**
- Update invoice_edit_controller.dart to use InvoiceRepository

---

### 3. **SupplyerInvoiceDB** (`lib/database/supplyer_invoice_db_service.dart`)
**Used by:**
- ✗ `lib/controllers/report_controller.dart` (lines 420, 423, 426, 541, 644, 1062) - Supplier reports
- ✗ `lib/controllers/suppy_invoice_draft_controller.dart` (lines 36, 37, 86) - Supplier invoice creation
- ✗ `lib/database/main_db.dart` (line 40) - Backup/restore system

**Must migrate before removal:**
- Use existing SupplierInvoiceRepository
- Update supplier invoice draft controller
- Update report controller for supplier invoices

---

## ✅ CAN Remove (But Blocked by Backup System)

These are **no longer used** in application logic, but still referenced by backup/restore:

### 4. **CreditNoteDB** (`lib/database/credit_db_serive.dart`)
- ✅ Migrated to InvoiceRepository
- ✗ Still in backup/restore system (main_db.dart line 33)
- **Safe to remove after backup system update**

### 5. **QuotationDB** (`lib/database/quatation_db_serive.dart`)
- ✅ Migrated to InvoiceRepository
- ✗ Still in backup/restore system (main_db.dart line 38)
- **Safe to remove after backup system update**

### 6. **ExtraChargeDB** (`lib/database/extra_charges_db_service.dart`)
- ✅ Migrated to ExtraChargeTemplateRepository
- ✗ Still in backup/restore system (main_db.dart line 35)
- **Safe to remove after backup system update**

### 7. **CommentsDB** (`lib/database/commnets_db_service.dart`)
- ✅ Migrated to CommentTemplateRepository
- ✗ Still in backup/restore system (main_db.dart line 32)
- **Safe to remove after backup system update**

---

## 🔄 Recommended Migration Path

### Phase 1: Migrate Remaining Controllers (1-2 hours)
1. **Update `invoice_edit_controller.dart`**
   - Replace `InvoiceDB()` with `InvoiceRepository`
   - Use Drift for invoice updates

2. **Update `report_controller.dart`**
   - Replace `ItemDB().getAllItems()` with `ItemRepository.getAllItems()`
   - Convert domain Items from Drift Items

3. **Update `Cart_db_service.dart`**
   - Replace `ItemDB()` with `ItemRepository`
   - Update stock management operations

### Phase 2: Migrate Supplier Invoices (2-3 hours)
4. **Update `supplyer_invoice_db_service.dart`**
   - Use existing SupplierInvoiceRepository
   - Update stock operations to use ItemRepository

5. **Update `suppy_invoice_draft_controller.dart`**
   - Replace SupplyerInvoiceDB with SupplierInvoiceRepository

6. **Update `report_controller.dart` (supplier reports)**
   - Use SupplierInvoiceRepository for reports

### Phase 3: Update Backup/Restore (2-3 hours)
7. **Rewrite `main_db.dart`**
   - Export/import directly from SQLite database
   - Use Drift's built-in backup capabilities
   - Remove dependency on AbstractDB services

### Phase 4: Safe Removal (5 minutes)
8. **Delete Old Database Files**

---

## ⚠️ IMPORTANT: Do NOT Remove Yet

**Current Recommendation:** **Keep all old database files for now**

**Reasons:**
1. ✗ 3 controllers still actively use old database services
2. ✗ Backup/restore system depends on them
3. ✗ Removing them would break critical functionality
4. ✗ Risk of data loss

**What CAN be done now:**
- ✅ Continue using the application normally
- ✅ All migrated modules (invoices, credit notes, quotations) work with Drift
- ✅ New data is stored in SQLite (Drift)
- ✅ Old GetStorage data can be manually migrated later

---

## 📊 Migration Progress

### Modules Migrated: 8/11 (73%)
- ✅ Invoices
- ✅ Credit Notes
- ✅ Quotations
- ✅ Payments
- ✅ Customers
- ✅ Items (data layer)
- ✅ Suppliers
- ✅ Templates (Extra Charges & Comments)

### Modules Remaining: 3/11 (27%)
- ❌ Invoice Editing (uses old InvoiceDB)
- ❌ Item Reports (uses old ItemDB)
- ❌ Supplier Invoices (uses old SupplyerInvoiceDB)

### Supporting Systems:
- ❌ Backup/Restore (depends on all old DB services)
- ✅ Cart Operations (uses GetStorage, but this is fine for temporary data)

---

## 🎯 Next Steps - Choose One:

### Option A: Complete Migration (Recommended)
**Time: 5-8 hours total**

Finish migrating all remaining modules, then safely remove old files.

**Benefits:**
- Clean codebase
- Single source of truth (Drift only)
- Better performance
- Easier maintenance

**I can help you with this!**

### Option B: Leave As-Is
Keep old database files indefinitely.

**Benefits:**
- No risk of breaking existing functionality
- Works fine for now

**Downsides:**
- Code duplication
- Confusing for future developers
- Two database systems running in parallel

### Option C: Document Only
Just document which files are obsolete, plan migration for later.

**Benefits:**
- No immediate work required
- Can tackle when time allows

---

## 🚀 When Ready to Clean Up

After **all migrations** complete, run:

```bash
# Verify no usage first
grep -r "InvoiceDB()" lib/
grep -r "ItemDB()" lib/
grep -r "CreditNoteDB()" lib/
grep -r "QuotationDB()" lib/
grep -r "ExtraChargeDB()" lib/
grep -r "CommentsDB()" lib/
grep -r "SupplyerInvoiceDB()" lib/

# If no results, safe to remove
git rm lib/database/credit_db_serive.dart
git rm lib/database/quatation_db_serive.dart
git rm lib/database/extra_charges_db_service.dart
git rm lib/database/commnets_db_service.dart
git rm lib/database/invoice_db_service.dart
git rm lib/database/item_db_service.dart
git rm lib/database/supplyer_invoice_db_service.dart

git commit -m "refactor: Remove obsolete GetStorage database services"
```

---

## ✅ Current Status Summary

**Migrated to Drift:** 73% ✅
- Invoices, Credit Notes, Quotations, Payments, Customers, Items, Suppliers, Templates

**Still on GetStorage:** 27% ❌
- Invoice Editing, Item Reports, Supplier Invoices, Backup System

**Ready for Removal:** 0 files
- **Wait until 100% migrated**

**Recommendation:** Complete remaining migrations before removing any files

---

*Last Updated: 2025-11-16*
*Session: claude/understand-codebase-011CV4DgtS4HWseiavSMPGLC*
