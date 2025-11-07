import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos/repositories/item_repository.dart';
import 'package:pos/theme/app_theme.dart';
import 'package:pos/utils/result.dart';

/// Modern item creation form with selling price only
/// Buying price and quantity are set later via supply invoices
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
  final _categoryController = TextEditingController();
  final _barcodeController = TextEditingController();

  // Pricing
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _barcodeController.dispose();
    _priceController.dispose();
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
      quantity: 0, // Start with 0, updated via supply invoice
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
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
              ],
            ),

            SizedBox(height: AppTheme.spacingLg),

            // Pricing Section
            _buildSectionCard(
              title: 'Pricing',
              icon: Icons.payments_outlined,
              children: [
                TextFormField(
                  controller: _priceController,
                  style: AppTheme.bodyMedium.copyWith(color: AppTheme.textPrimary),
                  decoration: AppTheme.inputDecoration(
                    labelText: 'Selling Price *',
                    prefixIcon: const Icon(Icons.attach_money),
                    hintText: 'Enter the selling price per unit',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Selling price is required';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Enter a valid price';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppTheme.spacingSm),
                Text(
                  'Note: Buying price and stock quantity will be set when you create a supply invoice.',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textHint,
                    fontStyle: FontStyle.italic,
                  ),
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
