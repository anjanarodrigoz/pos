import 'package:drift/drift.dart';
import 'package:pos/database/pos_database.dart';
import 'package:pos/services/logger_service.dart';
import 'package:pos/utils/id_generator.dart';
import 'package:pos/utils/result.dart';

/// Repository for item/inventory operations
class ItemRepository {
  final POSDatabase _database;

  ItemRepository(this._database);

  /// Get all items
  Future<Result<List<Item>>> getAllItems({bool activeOnly = false}) async {
    try {
      var query = _database.select(_database.items);

      if (activeOnly) {
        query = query..where((i) => i.isActive.equals(true));
      }

      final items = await query.get();
      return Result.success(items);
    } catch (e, stack) {
      AppLogger.error('Failed to get items', e, stack);
      return Result.failure(AppError.generic('Failed to load items'));
    }
  }

  /// Get single item
  Future<Result<Item>> getItem(String itemId) async {
    try {
      final item = await (_database.select(_database.items)
            ..where((i) => i.id.equals(itemId)))
          .getSingle();

      return Result.success(item);
    } catch (e, stack) {
      AppLogger.error('Failed to get item $itemId', e, stack);
      return Result.failure(AppError.notFound('Item not found'));
    }
  }

  /// Search items by name, description, or item code
  Future<Result<List<Item>>> searchItems(String query) async {
    try {
      final items = await (_database.select(_database.items)
            ..where((i) =>
                i.name.like('%$query%') |
                i.description.like('%$query%') |
                i.itemCode.like('%$query%')))
          .get();

      return Result.success(items);
    } catch (e, stack) {
      AppLogger.error('Failed to search items', e, stack);
      return Result.failure(AppError.generic('Failed to search items'));
    }
  }

  /// Create new item with selling price only
  /// Note: Quantity defaults to 0 and is updated ONLY via supply invoices
  Future<Result<Item>> createItem({
    required String name,
    required String itemCode,
    required double price,
    int quantity = 0,
    String? description,
    String? category,
  }) async {
    try {
      final itemId = IDGenerator.generateItemId();

      final companion = ItemsCompanion.insert(
        id: itemId,
        name: name,
        itemCode: itemCode,
        price: price,
        quantity: Value(quantity),
        description: Value(description),
        category: Value(category),
        // Quantity defaults to 0, updated ONLY via supply invoice
      );

      await _database.into(_database.items).insert(companion);

      final item = await getItem(itemId);
      AppLogger.info('Item created: $itemId - $name');

      return item;
    } catch (e, stack) {
      AppLogger.error('Failed to create item', e, stack);
      return Result.failure(AppError.generic('Failed to create item'));
    }
  }

  /// Update item
  Future<Result<Item>> updateItem(Item item) async {
    try {
      await (_database.update(_database.items)
            ..where((i) => i.id.equals(item.id)))
          .write(item.toCompanion(true));

      final updated = await getItem(item.id);
      AppLogger.info('Item updated: ${item.id}');

      return updated;
    } catch (e, stack) {
      AppLogger.error('Failed to update item ${item.id}', e, stack);
      return Result.failure(AppError.generic('Failed to update item'));
    }
  }

  /// Update stock quantity (with transaction)
  Future<Result<void>> updateStock(String itemId, int quantityChange) async {
    try {
      await _database.updateStockQuantity(itemId, quantityChange);
      AppLogger.info('Stock updated: $itemId by $quantityChange');
      return Result.success(null);
    } catch (e, stack) {
      AppLogger.error('Failed to update stock for $itemId', e, stack);
      return Result.failure(
          AppError.generic('Failed to update stock: ${e.toString()}'));
    }
  }

