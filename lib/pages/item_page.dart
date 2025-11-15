import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos/database/pos_database.dart';
import 'package:pos/repositories/item_repository.dart';
import 'package:pos/pages/item_form.dart';
import 'package:pos/pages/item_view.dart';
import 'package:pos/Pages/main_window.dart';
import 'package:pos/theme/app_theme.dart';

/// Modern item/stock management page with professional table view
class ItemPage extends StatefulWidget {
  const ItemPage({Key? key}) : super(key: key);

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  final ItemRepository _repository = Get.find<ItemRepository>();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _showInactiveItems = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToMainMenu() {
    Get.offAll(() => const MainWindow());
  }

  void _navigateToAddItem() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ItemFormPage()),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Item created successfully',
            style: AppTheme.bodyMedium.copyWith(color: Colors.white),
          ),
          backgroundColor: AppTheme.successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
        ),
      );
    }
  }

  void _navigateToViewItem(Item item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemViewPage(itemId: item.id),
      ),
    );

    if (result == 'deleted' && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Item deleted successfully',
            style: AppTheme.bodyMedium.copyWith(color: Colors.white),
          ),
          backgroundColor: AppTheme.successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        title: Text(
          'Stock Management',
          style: AppTheme.headlineMedium.copyWith(color: AppTheme.textPrimary),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: _navigateToMainMenu,
          tooltip: 'Back to Main Menu',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingMd,
              vertical: 8,
            ),
            child: ElevatedButton.icon(
              onPressed: _navigateToAddItem,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New Item'),
              style: AppTheme.primaryButtonStyle(),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: AppTheme.borderColor,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar and Filters
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundGrey,
                          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                          border: Border.all(color: AppTheme.borderColor),
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search items by name, description, or item code...',
                            hintStyle: AppTheme.bodyMedium.copyWith(
                              color: AppTheme.textHint,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: AppTheme.textSecondary,
                              size: 20,
                            ),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.clear,
                                      color: AppTheme.textSecondary,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {
                                        _searchQuery = '';
                                      });
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacingMd,
                              vertical: AppTheme.spacingMd,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingSm),
                // Show Inactive Items Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _showInactiveItems,
                      onChanged: (value) {
                        setState(() {
                          _showInactiveItems = value ?? false;
                        });
                      },
                      activeColor: AppTheme.primaryColor,
                    ),
                    Text(
                      'Show inactive items',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Item Table
          Expanded(
            child: StreamBuilder<List<Item>>(
              stream: _repository.watchAllItems(activeOnly: !_showInactiveItems),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.primaryColor,
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: AppTheme.errorColor,
                        ),
                        const SizedBox(height: AppTheme.spacingMd),
                        Text(
                          'Failed to load items',
                          style: AppTheme.headlineSmall.copyWith(
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingSm),
                        Text(
                          snapshot.error.toString(),
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                var items = snapshot.data ?? [];

                // Apply search filter
                if (_searchQuery.isNotEmpty) {
                  final query = _searchQuery.toLowerCase();
                  items = items.where((i) {
                    return i.name.toLowerCase().contains(query) ||
                        (i.description?.toLowerCase().contains(query) ?? false) ||
                        i.itemCode.toLowerCase().contains(query);
                  }).toList();
                }

                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _searchQuery.isEmpty
                              ? Icons.inventory_2_outlined
                              : Icons.search_off,
                          size: 64,
                          color: AppTheme.textHint,
                        ),
                        const SizedBox(height: AppTheme.spacingMd),
                        Text(
                          _searchQuery.isEmpty
                              ? 'No items yet'
                              : 'No items found',
                          style: AppTheme.headlineSmall.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingSm),
                        Text(
                          _searchQuery.isEmpty
                              ? 'Click "New Item" to add your first item'
                              : 'Try a different search term',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.textHint,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Container(
                  margin: const EdgeInsets.all(AppTheme.spacingLg),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    border: Border.all(color: AppTheme.borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Table Header
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingMd,
                          vertical: AppTheme.spacingSm,
                        ),
                        decoration: const BoxDecoration(
                          color: AppTheme.backgroundGrey,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(AppTheme.radiusLg),
                            topRight: Radius.circular(AppTheme.radiusLg),
                          ),
                          border: Border(
                            bottom: BorderSide(color: AppTheme.borderColor),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Item Name',
                                style: AppTheme.labelLarge.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Item Code',
                                style: AppTheme.labelLarge.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Category',
                                style: AppTheme.labelLarge.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Price',
                                style: AppTheme.labelLarge.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Stock',
                                style: AppTheme.labelLarge.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Value',
                                style: AppTheme.labelLarge.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            const SizedBox(width: 60),
                          ],
                        ),
                      ),

                      // Table Body
                      Expanded(
                        child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            final isLast = index == items.length - 1;
                            final stockValue = item.price * item.quantity;
                            final isLowStock = item.quantity < 10;

                            return InkWell(
                              onTap: () => _navigateToViewItem(item),
                              hoverColor: AppTheme.backgroundGrey.withOpacity(0.5),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.spacingMd,
                                  vertical: AppTheme.spacingMd,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: isLast
                                        ? BorderSide.none
                                        : BorderSide(
                                            color: AppTheme.borderColor.withOpacity(0.5),
                                          ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Item Name
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: AppTheme.bodyMedium.copyWith(
                                              color: item.isActive
                                                  ? AppTheme.textPrimary
                                                  : AppTheme.textHint,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          if (item.description != null)
                                            Text(
                                              item.description!,
                                              style: AppTheme.bodySmall.copyWith(
                                                color: AppTheme.textHint,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                        ],
                                      ),
                                    ),

                                    // Item Code
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        item.itemCode,
                                        style: AppTheme.bodySmall.copyWith(
                                          color: AppTheme.textSecondary,
                                          fontFamily: 'monospace',
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    // Category
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        item.category ?? '—',
                                        style: AppTheme.bodySmall.copyWith(
                                          color: item.category != null
                                              ? AppTheme.textSecondary
                                              : AppTheme.textHint,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    // Price
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        currencyFormat.format(item.price),
                                        style: AppTheme.bodySmall.copyWith(
                                          color: AppTheme.textSecondary,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),

                                    // Stock
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isLowStock
                                              ? AppTheme.warningColor.withOpacity(0.1)
                                              : AppTheme.successColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          item.quantity.toString(),
                                          style: AppTheme.labelSmall.copyWith(
                                            color: isLowStock
                                                ? AppTheme.warningColor
                                                : AppTheme.successColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),

                                    // Stock Value
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        currencyFormat.format(stockValue),
                                        style: AppTheme.bodySmall.copyWith(
                                          color: AppTheme.textSecondary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),

                                    // Actions
                                    SizedBox(
                                      width: 60,
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                          color: AppTheme.textSecondary,
                                        ),
                                        onPressed: () => _navigateToViewItem(item),
                                        tooltip: 'View Details',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
