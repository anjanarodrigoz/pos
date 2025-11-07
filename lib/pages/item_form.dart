import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos/repositories/item_repository.dart';
import 'package:pos/theme/app_theme.dart';
import 'package:pos/utils/result.dart';

/// Modern item creation/edit form with all pricing fields
class ItemFormPage extends StatefulWidget {
  final String? itemId; // If provided, edit mode; else create mode

  const ItemFormPage({Key? key, this.itemId}) : super(key: key);

  @override
  State<ItemFormPage> createState() => _ItemFormPageState();
}

class _ItemFormPageState extends State<ItemFormPage> {
  final ItemRepository _repository = Get.find<ItemRepository>();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Basic Details
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _commentController = TextEditingController();
  final _categoryController = TextEditingController();
  final _barcodeController = TextEditingController();

  // Pricing
  final _priceController = TextEditingController();
  final _buyingPriceController = TextEditingController(text: '0.00');
  final _priceTwoController = TextEditingController(text: '0.00');
  final _priceThreeController = TextEditingController(text: '0.00');
  final _priceFourController = TextEditingController(text: '0.00');
  final _priceFiveController = TextEditingController(text: '0.00');

  // Inventory
  final _quantityController = TextEditingController(text: '0');

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _commentController.dispose();
    _categoryController.dispose();
    _barcodeController.dispose();
    _priceController.dispose();
    _buyingPriceController.dispose();
    _priceTwoController.dispose();
    _priceThreeController.dispose();
    _priceFourController.dispose();
    _priceFiveController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await _repository.createItem(
      name: _nameController.text.trim(),
      price: double.parse(_priceController.text),
      quantity: int.parse(_quantityController.text),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      comment: _commentController.text.trim().isEmpty
          ? null
          : _commentController.text.trim(),
      buyingPrice: double.tryParse(_buyingPriceController.text) ?? 0.0,
      priceTwo: double.tryParse(_priceTwoController.text) ?? 0.0,
      priceThree: double.tryParse(_priceThreeController.text) ?? 0.0,
      priceFour: double.tryParse(_priceFourController.text) ?? 0.0,
      priceFive: double.tryParse(_priceFiveController.text) ?? 0.0,
      category: _categoryController.text.trim().isEmpty
          ? null
          : _categoryController.text.trim(),
      barcode: _barcodeController.text.trim().isEmpty
          ? null
          : _barcodeController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (result.isSuccess) {
      if (mounted) {
        Navigator.pop(context, true);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result.error?.message ?? 'Failed to save item',
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
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        title: Text(
          widget.itemId == null ? 'New Item' : 'Edit Item',
          style: AppTheme.headlineMedium.copyWith(color: AppTheme.textPrimary),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppTheme.textPrimary),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: AppTheme.borderColor,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          children: [
            // Basic Details Section
            _buildSectionCard(
              title: 'Basic Details',
              icon: Icons.inventory_2_outlined,
              children: [
                TextFormField(
                  controller: _nameController,
                  style: AppTheme.bodyMedium.copyWith(color: AppTheme.textPrimary),
                  decoration: AppTheme.inputDecoration(
                    labelText: 'Item Name *',
                    prefixIcon: const Icon(Icons.label),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Item name is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppTheme.spacingMd),
                TextFormField(
                  controller: _descriptionController,
                  style: AppTheme.bodyMedium.copyWith(color: AppTheme.textPrimary),
                  decoration: AppTheme.inputDecoration(
                    labelText: 'Description',
                    prefixIcon: const Icon(Icons.description),
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: AppTheme.spacingMd),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _categoryController,
                        style: AppTheme.bodyMedium.copyWith(color: AppTheme.textPrimary),
                        decoration: AppTheme.inputDecoration(
                          labelText: 'Category',
                          prefixIcon: const Icon(Icons.category),
                        ),
                      ),
                    ),
                    SizedBox(width: AppTheme.spacingMd),
                    Expanded(
                      child: TextFormField(
                        controller: _barcodeController,
                        style: AppTheme.bodyMedium.copyWith(color: AppTheme.textPrimary),
                        decoration: AppTheme.inputDecoration(
                          labelText: 'Barcode',
                          prefixIcon: const Icon(Icons.qr_code),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacingMd),
                TextFormField(
                  controller: _commentController,
                  style: AppTheme.bodyMedium.copyWith(color: AppTheme.textPrimary),
                  decoration: AppTheme.inputDecoration(
                    labelText: 'Comments',
                    prefixIcon: const Icon(Icons.notes),
                  ),
                  maxLines: 3,
                ),
              ],
            ),

            SizedBox(height: AppTheme.spacingLg),

            // Pricing Section
            _buildSectionCard(
              title: 'Pricing',
              icon: Icons.payments_outlined,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        style: AppTheme.bodyMedium.copyWith(color: AppTheme.textPrimary),
                        decoration: AppTheme.inputDecoration(
                          labelText: 'Selling Price *',
                          prefixIcon: const Icon(Icons.attach_money),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Price is required';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Enter a valid price';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: AppTheme.spacingMd),
                    Expanded(
                      child: TextFormField(
                        controller: _buyingPriceController,
                        style: AppTheme.bodyMedium.copyWith(color: AppTheme.textPrimary),
                        decoration: AppTheme.inputDecoration(
                          labelText: 'Buying Price',
                          prefixIcon: const Icon(Icons.shopping_cart),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacingMd),
                Text(
                  'Alternative Pricing Tiers',
                  style: AppTheme.labelMedium.copyWith(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppTheme.spacingSm),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _priceTwoController,
                        style: AppTheme.bodyMedium.copyWith(color: AppTheme.textPrimary),
                        decoration: AppTheme.inputDecoration(
                          labelText: 'Price 2',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                      ),
                    ),
                    SizedBox(width: AppTheme.spacingMd),
                    Expanded(
                      child: TextFormField(
                        controller: _priceThreeController,
                        style: AppTheme.bodyMedium.copyWith(color: AppTheme.textPrimary),
                        decoration: AppTheme.inputDecoration(
                          labelText: 'Price 3',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacingMd),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _priceFourController,
                        style: AppTheme.bodyMedium.copyWith(color: AppTheme.textPrimary),
                        decoration: AppTheme.inputDecoration(
                          labelText: 'Price 4',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                      ),
                    ),
                    SizedBox(width: AppTheme.spacingMd),
                    Expanded(
                      child: TextFormField(
                        controller: _priceFiveController,
                        style: AppTheme.bodyMedium.copyWith(color: AppTheme.textPrimary),
                        decoration: AppTheme.inputDecoration(
                          labelText: 'Price 5',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: AppTheme.spacingLg),

            // Inventory Section
            _buildSectionCard(
              title: 'Inventory',
              icon: Icons.inventory_outlined,
              children: [
                TextFormField(
                  controller: _quantityController,
                  style: AppTheme.bodyMedium.copyWith(color: AppTheme.textPrimary),
                  decoration: AppTheme.inputDecoration(
                    labelText: 'Initial Quantity',
                    prefixIcon: const Icon(Icons.warehouse),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ],
            ),

            SizedBox(height: AppTheme.spacingXl),

            // Save Button
            SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _saveItem,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(_isLoading ? 'Saving...' : 'Save Item'),
                style: AppTheme.successButtonStyle(),
              ),
            ),

            SizedBox(height: AppTheme.spacingMd),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
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
              Icon(icon, color: AppTheme.primaryColor, size: 24),
              SizedBox(width: AppTheme.spacingSm),
              Text(
                title,
                style: AppTheme.headlineSmall.copyWith(
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppTheme.spacingMd),
          Divider(color: AppTheme.dividerColor),
          SizedBox(height: AppTheme.spacingMd),
          ...children,
        ],
      ),
    );
  }
}