  /// Delete item (soft delete)
  Future<Result<void>> deleteItem(String itemId) async {
    try {
      // Check if item is used in any invoices
      final usageCount = await (_database.selectOnly(_database.invoiceItems)
            ..addColumns([_database.invoiceItems.id.count()])
            ..where(_database.invoiceItems.itemId.equals(itemId)))
          .getSingle()
          .then((row) => row.read(_database.invoiceItems.id.count()) ?? 0);

      if (usageCount > 0) {
        // Soft delete instead of hard delete
        await (_database.update(_database.items)
              ..where((i) => i.id.equals(itemId)))
            .write(const ItemsCompanion(isActive: Value(false)));

        AppLogger.info('Item deactivated (used in invoices): $itemId');
        return Result.success(null);
      }

      // Hard delete if never used
      await (_database.delete(_database.items)
            ..where((i) => i.id.equals(itemId)))
          .go();

      AppLogger.info('Item deleted: $itemId');
      return Result.success(null);
    } catch (e, stack) {
      AppLogger.error('Failed to delete item $itemId', e, stack);
      return Result.failure(AppError.generic('Failed to delete item'));
    }
  }

  /// Get low stock items
  Future<Result<List<Item>>> getLowStockItems({int threshold = 10}) async {
    try {
      final items = await (_database.select(_database.items)
            ..where((i) => i.quantity.isSmallerThanValue(threshold))
            ..where((i) => i.isActive.equals(true)))
          .get();

      return Result.success(items);
    } catch (e, stack) {
      AppLogger.error('Failed to get low stock items', e, stack);
      return Result.failure(AppError.generic('Failed to get low stock items'));
    }
  }

  /// Get items by category
  Future<Result<List<Item>>> getItemsByCategory(String category) async {
    try {
      final items = await (_database.select(_database.items)
            ..where((i) => i.category.equals(category))
            ..where((i) => i.isActive.equals(true)))
          .get();

      return Result.success(items);
    } catch (e, stack) {
      AppLogger.error('Failed to get items by category', e, stack);
      return Result.failure(AppError.generic('Failed to get items'));
    }
  }

  /// Get all categories
  Future<Result<List<String>>> getAllCategories() async {
    try {
      final result = _database.selectOnly(_database.items, distinct: true)
        ..addColumns([_database.items.category]);

      final rows = await result.get();
      final categories = rows
          .map((row) => row.read(_database.items.category))
          .where((cat) => cat != null)
          .cast<String>()
          .toList();

      return Result.success(categories);
    } catch (e, stack) {
      AppLogger.error('Failed to get categories', e, stack);
      return Result.failure(AppError.generic('Failed to get categories'));
    }
  }

  /// Get item statistics
  Future<Result<ItemStats>> getItemStats(String itemId) async {
    try {
      // Total sold
      final totalSold = await (_database.selectOnly(_database.invoiceItems)
            ..addColumns([_database.invoiceItems.quantity.sum()])
            ..where(_database.invoiceItems.itemId.equals(itemId)))
          .getSingle()
          .then((row) => row.read(_database.invoiceItems.quantity.sum()) ?? 0);

      // Total revenue
      final revenueExpression = _database.invoiceItems.quantity.cast<double>() *
          _database.invoiceItems.netPrice;
      final totalRevenue = await (_database.selectOnly(_database.invoiceItems)
            ..addColumns([revenueExpression.sum()])
            ..where(_database.invoiceItems.itemId.equals(itemId)))
          .getSingle()
          .then((row) => (row.read(revenueExpression.sum()) ?? 0.0));

      // Get current stock
      final item = await getItem(itemId);
      final currentStock = item.isSuccess ? item.data!.quantity : 0;

      return Result.success(
        ItemStats(
          totalSold: totalSold,
          totalRevenue: totalRevenue,
          currentStock: currentStock,
        ),
      );
    } catch (e, stack) {
      AppLogger.error('Failed to get item stats $itemId', e, stack);
      return Result.failure(AppError.generic('Failed to get stats'));
    }
  }

  /// Watch all items (reactive)
  Stream<List<Item>> watchAllItems({bool activeOnly = false}) {
    var query = _database.select(_database.items);

    if (activeOnly) {
      query = query..where((i) => i.isActive.equals(true));
    }

    return query.watch();
  }

  /// Watch single item
  Stream<Item> watchItem(String itemId) {
    return (_database.select(_database.items)
          ..where((i) => i.id.equals(itemId)))
        .watchSingle();
  }
}

class ItemStats {
  final int totalSold;
  final double totalRevenue;
  final int currentStock;

  ItemStats({
    required this.totalSold,
    required this.totalRevenue,
    required this.currentStock,
  });

  double get averagePrice => totalSold > 0 ? totalRevenue / totalSold : 0.0;
}
