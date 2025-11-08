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

/// Modern supplier invoice creation page
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

  // Selected supplier
  Supplier? _selectedSupplier;

  // Invoice items
  final List<InvoiceItemEntry> _items = [];

  // Extra charges
  final List<ExtraChargeEntry> _extraCharges = [];

  // Comments
  final List<String> _comments = [];

  // Totals
  double _itemsTotal = 0.0;
  double _extraChargesTotal = 0.0;
  double _netTotal = 0.0;
  double _gstTotal = 0.0;
  double _grandTotal = 0.0;

  bool _isSaving = false;

  void _calculateTotals() {
    setState(() {
      _itemsTotal = _items.fold(0.0, (sum, item) => sum + (item.quantity * item.buyingPrice));
      _extraChargesTotal = _extraCharges.fold(0.0, (sum, charge) => sum + charge.amount);
      _netTotal = _itemsTotal + _extraChargesTotal;

      _gstTotal = (_netTotal * Val.gstPrecentage * 100).round() / 100;
      _grandTotal = ((_netTotal + _gstTotal) * 100).round() / 100;
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

    final suppliers = result.data!;

    if (!mounted) return;

    final selected = await showDialog<Supplier>(
      context: context,
      builder: (context) => _SupplierSelectionDialog(suppliers: suppliers),
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

    final items = result.data!;

    if (!mounted) return;

    final selected = await showDialog<Item>(
      context: context,
      builder: (context) => _ItemSelectionDialog(items: items),
    );

    if (selected != null) {
      _showItemQuantityDialog(selected);
    }
  }

  void _showItemQuantityDialog(Item item) {
    final quantityController = TextEditingController(text: '1');
    final priceController = TextEditingController();
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.name),
        content: SizedBox(
          width: 400,
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
              TextField(
                controller: priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                decoration: AppTheme.inputDecoration(labelText: 'Buying Price'),
              ),
              const SizedBox(height: AppTheme.spacingMd),
              TextField(
                controller: commentController,
                maxLines: 3,
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
              final price = double.tryParse(priceController.text) ?? 0.0;

              if (quantity > 0 && price > 0) {
                setState(() {
                  _items.add(InvoiceItemEntry(
                    itemId: item.id,
                    itemName: item.name,
                    quantity: quantity,
                    buyingPrice: price,
                    comment: commentController.text.isEmpty ? null : commentController.text,
                  ));
                });
                _calculateTotals();
                Navigator.pop(context);
              } else {
                AlertMessage.snakMessage('Please enter valid quantity and price', context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
    _calculateTotals();
  }

  void _addExtraCharge() {
    final descriptionController = TextEditingController();
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Extra Charge'),
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
                  _extraCharges.add(ExtraChargeEntry(
                    description: description,
                    amount: amount,
                  ));
                });
                _calculateTotals();
                Navigator.pop(context);
              } else {
                AlertMessage.snakMessage('Please enter valid description and amount', context);
              }
            },
            child: const Text('Add'),
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

  void _addComment() {
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Comment'),
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
                  _comments.add(comment);
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
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
        buyingPrice: item.buyingPrice,
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
      // Automatically mark as paid
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
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppTheme.textPrimary),
        actions: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingSm),
            child: ElevatedButton.icon(
              onPressed: _isSaving ? null : _saveInvoice,
              icon: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save, size: 18),
              label: Text(_isSaving ? 'Saving...' : 'Save Invoice'),
              style: AppTheme.primaryButtonStyle(),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppTheme.borderColor),
        ),
      ),
      body: Row(
        children: [
          // Main content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Supplier Selection
                  _buildSupplierCard(),

                  const SizedBox(height: AppTheme.spacingLg),

                  // Items
                  _buildItemsCard(),

                  const SizedBox(height: AppTheme.spacingLg),

                  // Extra Charges
                  _buildExtraChargesCard(),

                  const SizedBox(height: AppTheme.spacingLg),

                  // Comments
                  _buildCommentsCard(),
                ],
              ),
            ),
          ),

          // Invoice summary sidebar
          _buildInvoiceSummarySidebar(),
        ],
      ),
    );
  }

  Widget _buildSupplierCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: AppTheme.borderColor),
      ),
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.person_outline, color: AppTheme.primaryColor),
                  const SizedBox(width: AppTheme.spacingSm),
                  Text(
                    'Supplier',
                    style: AppTheme.headlineSmall.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: _selectSupplier,
                icon: const Icon(Icons.search, size: 18),
                label: Text(_selectedSupplier == null ? 'Select Supplier' : 'Change'),
                style: AppTheme.secondaryButtonStyle(),
              ),
            ],
          ),
          if (_selectedSupplier != null) ...[
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              '${_selectedSupplier!.firstName} ${_selectedSupplier!.lastName}',
              style: AppTheme.bodyLarge.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              _selectedSupplier!.id,
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.textSecondary,
                fontFamily: 'monospace',
              ),
            ),
            if (_selectedSupplier!.mobileNumber != null)
              Text(
                _selectedSupplier!.mobileNumber!,
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
          ] else
            Padding(
              padding: const EdgeInsets.only(top: AppTheme.spacingMd),
              child: Text(
                'No supplier selected',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildItemsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.inventory_2_outlined, color: AppTheme.primaryColor),
                    const SizedBox(width: AppTheme.spacingSm),
                    Text(
                      'Items',
                      style: AppTheme.headlineSmall.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _addItem,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Item'),
                  style: AppTheme.secondaryButtonStyle(),
                ),
              ],
            ),
          ),
          if (_items.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: Text(
                'No items added yet',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            ..._items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingLg,
                  vertical: AppTheme.spacingMd,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppTheme.borderColor),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.itemName,
                            style: AppTheme.bodyMedium.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (item.comment != null)
                            Text(
                              item.comment!,
                              style: AppTheme.bodyXSmall.copyWith(
                                color: AppTheme.textSecondary,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Qty: ${item.quantity}',
                        textAlign: TextAlign.center,
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        MyFormat.formatCurrency(item.buyingPrice),
                        textAlign: TextAlign.right,
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        MyFormat.formatCurrency(item.quantity * item.buyingPrice),
                        textAlign: TextAlign.right,
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: AppTheme.errorColor),
                      onPressed: () => _removeItem(index),
                    ),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildExtraChargesCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.add_circle_outline, color: AppTheme.primaryColor),
                    const SizedBox(width: AppTheme.spacingSm),
                    Text(
                      'Extra Charges',
                      style: AppTheme.headlineSmall.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _addExtraCharge,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Charge'),
                  style: AppTheme.secondaryButtonStyle(),
                ),
              ],
            ),
          ),
          if (_extraCharges.isNotEmpty)
            ..._extraCharges.asMap().entries.map((entry) {
              final index = entry.key;
              final charge = entry.value;
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingLg,
                  vertical: AppTheme.spacingMd,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppTheme.borderColor),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        charge.description,
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      MyFormat.formatCurrency(charge.amount),
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: AppTheme.errorColor),
                      onPressed: () => _removeExtraCharge(index),
                    ),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildCommentsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.comment_outlined, color: AppTheme.primaryColor),
                    const SizedBox(width: AppTheme.spacingSm),
                    Text(
                      'Comments',
                      style: AppTheme.headlineSmall.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _addComment,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Comment'),
                  style: AppTheme.secondaryButtonStyle(),
                ),
              ],
            ),
          ),
          if (_comments.isNotEmpty)
            ..._comments.asMap().entries.map((entry) {
              final index = entry.key;
              final comment = entry.value;
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingLg,
                  vertical: AppTheme.spacingMd,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppTheme.borderColor),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        comment,
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: AppTheme.errorColor),
                      onPressed: () => _removeComment(index),
                    ),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildInvoiceSummarySidebar() {
    return Container(
      width: 350,
      color: Colors.white,
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Invoice Summary',
            style: AppTheme.headlineSmall.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),

          // Items section
          if (_items.isNotEmpty) ...[
            Text(
              'Items',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            ..._items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.spacingXs),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${item.itemName} (${item.quantity})',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    MyFormat.formatCurrency(item.quantity * item.buyingPrice),
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            )).toList(),
            const Divider(),
          ],

          // Extra charges section
          if (_extraCharges.isNotEmpty) ...[
            Text(
              'Extra Charges',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            ..._extraCharges.map((charge) => Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.spacingXs),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      charge.description,
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    MyFormat.formatCurrency(charge.amount),
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            )).toList(),
            const Divider(),
          ],

          // Comments section
          if (_comments.isNotEmpty) ...[
            Text(
              'Comments',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            ..._comments.map((comment) => Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.spacingXs),
              child: Text(
                '• $comment',
                style: AppTheme.bodyXSmall.copyWith(
                  color: AppTheme.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )).toList(),
            const Divider(),
          ],

          // Totals
          _buildTotalRow('Subtotal', _itemsTotal + _extraChargesTotal),
          _buildTotalRow(
            'GST (${(Val.gstPrecentage * 100).toStringAsFixed(1)}%)',
            _gstTotal,
          ),
          const Divider(),
          _buildTotalRow('Total', _grandTotal, isTotal: true),

          const Spacer(),

          Container(
            padding: const EdgeInsets.all(AppTheme.spacingSm),
            decoration: BoxDecoration(
              color: AppTheme.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              border: Border.all(color: AppTheme.successColor.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: AppTheme.successColor, size: 16),
                const SizedBox(width: AppTheme.spacingSm),
                Expanded(
                  child: Text(
                    'Invoice will be marked as paid',
                    style: AppTheme.bodyXSmall.copyWith(
                      color: AppTheme.successColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
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
                : const Icon(Icons.save),
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

  Widget _buildTotalRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: (isTotal ? AppTheme.bodyMedium : AppTheme.bodySmall).copyWith(
              color: AppTheme.textSecondary,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            MyFormat.formatCurrency(amount),
            style: (isTotal ? AppTheme.bodyLarge : AppTheme.bodyMedium).copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
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
        width: 800,
        height: 600,
        padding: const EdgeInsets.all(AppTheme.spacingLg),
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
        width: 800,
        height: 600,
        padding: const EdgeInsets.all(AppTheme.spacingLg),
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

// Helper classes
class InvoiceItemEntry {
  final String itemId;
  final String itemName;
  final int quantity;
  final double buyingPrice;
  final String? comment;

  InvoiceItemEntry({
    required this.itemId,
    required this.itemName,
    required this.quantity,
    required this.buyingPrice,
    this.comment,
  });
}

class ExtraChargeEntry {
  final String description;
  final double amount;

  ExtraChargeEntry({
    required this.description,
    required this.amount,
  });
}
