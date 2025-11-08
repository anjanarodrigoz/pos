import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos/database/pos_database.dart';
import 'package:pos/repositories/supplier_repository.dart';
import 'package:pos/repositories/supplier_invoice_repository.dart';
import 'package:pos/repositories/item_repository.dart';
import 'package:pos/theme/app_theme.dart';
import 'package:pos/utils/my_format.dart';
import 'package:pos/utils/alert_message.dart';
import 'package:pos/utils/val.dart';

/// Supplier invoice creation page with invoice grid layout
class SupplyInvoiceCreatePage extends StatefulWidget {
  final bool isReturnNote;

  const SupplyInvoiceCreatePage({
    Key? key,
    this.isReturnNote = false,
  }) : super(key: key);

  @override
  State<SupplyInvoiceCreatePage> createState() => _SupplyInvoiceCreatePageState();
}

class _SupplyInvoiceCreatePageState extends State<SupplyInvoiceCreatePage> {
  final SupplierRepository _supplierRepository = Get.find<SupplierRepository>();
  final SupplierInvoiceRepository _invoiceRepository = Get.find<SupplierInvoiceRepository>();
  final ItemRepository _itemRepository = Get.find<ItemRepository>();

  Supplier? _selectedSupplier;
  final List<InvoiceItemEntry> _items = [];
  final List<ExtraChargeEntry> _extraCharges = [];
  final List<String> _comments = [];

  double _itemsTotal = 0.0;
  double _extraChargesTotal = 0.0;
  double _netTotal = 0.0;
  double _gstTotal = 0.0;
  double _grandTotal = 0.0;

  bool _isSaving = false;

  void _calculateTotals() {
    setState(() {
      _itemsTotal = _items.fold(0.0, (sum, item) => sum + item.totalPrice);
      _extraChargesTotal = _extraCharges.fold(0.0, (sum, charge) => sum + charge.amount);
      _netTotal = _items.fold(0.0, (sum, item) => sum + item.netTotal) + _extraChargesTotal;
      _gstTotal = _items.fold(0.0, (sum, item) => sum + item.gstTotal);
      _grandTotal = _itemsTotal + _extraChargesTotal;
    });
  }

  Future<void> _selectSupplier() async {
    final result = await _supplierRepository.getAllSuppliers(activeOnly: true);

    if (!result.isSuccess || result.data!.isEmpty) {
      if (mounted) {
        AlertMessage.snakMessage('No suppliers available', context);
      }
      return;
    }

    final selected = await showDialog<Supplier>(
      context: context,
      builder: (context) => _SupplierSelectionDialog(suppliers: result.data!),
    );

    if (selected != null) {
      setState(() {
        _selectedSupplier = selected;
      });
    }
  }

  Future<void> _addItem() async {
    final result = await _itemRepository.getAllItems(activeOnly: true);

    if (!result.isSuccess || result.data!.isEmpty) {
      if (mounted) {
        AlertMessage.snakMessage('No items available', context);
      }
      return;
    }

    final selected = await showDialog<Item>(
      context: context,
      builder: (context) => _ItemSelectionDialog(items: result.data!),
    );

    if (selected != null) {
      _showItemQuantityDialog(selected);
    }
  }

