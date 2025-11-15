import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/invoice_draft_contorller.dart';
import 'package:pos/controllers/invoice_edit_controller.dart';
import 'package:pos/database/cart_db_service.dart';
import 'package:pos/repositories/item_repository.dart';
import 'package:pos/theme/app_theme.dart';
import 'package:pos/utils/my_format.dart';
import 'package:pos/utils/val.dart';
import 'package:pos/widgets/pos_text_form_field.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../models/cart.dart';
import '../../models/item.dart';
import 'package:pos/datasources/item_data_source.dart';

/// Modern item selection page for adding items to invoices
class InvoiceItemSelectPage extends StatefulWidget {
  final InvoiceDraftController? invoiceController;
  final InvoiceEditController? invoiceEditController;

  const InvoiceItemSelectPage({
    super.key,
    this.invoiceController,
    this.invoiceEditController,
  });

  @override
  State<InvoiceItemSelectPage> createState() => InvoiceItemSelectPageState();
}

class InvoiceItemSelectPageState extends State<InvoiceItemSelectPage> {
  final ItemRepository _itemRepo = Get.find<ItemRepository>();
  List<Item> _items = [];
  ItemDataSource itemDataSource = ItemDataSource(itemData: []);
  var invoiceController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    invoiceController =
        widget.invoiceController ?? widget.invoiceEditController;
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(),
    );
  }

  /// Build modern app bar with totals
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 100.0,
      title: Row(
        children: [
          const Icon(Icons.inventory_2, size: 24),
          const SizedBox(width: AppTheme.spacingMd),
          Text(
            'Select Item',
            style: AppTheme.headlineMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Container(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Obx(() => _buildTotalRow(
                      'Net Total',
                      MyFormat.formatCurrency(
                        invoiceController.netTotal.value,
                      ),
                    )),
                Obx(() => _buildTotalRow(
                      'GST Total',
                      MyFormat.formatCurrency(
                        invoiceController.gstTotal.value,
                      ),
                    )),
                Obx(() => _buildTotalRow(
                      'Total',
                      MyFormat.formatCurrency(
                        invoiceController.total.value,
                      ),
                      isBold: true,
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build total row
  Widget _buildTotalRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label: ',
          style: AppTheme.bodyMedium.copyWith(
            color: Colors.white,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: AppTheme.bodyMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Build body
  Widget _buildBody() {
    return Column(
      children: [
        _buildInfoCard(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingLg,
              vertical: AppTheme.spacingMd,
            ),
            child: Container(
              decoration: AppTheme.cardDecoration,
              child: SfDataGrid(
                gridLinesVisibility: GridLinesVisibility.both,
                headerGridLinesVisibility: GridLinesVisibility.both,
                allowFiltering: true,
                rowHeight: 30.0,
                allowColumnsResizing: true,
                showFilterIconOnHover: true,
                columnWidthMode: ColumnWidthMode.auto,
                headerRowHeight: 48,
                source: itemDataSource,
                onCellTap: _handleItemTap,
                columns: [
                  GridColumn(
                    columnName: Item.idKey,
                    label: _buildColumnHeader('Item ID'),
                  ),
                  GridColumn(
                    columnName: Item.nameKey,
                    label: _buildColumnHeader('Item Name'),
                  ),
                  GridColumn(
                    columnName: Item.qtyKey,
                    label: _buildColumnHeader('Stock'),
                  ),
                  GridColumn(
                    columnName: Item.priceKey,
                    label: _buildColumnHeader('Price'),
                  ),
                  GridColumn(
                    columnName: Item.priceTwoKey,
                    label: _buildColumnHeader('Price 2'),
                  ),
                  GridColumn(
                    columnName: Item.priceThreeKey,
                    label: _buildColumnHeader('Price 3'),
                  ),
                  GridColumn(
                    columnName: Item.priceFourKey,
                    label: _buildColumnHeader('Price 4'),
                  ),
                  GridColumn(
                    columnName: Item.priceFiveKey,
                    label: _buildColumnHeader('Price 5'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build info card
  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingLg),
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.infoColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: AppTheme.infoColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            color: AppTheme.infoColor,
            size: 20,
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: Text(
              'Click on an item to add it to the invoice. You can set quantity, price, and comments in the dialog.',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          Text(
            '${_items.length} items',
            style: AppTheme.labelLarge.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Build column header
  Widget _buildColumnHeader(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingSm,
      ),
      alignment: Alignment.center,
      color: AppTheme.backgroundGrey,
      child: Text(
        text,
        style: AppTheme.labelLarge.copyWith(
          fontWeight: FontWeight.bold,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }

  /// Handle item tap
  void _handleItemTap(DataGridCellTapDetails details) {
    if (details.rowColumnIndex.rowIndex != 0) {
      int selectedRowIndex = details.rowColumnIndex.rowIndex - 1;
      var row = itemDataSource.effectiveRows.elementAt(selectedRowIndex);
      addItemtoList(row.getCells()[0].value.toString());
    }
  }

  /// Load items from repository
  Future<void> _loadItems() async {
    setState(() => _isLoading = true);

    try {
      final result = await _itemRepo.getAllItems();

      if (result.isSuccess) {
        final driftItems = result.data ?? [];

        // Convert Drift items to domain Item models
        _items = driftItems.map((driftItem) {
          return Item(
            id: driftItem.id,
            name: driftItem.name,
            qty: driftItem.quantity,
            price: driftItem.price,
          );
        }).toList();

        itemDataSource = ItemDataSource(itemData: _items);
      }
    } catch (e) {
      debugPrint('Error loading items: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Add item to invoice
  Future<void> addItemtoList(String itemId) async {
    Item? item = _items.firstWhereOrNull((item) => item.id == itemId);
    if (item == null) return;

    TextEditingController netPriceController = TextEditingController();
    TextEditingController totalPriceController = TextEditingController();
    TextEditingController commentController = TextEditingController();
    TextEditingController qtyController = TextEditingController(text: '1');
    double net = item.price;
    RxBool isDeliveryItem = false.obs;

    netPriceController.text = MyFormat.formatPrice(item.price);
    totalPriceController.text =
        MyFormat.formatPrice(item.price * Val.gstTotalPrecentage);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            item.name,
            style: AppTheme.headlineSmall,
          ),
          content: SizedBox(
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: PosTextFormField(
                        labelText: 'Net price',
                        controller: netPriceController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            net = double.parse(value);
                            double totalWithGST =
                                (net * (Val.gstTotalPrecentage));
                            totalPriceController.text =
                                totalWithGST.toStringAsFixed(2);
                          } else {
                            totalPriceController.clear();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingMd),
                    Expanded(
                      child: PosTextFormField(
                        controller: totalPriceController,
                        labelText: 'Total Price',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            double totalWithGST = double.parse(value);
                            net = totalWithGST / Val.gstTotalPrecentage;
                            netPriceController.text = net.toStringAsFixed(2);
                          } else {
                            netPriceController.clear();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingMd),
                    Expanded(
                      child: PosTextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^-?\d*'))
                        ],
                        labelText: 'Quantity',
                        controller: qtyController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingMd),
                PosTextFormField(
                  height: 100.0,
                  maxLines: 3,
                  labelText: 'Comment',
                  controller: commentController,
                ),
                const SizedBox(height: AppTheme.spacingMd),
                Row(
                  children: [
                    Obx(() => Checkbox(
                          value: isDeliveryItem.value,
                          onChanged: (onChanged) {
                            isDeliveryItem.value = onChanged ?? false;
                          },
                        )),
                    Text(
                      'Delivery Item',
                      style: AppTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                double itemPrice = net;
                String comment =
                    MyFormat.divideStringIntoLines(commentController.text);
                int qty = qtyController.text.isEmpty
                    ? 0
                    : int.parse(qtyController.text);

                if (qty != 0) {
                  Cart cartItem = Cart(
                    itemId: item.id,
                    name: item.name,
                    price: itemPrice,
                    qty: qty,
                    isPostedItem: isDeliveryItem.value,
                    comment: comment,
                  );
                  await CartDB().addItemToCart(cartItem);
                  await invoiceController.updateCart();
                }
                Navigator.of(context).pop();
              },
              style: AppTheme.primaryButtonStyle(),
              child: const Text('Add to Invoice'),
            ),
          ],
        );
      },
    );
  }
}
