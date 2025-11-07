import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pos/database/pos_database.dart';
import 'package:pos/repositories/item_repository.dart';
import 'package:pos/theme/app_theme.dart';
import 'package:pos/utils/result.dart';

/// Item detail/edit page with stats and actions
class ItemViewPage extends StatefulWidget {
  final String itemId;

  const ItemViewPage({Key? key, required this.itemId}) : super(key: key);

  @override
  State<ItemViewPage> createState() => _ItemViewPageState();
}

class _ItemViewPageState extends State<ItemViewPage> {
  final ItemRepository _repository = Get.find<ItemRepository>();
  bool _isEditMode = false;
  bool _isLoading = false;

  // Edit controllers
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _barcodeController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _populateControllers(Item item) {
    _nameController.text = item.name;
    _descriptionController.text = item.description ?? '';
    _categoryController.text = item.category ?? '';
    _barcodeController.text = item.barcode ?? '';
    _priceController.text = item.price.toStringAsFixed(2);
    _quantityController.text = item.quantity.toString();
  }

  Future<void> _saveChanges(Item originalItem) async {
    setState(() {
      _isLoading = true;
    });

    // Create updated item with only editable fields
    final updatedItem = Item(
      id: originalItem.id,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      price: double.parse(_priceController.text),
      quantity: int.parse(_quantityController.text),
      category: _categoryController.text.trim().isEmpty
          ? null
          : _categoryController.text.trim(),
      barcode: _barcodeController.text.trim().isEmpty
          ? null
          : _barcodeController.text.trim(),
      // Keep original values for these fields

      isActive: originalItem.isActive,
      createdAt: originalItem.createdAt,
      updatedAt: DateTime.now(),
    );

    final result = await _repository.updateItem(updatedItem);

    setState(() {
      _isLoading = false;
    });

    if (result.isSuccess) {
      setState(() {
        _isEditMode = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Item updated successfully',
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
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result.error?.message ?? 'Failed to update item',
              style: AppTheme.bodyMedium.copyWith(color: Colors.white),
            ),
            backgroundColor: AppTheme.errorColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
          ),
        );
      }
    }
  }

  Future<void> _deleteItem() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Item',
          style: AppTheme.headlineSmall.copyWith(color: AppTheme.textPrimary),
        ),
        content: Text(
          'Are you sure you want to delete this item? If it\'s used in invoices, it will be deactivated instead.',
          style: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: AppTheme.errorButtonStyle(),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isLoading = true;
    });

    final result = await _repository.deleteItem(widget.itemId);

    setState(() {
      _isLoading = false;
    });

    if (result.isSuccess) {
      if (mounted) {
        Navigator.pop(context, 'deleted');
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result.error?.message ?? 'Failed to delete item',
              style: AppTheme.bodyMedium.copyWith(color: Colors.white),
            ),
            backgroundColor: AppTheme.errorColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return StreamBuilder<Item>(
      stream: _repository.watchItem(widget.itemId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: AppTheme.backgroundGrey,
            appBar: AppBar(
              title: Text(
                'Item Details',
                style: AppTheme.headlineMedium
                    .copyWith(color: AppTheme.textPrimary),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: AppTheme.textPrimary),
            ),
            body: const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              ),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            backgroundColor: AppTheme.backgroundGrey,
            appBar: AppBar(
              title: Text(
                'Item Details',
                style: AppTheme.headlineMedium
                    .copyWith(color: AppTheme.textPrimary),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: AppTheme.textPrimary),
            ),
            body: Center(
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
                    'Item not found',
                    style: AppTheme.headlineSmall
                        .copyWith(color: AppTheme.textPrimary),
                  ),
                ],
              ),
            ),
          );
        }

        final item = snapshot.data!;

        if (_isEditMode && _nameController.text.isEmpty) {
          _populateControllers(item);
        }

        return Scaffold(
          backgroundColor: AppTheme.backgroundGrey,
          appBar: AppBar(
            title: Text(
              'Item Details',
              style:
                  AppTheme.headlineMedium.copyWith(color: AppTheme.textPrimary),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: AppTheme.textPrimary),
            actions: [
              if (!_isEditMode)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      _isEditMode = true;
                      _populateControllers(item);
                    });
                  },
                  tooltip: 'Edit',
                ),
              if (!_isEditMode)
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteItem,
                  tooltip: 'Delete',
                ),
              if (_isEditMode)
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _isEditMode = false;
                    });
                  },
                  tooltip: 'Cancel',
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
          body: ListView(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            children: [
              // Item Header
              Container(
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
                padding: const EdgeInsets.all(AppTheme.spacingLg),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight,
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      ),
                      child: const Icon(
                        Icons.inventory_2,
                        color: AppTheme.primaryDark,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: AppTheme.headlineLarge.copyWith(
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingXs),
                          if (item.category != null)
                            Text(
                              item.category!,
                              style: AppTheme.bodyMedium.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: item.isActive
                            ? AppTheme.successColor.withOpacity(0.1)
                            : AppTheme.errorColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      ),
                      child: Text(
                        item.isActive ? 'Active' : 'Inactive',
                        style: AppTheme.labelSmall.copyWith(
                          color: item.isActive
                              ? AppTheme.successColor
                              : AppTheme.errorColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppTheme.spacingMd),

              // Item Statistics
              FutureBuilder<Result<ItemStats>>(
                future: _repository.getItemStats(widget.itemId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || !snapshot.data!.isSuccess) {
                    return const SizedBox.shrink();
                  }

                  final stats = snapshot.data!.data!;

                  return Container(
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
                    padding: const EdgeInsets.all(AppTheme.spacingMd),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildStatItem(
                            'Total Sold',
                            stats.totalSold.toString(),
                            Icons.trending_up,
                            AppTheme.primaryColor,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: AppTheme.dividerColor,
                        ),
                        Expanded(
                          child: _buildStatItem(
                            'Revenue',
                            currencyFormat.format(stats.totalRevenue),
                            Icons.attach_money,
                            AppTheme.successColor,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: AppTheme.dividerColor,
                        ),
                        Expanded(
                          child: _buildStatItem(
                            'In Stock',
                            stats.currentStock.toString(),
                            Icons.inventory,
                            stats.currentStock < 10
                                ? AppTheme.warningColor
                                : AppTheme.successColor,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: AppTheme.spacingLg),

              // Basic Details
              _buildDetailsCard(item),

              const SizedBox(height: AppTheme.spacingLg),

              // Pricing
              _buildPricingCard(item),

              if (_isEditMode) ...[
                const SizedBox(height: AppTheme.spacingXl),
                SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : () => _saveChanges(item),
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.save),
                    label: Text(_isLoading ? 'Saving...' : 'Save Changes'),
                    style: AppTheme.successButtonStyle(),
                  ),
                ),
              ],

              const SizedBox(height: AppTheme.spacingMd),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: AppTheme.spacingXs),
        Text(
          value,
          style: AppTheme.headlineSmall.copyWith(color: color),
        ),
        Text(
          label,
          style: AppTheme.labelSmall.copyWith(color: AppTheme.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDetailsCard(Item item) {
    return Container(
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
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: AppTheme.primaryColor),
              const SizedBox(width: AppTheme.spacingSm),
              Text(
                'Item Details',
                style: AppTheme.headlineSmall
                    .copyWith(color: AppTheme.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),
          const Divider(color: AppTheme.dividerColor),
          const SizedBox(height: AppTheme.spacingMd),
          if (_isEditMode) ...[
            TextField(
              controller: _nameController,
              style: AppTheme.bodyMedium.copyWith(color: AppTheme.textPrimary),
              decoration: AppTheme.inputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            TextField(
              controller: _descriptionController,
              style: AppTheme.bodyMedium.copyWith(color: AppTheme.textPrimary),
              decoration: AppTheme.inputDecoration(labelText: 'Description'),
              maxLines: 2,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            TextField(
              controller: _categoryController,
              style: AppTheme.bodyMedium.copyWith(color: AppTheme.textPrimary),
              decoration: AppTheme.inputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            TextField(
              controller: _barcodeController,
              style: AppTheme.bodyMedium.copyWith(color: AppTheme.textPrimary),
              decoration: AppTheme.inputDecoration(labelText: 'Barcode'),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            TextField(
              controller: _quantityController,
              style: AppTheme.bodyMedium.copyWith(color: AppTheme.textPrimary),
              decoration: AppTheme.inputDecoration(
                labelText: 'Quantity',
                hintText: 'Updated via supply invoices',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ] else ...[
            _buildDetailRow('Description', item.description),
            _buildDetailRow('Category', item.category),
            _buildDetailRow('Barcode', item.barcode),
            _buildDetailRow('Quantity', item.quantity.toString()),
          ],
        ],
      ),
    );
  }

  Widget _buildPricingCard(Item item) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Container(
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
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.payments_outlined, color: AppTheme.primaryColor),
              const SizedBox(width: AppTheme.spacingSm),
              Text(
                'Pricing',
                style: AppTheme.headlineSmall
                    .copyWith(color: AppTheme.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),
          const Divider(color: AppTheme.dividerColor),
          const SizedBox(height: AppTheme.spacingMd),
          if (_isEditMode) ...[
            TextField(
              controller: _priceController,
              style: AppTheme.bodyMedium.copyWith(color: AppTheme.textPrimary),
              decoration: AppTheme.inputDecoration(
                labelText: 'Selling Price',
                hintText: 'Price per unit',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              'Note: Buying price and alternative pricing tiers are managed via supply invoices.',
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.textHint,
                fontStyle: FontStyle.italic,
              ),
            ),
          ] else ...[
            _buildDetailRow('Selling Price', currencyFormat.format(item.price)),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    if (value == null || value.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style:
                  AppTheme.labelMedium.copyWith(color: AppTheme.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.bodyMedium.copyWith(color: AppTheme.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