  void _showItemQuantityDialog(Item item, {InvoiceItemEntry? existingItem, int? editIndex}) {
    final quantityController = TextEditingController(text: existingItem?.quantity.toString() ?? '1');
    final priceWithoutGstController = TextEditingController(text: existingItem?.netPrice.toStringAsFixed(2) ?? '');
    final priceWithGstController = TextEditingController();
    final commentController = TextEditingController(text: existingItem?.comment ?? '');

    // Initialize price with GST if existing item
    if (existingItem != null) {
      priceWithGstController.text = existingItem.itemPrice.toStringAsFixed(2);
    }

    bool _updatingPrice = false;

    void _updatePriceWithGst() {
      if (_updatingPrice) return;
      _updatingPrice = true;

      final priceWithoutGst = double.tryParse(priceWithoutGstController.text) ?? 0.0;
      if (priceWithoutGst > 0) {
        final priceWithGst = priceWithoutGst * (1 + Val.gstPrecentage);
        priceWithGstController.text = priceWithGst.toStringAsFixed(2);
      }

      _updatingPrice = false;
    }

    void _updatePriceWithoutGst() {
      if (_updatingPrice) return;
      _updatingPrice = true;

      final priceWithGst = double.tryParse(priceWithGstController.text) ?? 0.0;
      if (priceWithGst > 0) {
        final priceWithoutGst = priceWithGst / (1 + Val.gstPrecentage);
        priceWithoutGstController.text = priceWithoutGst.toStringAsFixed(2);
      }

      _updatingPrice = false;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.name),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: AppTheme.inputDecoration(labelText: 'Quantity'),
              ),
              const SizedBox(height: AppTheme.spacingMd),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: priceWithoutGstController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                      ],
                      onChanged: (_) => _updatePriceWithGst(),
                      decoration: AppTheme.inputDecoration(
                        labelText: 'Price (without GST)',
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingMd),
                  Expanded(
                    child: TextField(
                      controller: priceWithGstController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                      ],
                      onChanged: (_) => _updatePriceWithoutGst(),
                      decoration: AppTheme.inputDecoration(
                        labelText: 'Price (with GST)',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingMd),
              TextField(
                controller: commentController,
                maxLines: 2,
                decoration: AppTheme.inputDecoration(labelText: 'Comment (optional)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final quantity = int.tryParse(quantityController.text) ?? 0;
              final netPrice = double.tryParse(priceWithoutGstController.text) ?? 0.0;

              if (quantity > 0 && netPrice > 0) {
                final newItem = InvoiceItemEntry(
                  itemId: item.id,
                  itemCode: item.itemCode,
                  itemName: item.name,
                  quantity: quantity,
                  netPrice: netPrice,
                  comment: commentController.text.isEmpty ? null : commentController.text,
                );

                setState(() {
                  if (editIndex != null) {
                    _items[editIndex] = newItem;
                  } else {
                    _items.add(newItem);
                  }
                });
                _calculateTotals();
                Navigator.pop(context);
              } else {
                AlertMessage.snakMessage('Please enter valid quantity and price', context);
              }
            },
            child: Text(editIndex != null ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  void _editItem(int index) {
    final item = _items[index];
    _itemRepository.getItem(item.itemId).then((result) {
      if (result.isSuccess && mounted) {
        _showItemQuantityDialog(result.data!, existingItem: item, editIndex: index);
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
    _calculateTotals();
  }

  void _addExtraCharge({ExtraChargeEntry? existingCharge, int? editIndex}) {
    final descriptionController = TextEditingController(text: existingCharge?.description ?? '');
    final amountController = TextEditingController(text: existingCharge?.amount.toStringAsFixed(2) ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(editIndex != null ? 'Edit Extra Charge' : 'Add Extra Charge'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descriptionController,
                decoration: AppTheme.inputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: AppTheme.spacingMd),
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                decoration: AppTheme.inputDecoration(labelText: 'Amount'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final description = descriptionController.text;
              final amount = double.tryParse(amountController.text) ?? 0.0;

              if (description.isNotEmpty && amount > 0) {
                setState(() {
                  if (editIndex != null) {
                    _extraCharges[editIndex] = ExtraChargeEntry(
                      description: description,
                      amount: amount,
                    );
                  } else {
                    _extraCharges.add(ExtraChargeEntry(
                      description: description,
                      amount: amount,
                    ));
                  }
                });
                _calculateTotals();
                Navigator.pop(context);
              } else {
                AlertMessage.snakMessage('Please enter valid description and amount', context);
              }
            },
            child: Text(editIndex != null ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  void _removeExtraCharge(int index) {
    setState(() {
      _extraCharges.removeAt(index);
    });
    _calculateTotals();
  }

  void _addComment({String? existingComment, int? editIndex}) {
    final commentController = TextEditingController(text: existingComment ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(editIndex != null ? 'Edit Comment' : 'Add Comment'),
        content: TextField(
          controller: commentController,
          maxLines: 3,
          decoration: AppTheme.inputDecoration(labelText: 'Comment'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final comment = commentController.text;
              if (comment.isNotEmpty) {
                setState(() {
                  if (editIndex != null) {
                    _comments[editIndex] = comment;
                  } else {
                    _comments.add(comment);
                  }
                });
                Navigator.pop(context);
              }
            },
            child: Text(editIndex != null ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  void _removeComment(int index) {
    setState(() {
      _comments.removeAt(index);
    });
  }

  Future<void> _saveInvoice() async {
    if (_selectedSupplier == null) {
      AlertMessage.snakMessage('Please select a supplier', context);
      return;
    }

    if (_items.isEmpty) {
      AlertMessage.snakMessage('Please add at least one item', context);
      return;
    }

    setState(() => _isSaving = true);

    final result = await _invoiceRepository.createInvoice(
      supplierId: _selectedSupplier!.id,
      supplierName: '${_selectedSupplier!.firstName} ${_selectedSupplier!.lastName}',
      supplierMobile: _selectedSupplier!.mobileNumber,
      supplierEmail: _selectedSupplier!.email,
      items: _items.map((item) => InvoiceItemData(
        itemId: item.itemId,
        itemName: item.itemName,
        quantity: item.quantity,
        buyingPrice: item.netPrice,
        comment: item.comment,
      )).toList(),
      gstPercentage: Val.gstPrecentage,
      extraCharges: _extraCharges.isEmpty ? null : _extraCharges.map((e) => ExtraChargeData(
        description: e.description,
        amount: e.amount,
      )).toList(),
      comments: _comments.isEmpty ? null : _comments,
      isReturnNote: widget.isReturnNote,
    );

    if (result.isSuccess) {
      final invoice = result.data!;
      await _invoiceRepository.markAsPaid(invoice.invoiceId, true);
    }

    setState(() => _isSaving = false);

    if (mounted) {
      if (result.isSuccess) {
        AlertMessage.snakMessage(
          widget.isReturnNote ? 'Return note created successfully' : 'Invoice created and marked as paid',
          context,
        );
        Navigator.pop(context, true);
      } else {
        AlertMessage.snakMessage(
          result.error?.message ?? 'Failed to create invoice',
          context,
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
          widget.isReturnNote ? 'New Return Note' : 'New Supplier Invoice',
          style: AppTheme.headlineMedium.copyWith(color: AppTheme.textPrimary),
        ),
        backgroundColor: AppTheme.cardBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: AppTheme.textPrimary),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppTheme.borderColor),
        ),
      ),
      body: Row(
        children: [
          // Left sidebar with action buttons
          _buildLeftSidebar(),

          // Main invoice display area
          Expanded(
            child: _buildInvoiceDisplay(),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftSidebar() {
    return Container(
      width: 250,
      color: AppTheme.cardBackground,
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Actions',
            style: AppTheme.headlineSmall.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),

          // Supplier Section
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            decoration: BoxDecoration(
              color: AppTheme.backgroundGrey,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Supplier',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingSm),
                if (_selectedSupplier != null) ...[
                  Text(
                    '${_selectedSupplier!.firstName} ${_selectedSupplier!.lastName}',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    _selectedSupplier!.id,
                    style: AppTheme.bodyXSmall.copyWith(
                      color: AppTheme.textSecondary,
                      fontFamily: 'monospace',
                    ),
                  ),
                ] else
                  Text(
                    'Not selected',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: AppTheme.spacingMd),

          ElevatedButton.icon(
            onPressed: _selectSupplier,
            icon: const Icon(Icons.person_add, size: 18),
            label: Text(_selectedSupplier == null ? 'Add Supplier' : 'Change Supplier'),
            style: AppTheme.primaryButtonStyle().copyWith(
              padding: const MaterialStatePropertyAll(
                EdgeInsets.symmetric(vertical: AppTheme.spacingMd),
              ),
            ),
          ),

          const SizedBox(height: AppTheme.spacingSm),

          ElevatedButton.icon(
            onPressed: _addItem,
            icon: const Icon(Icons.add_shopping_cart, size: 18),
            label: const Text('Add Item'),
            style: AppTheme.secondaryButtonStyle().copyWith(
              padding: const MaterialStatePropertyAll(
                EdgeInsets.symmetric(vertical: AppTheme.spacingMd),
              ),
            ),
          ),

          const SizedBox(height: AppTheme.spacingSm),

          ElevatedButton.icon(
            onPressed: () => _addExtraCharge(),
            icon: const Icon(Icons.attach_money, size: 18),
            label: const Text('Extra Charges'),
            style: AppTheme.secondaryButtonStyle().copyWith(
              padding: const MaterialStatePropertyAll(
                EdgeInsets.symmetric(vertical: AppTheme.spacingMd),
              ),
            ),
          ),

          const SizedBox(height: AppTheme.spacingSm),

          ElevatedButton.icon(
            onPressed: () => _addComment(),
            icon: const Icon(Icons.comment, size: 18),
            label: const Text('Comment'),
            style: AppTheme.secondaryButtonStyle().copyWith(
              padding: const MaterialStatePropertyAll(
                EdgeInsets.symmetric(vertical: AppTheme.spacingMd),
              ),
            ),
          ),

          const Spacer(),

          // Totals summary
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            decoration: BoxDecoration(
              color: AppTheme.backgroundGrey,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Column(
              children: [
                _buildSidebarTotal('Subtotal', _netTotal),
                _buildSidebarTotal('GST', _gstTotal),
                const Divider(),
                _buildSidebarTotal('Total', _grandTotal, isTotal: true),
              ],
            ),
          ),

          const SizedBox(height: AppTheme.spacingMd),

          ElevatedButton.icon(
            onPressed: _isSaving ? null : _saveInvoice,
            icon: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.save, size: 18),
            label: Text(_isSaving ? 'Saving...' : 'Save Invoice'),
            style: AppTheme.primaryButtonStyle().copyWith(
              padding: const MaterialStatePropertyAll(
                EdgeInsets.symmetric(vertical: AppTheme.spacingMd),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarTotal(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            MyFormat.formatCurrency(amount),
            style: (isTotal ? AppTheme.bodyMedium : AppTheme.bodySmall).copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceDisplay() {
    return Container(
      color: AppTheme.cardBackground,
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Invoice header
          _buildInvoiceHeader(),

          const SizedBox(height: AppTheme.spacingLg),

          // Unified invoice table
          Expanded(
            child: SingleChildScrollView(
              child: _buildUnifiedInvoiceTable(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceHeader() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      decoration: BoxDecoration(
        color: AppTheme.backgroundGrey,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.isReturnNote ? 'RETURN NOTE' : 'SUPPLIER INVOICE',
            style: AppTheme.headlineMedium.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppTheme.spacingMd),
          if (_selectedSupplier != null) ...[
            Text(
              'Supplier: ${_selectedSupplier!.firstName} ${_selectedSupplier!.lastName}',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              'Supplier ID: ${_selectedSupplier!.id}',
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.textSecondary,
                fontFamily: 'monospace',
              ),
            ),
            if (_selectedSupplier!.mobileNumber != null)
              Text(
                'Mobile: ${_selectedSupplier!.mobileNumber}',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
          ] else
            Text(
              'No supplier selected',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.errorColor,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUnifiedInvoiceTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.borderColor),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingMd,
              vertical: AppTheme.spacingSm,
            ),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppTheme.radiusMd),
                topRight: Radius.circular(AppTheme.radiusMd),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text('Item Code', style: _tableHeaderStyle()),
                ),
                Expanded(
                  flex: 3,
                  child: Text('Item Name', style: _tableHeaderStyle()),
                ),
                Expanded(
                  flex: 1,
                  child: Text('Qty', style: _tableHeaderStyle(), textAlign: TextAlign.center),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Net Price', style: _tableHeaderStyle(), textAlign: TextAlign.right),
                ),
                Expanded(
                  flex: 2,
                  child: Text('GST Price', style: _tableHeaderStyle(), textAlign: TextAlign.right),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Item Price', style: _tableHeaderStyle(), textAlign: TextAlign.right),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Total Price', style: _tableHeaderStyle(), textAlign: TextAlign.right),
                ),
                const SizedBox(width: 80), // Actions column
              ],
            ),
          ),

          // Table rows - Items, Extra Charges, Comments in one unified table
          if (_items.isEmpty && _extraCharges.isEmpty && _comments.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingXl),
              child: Text(
                'No items added yet. Click "Add Item" to start.',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            ...[
              // Items section
              ..._items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingMd,
                        vertical: AppTheme.spacingSm,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppTheme.borderColor),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              item.itemCode,
                              style: _tableCellStyle().copyWith(fontFamily: 'monospace'),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(item.itemName, style: _tableCellStyle()),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              item.quantity.toString(),
                              style: _tableCellStyle(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              MyFormat.formatCurrency(item.netPrice),
                              style: _tableCellStyle(),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              MyFormat.formatCurrency(item.gstPrice),
                              style: _tableCellStyle(),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              MyFormat.formatCurrency(item.itemPrice),
                              style: _tableCellStyle(),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              MyFormat.formatCurrency(item.totalPrice),
                              style: _tableCellStyle().copyWith(fontWeight: FontWeight.w600),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, size: 18, color: AppTheme.primaryColor),
                                  onPressed: () => _editItem(index),
                                  tooltip: 'Edit',
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                                const SizedBox(width: 4),
                                IconButton(
                                  icon: Icon(Icons.delete, size: 18, color: AppTheme.errorColor),
                                  onPressed: () => _removeItem(index),
                                  tooltip: 'Delete',
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (item.comment != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingLg,
                          vertical: AppTheme.spacingSm,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundGrey.withOpacity(0.3),
                          border: Border(
                            top: BorderSide(color: AppTheme.borderColor.withOpacity(0.5)),
                          ),
                        ),
                        child: Text(
                          'Comment: ${item.comment}',
                          style: AppTheme.bodyXSmall.copyWith(
                            color: AppTheme.textSecondary,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                );
              }).toList(),

              // Extra charges section
              ..._extraCharges.asMap().entries.map((entry) {
                final index = entry.key;
                final charge = entry.value;
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingMd,
                    vertical: AppTheme.spacingSm,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.warningColor.withOpacity(0.05),
                    border: Border(
                      top: BorderSide(color: AppTheme.borderColor),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Icon(Icons.add_circle_outline, color: AppTheme.warningColor, size: 16),
                            const SizedBox(width: 4),
                            Text('Extra Charge', style: _tableCellStyle().copyWith(color: AppTheme.warningColor)),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(charge.description, style: _tableCellStyle()),
                      ),
                      Expanded(flex: 1, child: const SizedBox()),
                      Expanded(flex: 2, child: const SizedBox()),
                      Expanded(flex: 2, child: const SizedBox()),
                      Expanded(flex: 2, child: const SizedBox()),
                      Expanded(
                        flex: 2,
                        child: Text(
                          MyFormat.formatCurrency(charge.amount),
                          style: _tableCellStyle().copyWith(fontWeight: FontWeight.w600),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, size: 18, color: AppTheme.primaryColor),
                              onPressed: () => _addExtraCharge(existingCharge: charge, editIndex: index),
                              tooltip: 'Edit',
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              icon: Icon(Icons.delete, size: 18, color: AppTheme.errorColor),
                              onPressed: () => _removeExtraCharge(index),
                              tooltip: 'Delete',
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),

              // Comments section
              ..._comments.asMap().entries.map((entry) {
                final index = entry.key;
                final comment = entry.value;
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingMd,
                    vertical: AppTheme.spacingSm,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.infoColor.withOpacity(0.05),
                    border: Border(
                      top: BorderSide(color: AppTheme.borderColor),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Icon(Icons.comment_outlined, color: AppTheme.infoColor, size: 16),
                            const SizedBox(width: 4),
                            Text('Comment', style: _tableCellStyle().copyWith(color: AppTheme.infoColor)),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 12,
                        child: Text(comment, style: _tableCellStyle()),
                      ),
                      SizedBox(
                        width: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, size: 18, color: AppTheme.primaryColor),
                              onPressed: () => _addComment(existingComment: comment, editIndex: index),
                              tooltip: 'Edit',
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              icon: Icon(Icons.delete, size: 18, color: AppTheme.errorColor),
                              onPressed: () => _removeComment(index),
                              tooltip: 'Delete',
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
        ],
      ),
    );
  }

  TextStyle _tableHeaderStyle() {
    return AppTheme.bodySmall.copyWith(
      color: AppTheme.textPrimary,
      fontWeight: FontWeight.w700,
    );
  }

  TextStyle _tableCellStyle() {
    return AppTheme.bodySmall.copyWith(
      color: AppTheme.textPrimary,
    );
  }
}

// Supplier selection dialog with search
class _SupplierSelectionDialog extends StatefulWidget {
  final List<Supplier> suppliers;

  const _SupplierSelectionDialog({required this.suppliers});

  @override
  State<_SupplierSelectionDialog> createState() => _SupplierSelectionDialogState();
}

class _SupplierSelectionDialogState extends State<_SupplierSelectionDialog> {
  String _searchQuery = '';

  List<Supplier> get _filteredSuppliers {
    if (_searchQuery.isEmpty) return widget.suppliers;
    final query = _searchQuery.toLowerCase();
    return widget.suppliers.where((s) {
      return s.firstName.toLowerCase().contains(query) ||
          s.lastName.toLowerCase().contains(query) ||
          s.id.toLowerCase().contains(query) ||
          (s.mobileNumber?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 700,
        height: 500,
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        color: AppTheme.cardBackground,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Supplier',
                  style: AppTheme.headlineMedium.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              autofocus: true,
              decoration: AppTheme.inputDecoration(
                labelText: 'Search suppliers...',
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredSuppliers.length,
                itemBuilder: (context, index) {
                  final supplier = _filteredSuppliers[index];
                  return InkWell(
                    onTap: () => Navigator.pop(context, supplier),
                    child: Container(
                      padding: const EdgeInsets.all(AppTheme.spacingMd),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: AppTheme.borderColor),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${supplier.firstName} ${supplier.lastName}',
                                  style: AppTheme.bodyMedium.copyWith(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  supplier.id,
                                  style: AppTheme.bodySmall.copyWith(
                                    color: AppTheme.textSecondary,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (supplier.mobileNumber != null)
                            Text(
                              supplier.mobileNumber!,
                              style: AppTheme.bodySmall.copyWith(
                                color: AppTheme.textSecondary,
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
      ),
    );
  }
}

// Item selection dialog with search
class _ItemSelectionDialog extends StatefulWidget {
  final List<Item> items;

  const _ItemSelectionDialog({required this.items});

  @override
  State<_ItemSelectionDialog> createState() => _ItemSelectionDialogState();
}

class _ItemSelectionDialogState extends State<_ItemSelectionDialog> {
  String _searchQuery = '';

  List<Item> get _filteredItems {
    if (_searchQuery.isEmpty) return widget.items;
    final query = _searchQuery.toLowerCase();
    return widget.items.where((i) {
      return i.name.toLowerCase().contains(query) ||
          i.itemCode.toLowerCase().contains(query) ||
          (i.category?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 700,
        height: 500,
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        color: AppTheme.cardBackground,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Item',
                  style: AppTheme.headlineMedium.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              autofocus: true,
              decoration: AppTheme.inputDecoration(
                labelText: 'Search items...',
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  final item = _filteredItems[index];
                  return InkWell(
                    onTap: () => Navigator.pop(context, item),
                    child: Container(
                      padding: const EdgeInsets.all(AppTheme.spacingMd),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: AppTheme.borderColor),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: AppTheme.bodyMedium.copyWith(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  item.itemCode,
                                  style: AppTheme.bodySmall.copyWith(
                                    color: AppTheme.textSecondary,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Stock: ${item.quantity}',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.textSecondary,
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
      ),
    );
  }
}

// Helper class for invoice item
class InvoiceItemEntry {
  final String itemId;
  final String itemCode;
  final String itemName;
  final int quantity;
  final double netPrice; // Price without GST
  final String? comment;

  InvoiceItemEntry({
    required this.itemId,
    required this.itemCode,
    required this.itemName,
    required this.quantity,
    required this.netPrice,
    this.comment,
  });

  double get gstPrice => netPrice * Val.gstPrecentage;
  double get itemPrice => netPrice + gstPrice; // Price with GST
  double get netTotal => netPrice * quantity;
  double get gstTotal => gstPrice * quantity;
  double get totalPrice => itemPrice * quantity;
}

// Helper class for extra charge
class ExtraChargeEntry {
  final String description;
  final double amount;

  ExtraChargeEntry({
    required this.description,
    required this.amount,
  });
}
