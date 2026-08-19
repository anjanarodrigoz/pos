# Setup Instructions to Fix Errors

## ⚠️ Important: You MUST run Drift code generation

The database schema has been updated with new tables (ExtraChargeTemplates and CommentTemplates), but the generated Drift code is outdated.

## 🔧 Steps to Fix All Errors:

### 1. Generate Drift Database Code (REQUIRED)

Run this command in your project directory:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This will:
- Generate updated `pos_database.g.dart` file
- Include new ExtraChargeTemplates and CommentTemplates tables
- Update all database queries and methods

**Alternative (if the above fails):**
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 2. Verify the Changes

After code generation completes, verify that:

✅ `lib/database/pos_database.g.dart` has been updated (check file timestamp)
✅ No compilation errors in your IDE
✅ The following classes exist in `pos_database.g.dart`:
   - `ExtraChargeTemplate`
   - `ExtraChargeTemplatesCompanion`
   - `CommentTemplate`
   - `CommentTemplatesCompanion`

### 3. Clean and Rebuild (Optional but Recommended)

If you still see errors after code generation:

```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Run the Application

```bash
flutter run
```

---

## 📋 What Was Changed

### Database Schema (lib/database/pos_database.dart)
- ✅ Added `ExtraChargeTemplates` table (for reusable extra charges)
- ✅ Added `CommentTemplates` table (for reusable comments)
- ✅ Updated schema version from 4 to 5
- ✅ Added migration logic for v4 → v5

### New Repositories
- ✅ `ExtraChargeTemplateRepository` - CRUD operations for extra charge templates
- ✅ `CommentTemplateRepository` - CRUD operations for comment templates
- ✅ Both repositories registered in `main.dart`

### Updated Widgets
- ✅ `ExtraChargeWidget` - Now uses Drift instead of GetStorage
- ✅ `CommentsWidget` - Now uses Drift instead of GetStorage
- ✅ `ItemSelectWidget` - Now uses ItemRepository with Drift

### Item Model Updates
- ✅ Added `itemCode` field (user-facing barcode/SKU)
- ✅ Added `category` field
- ✅ Updated `ItemConverter` to map from Drift to domain model
- ✅ UI now shows itemCode instead of internal ID

---

## 🐛 Common Issues and Solutions

### Issue 1: "The class 'ExtraChargeTemplate' isn't defined"
**Solution:** Run code generation (step 1 above)

### Issue 2: "Get.find<ExtraChargeTemplateRepository>() not found"
**Solution:** This has been fixed! Repositories are now registered in main.dart

### Issue 3: Build runner fails with conflicts
**Solution:** Use `--delete-conflicting-outputs` flag:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue 4: Old errors still showing in IDE
**Solution:**
1. Run code generation
2. Restart your IDE
3. Run `flutter clean` then `flutter pub get`

---

## 📦 Database Migration

When you first run the app after these changes:

1. **Existing data is preserved** - All your invoices, customers, items remain intact
2. **New tables are created** - ExtraChargeTemplates and CommentTemplates tables will be created automatically
3. **Schema version updates** - Database schema version upgrades from 4 to 5

The migration happens automatically when the app starts.

---

## ✅ Expected Result

After following these steps, you should have:

- ✅ No compilation errors
- ✅ Extra charges and comments saved in database (not GetStorage)
- ✅ Templates shared across all invoice types
- ✅ Item Code displayed instead of internal IDs
- ✅ Real-time updates when templates change
- ✅ All repositories properly registered

---

## 🚀 New Features Now Available

1. **Database-Backed Templates**
   - Extra charges and comments persist in SQLite database
   - Faster queries with indexes
   - Better performance

2. **Shared Templates**
   - Templates work across all invoice types:
     - Regular invoices
     - Credit notes
     - Quotations
     - Supplier invoices

3. **User-Facing Item Codes**
   - Users see barcode/SKU (itemCode) instead of database IDs
   - More intuitive item selection
   - Better for scanning workflows

4. **Reactive UI**
   - Changes to templates update immediately across all screens
   - StreamBuilder watches database for changes

---

## 📞 Need Help?

If you encounter any issues after following these steps, check:

1. Flutter version: `flutter --version`
2. Build runner version: `flutter pub deps | grep build_runner`
3. Error logs in the console

Run this to see detailed error information:
```bash
flutter pub run build_runner build --verbose --delete-conflicting-outputs
```
