import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/invoice_edit_controller.dart';
import 'package:pos/data_sources/invoiceDataSource.dart';
import 'package:pos/database/cart_db_service.dart';
import 'package:pos/database/item_db_service.dart';
import 'package:pos/enums/enums.dart';
import 'package:pos/models/extra_charges.dart';
import 'package:pos/theme/app_theme.dart';
import 'package:pos/utils/alert_message.dart';
import 'package:pos/utils/constant.dart';
import '../../models/invoice_row.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../models/cart.dart';
import '../../models/item.dart';
import '../../utils/my_format.dart';
import '../../utils/val.dart';
import '../../widgets/pos_text_form_field.dart';

/// Modern invoice edit view showing editable invoice data
class InvoiceEditView extends StatefulWidget {
  final InvoiceEditController invoiceController;

  const InvoiceEditView({
    super.key,
    required this.invoiceController,
  });

  @override
  State<InvoiceEditView> createState() => _InvoiceEditViewState();
}

class _InvoiceEditViewState extends State<InvoiceEditView> {
  final ScrollController controller = ScrollController();
  final ScrollController controller2 = ScrollController();
  late final InvoiceEditController invoiceController;

  final dbService = CartDB();
  InvoiceDataSource invoiceDataSource = InvoiceDataSource(invoiceData: []);

  @override
  late BuildContext context;

  @override
  void initState() {
    super.initState();
    invoiceController = widget.invoiceController;
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Container(
      width: MediaQuery.of(context).size.width - 220,
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      child: Column(
        children: [
          _buildInvoiceSummaryCard(),
          const SizedBox(height: AppTheme.spacingLg),
          Expanded(child: _buildInvoiceItemsGrid()),
        ],
      ),
    );
  }

  /// Build modern invoice summary card
  Widget _buildInvoiceSummaryCard() {
    return Container(
      decoration: AppTheme.cardDecoration.copyWith(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left side - Invoice and customer info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Invoice #${invoiceController.invoice.invoiceId}',
                        style: AppTheme.headlineMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingMd),
                      _detailsRowWidget(
                        'Customer ID',
                        invoiceController.invoice.customerId,
                      ),
                      const SizedBox(height: AppTheme.spacingSm),
                      _detailsRowWidget(
                        'Customer Name',
                        invoiceController.invoice.customerName,
                      ),
                      const SizedBox(height: AppTheme.spacingSm),
                      _detailsRowWidget(
                        'Mobile',
                        invoiceController.invoice.customerMobile,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppTheme.spacingXl),
                // Right side - Pricing totals
                Container(
                  width: 200,
                  padding: const EdgeInsets.all(AppTheme.spacingMd),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundGrey,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Obx(() => _priceRowWidget(
                            'Net Total',
                            MyFormat.formatCurrency(
                              invoiceController.netTotal.value,
                            ),
                          )),
                      const SizedBox(height: AppTheme.spacingSm),
                      Obx(() => _priceRowWidget(
                            'GST Total',
                            MyFormat.formatCurrency(
                              invoiceController.gstTotal.value,
                            ),
                          )),
                      const SizedBox(height: AppTheme.spacingSm),
                      const Divider(height: 1),
                      const SizedBox(height: AppTheme.spacingSm),
                      Obx(() => _priceRowWidget(
                            'Total',
                            MyFormat.formatCurrency(
                              invoiceController.total.value,
                            ),
                            isTotal: true,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build invoice items data grid
  Widget _buildInvoiceItemsGrid() {
    return Container(
      decoration: AppTheme.cardDecoration,
      child: Obx(() => SfDataGrid(
            gridLinesVisibility: GridLinesVisibility.both,
            headerGridLinesVisibility: GridLinesVisibility.both,
            allowColumnsResizing: true,
            rowHeight: Const.tableRowHeight,
            columnWidthMode: ColumnWidthMode.fitByCellValue,
            allowSwiping: true,
            headerRowHeight: 48,
            onCellDoubleTap: _handleCellDoubleTap,
            source: generateDataRowList(
              invoiceController.newCartList,
              invoiceController.extraList,
              invoiceController.comments,
            ),
            columns: [
              GridColumn(
                columnName: InvoiceRow.itemIdKey,
                label: _buildColumnHeader('Item ID'),
              ),
              GridColumn(
                columnName: InvoiceRow.nameKey,
                label: _buildColumnHeader('Item Name'),
              ),
              GridColumn(
                columnName: InvoiceRow.qtyKey,
                label: _buildColumnHeader('Qty'),
              ),
              GridColumn(
                columnName: InvoiceRow.netPriceKey,
                label: _buildColumnHeader('Net Price'),
              ),
              GridColumn(
                columnName: InvoiceRow.gstKey,
                label: _buildColumnHeader('GST'),
              ),
              GridColumn(
                columnName: InvoiceRow.itemPriceKey,
                label: _buildColumnHeader('Item Price'),
              ),
              GridColumn(
                columnName: InvoiceRow.totalKey,
                label: _buildColumnHeader('Total'),
              ),
            ],
          )),
    );
  }

  /// Build column header with modern styling
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

  /// Handle double-tap to edit item or extra charge
  void _handleCellDoubleTap(DataGridCellDoubleTapDetails details) {
    final row = invoiceDataSource.effectiveRows
        .elementAt(details.rowColumnIndex.rowIndex - 1);
    InvoiceItemCategory itemCategory =
        row.getCells()[1].value.keys.toList()[0];
    int cartId = row.getCells()[0].value.keys.toList()[0];

    if (itemCategory == InvoiceItemCategory.comment ||
        itemCategory == InvoiceItemCategory.empty) {
      // Don't edit comments or empty rows
    } else {
      if (itemCategory == InvoiceItemCategory.item) {
        editItemDialog(cartId);
      } else {
        editExtraDialog(cartId);
      }
    }
  }

  /// Details row widget
  Widget _detailsRowWidget(String key, String value) {
    return Row(
      children: [
        Text(
          '$key: ',
          style: AppTheme.labelMedium.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTheme.bodyMedium.copyWith(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// Price row widget
  Widget _priceRowWidget(String key, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          key,
          style: isTotal
              ? AppTheme.labelLarge.copyWith(fontWeight: FontWeight.bold)
              : AppTheme.labelMedium.copyWith(color: AppTheme.textSecondary),
        ),
        Text(
          value,
          style: isTotal
              ? AppTheme.headlineSmall.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                )
              : AppTheme.bodyMedium.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
        ),
      ],
    );
  }

  /// Generate comment data rows
  List<InvoiceRow> commentDataRow(String comment) {
    return comment
        .split('\n')
        .map((e) => InvoiceRow(
              itemId: {-1: ''},
              itemName: {InvoiceItemCategory.comment: e},
            ))
        .toList();
  }

  /// Generate data row list for the data grid
  InvoiceDataSource generateDataRowList(
    List<Cart> cartList,
    List<ExtraCharges> extraList,
    List<String> comments,
  ) {
    List<InvoiceRow> invoiceData = [];

    // Add cart items
    for (Cart cart in cartList) {
      invoiceData.add(InvoiceRow(
        itemId: {
          cartList.indexOf(cart):
              cart.isPostedItem ? 'P${cart.itemId}' : cart.itemId
        },
        itemName: {InvoiceItemCategory.item: cart.name},
        gst: MyFormat.formatCurrency(cart.gst),
        netPrice: MyFormat.formatCurrency(cart.price),
        itemPrice: MyFormat.formatCurrency(cart.itemPrice),
        total: MyFormat.formatCurrency(cart.totalPrice),
        qty: cart.qty.toString(),
      ));

      if (cart.comment != null && cart.comment!.isNotEmpty) {
        invoiceData += commentDataRow(cart.comment!);
      }
    }

    // Add separator
    invoiceData += [
      InvoiceRow(
        itemId: {-1: ''},
        itemName: {InvoiceItemCategory.empty: ''},
      )
    ];

    // Add extra charges
    for (ExtraCharges charge in extraList) {
      double gstPrice = (charge.price * Val.gstPrecentage);
      double itemPrice = (charge.price * Val.gstTotalPrecentage);
      double totalPrice = (itemPrice * charge.qty);
      invoiceData.add(InvoiceRow(
        itemId: {
          extraList.indexOf(charge): '#${extraList.indexOf(charge) + 1}'
        },
        itemName: {InvoiceItemCategory.extraChrage: charge.name},
        gst: MyFormat.formatCurrency(gstPrice),
        netPrice: MyFormat.formatCurrency(charge.price),
        itemPrice: MyFormat.formatCurrency(itemPrice),
        total: MyFormat.formatCurrency(totalPrice),
        qty: charge.qty.toString(),
      ));

      if (charge.comment != null && charge.comment!.isNotEmpty) {
        invoiceData += commentDataRow(charge.comment!);
      }
    }

    // Add separator
    invoiceData += [
      InvoiceRow(
        itemId: {-1: ''},
        itemName: {InvoiceItemCategory.empty: ''},
      )
    ];

    // Add general comments
    for (String comment in comments) {
      invoiceData += commentDataRow(comment);
    }

    // Add final separator
    invoiceData += [
      InvoiceRow(
        itemId: {-1: ''},
        itemName: {InvoiceItemCategory.empty: ''},
      )
    ];

    invoiceDataSource = InvoiceDataSource(invoiceData: invoiceData);
    return invoiceDataSource;
  }

  /// Edit item dialog
  Future<void> editItemDialog(int index) async {
    Cart oldCart = invoiceController.newCartList[index];
    TextEditingController netPriceController = TextEditingController();
    TextEditingController totalPriceController = TextEditingController();
    TextEditingController commentController = TextEditingController();
    TextEditingController qtyController = TextEditingController();
    double net = oldCart.price;
    RxBool isDeliveryItem = oldCart.isPostedItem.obs;

    List list = invoiceController.oldCartList
        .where((element) => element.cartId == oldCart.cartId)
        .toList();

    netPriceController.text = MyFormat.formatPrice(net);
    totalPriceController.text =
        MyFormat.formatPrice(net * Val.gstTotalPrecentage);
    qtyController.text = oldCart.qty.toString();
    commentController.text = oldCart.comment.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  oldCart.name,
                  style: AppTheme.headlineSmall,
                ),
              ),
              IconButton(
                onPressed: () async {
                  if (list.isNotEmpty) {
                    await CartDB().removeOldItemFromCart(list[0], oldCart);
                  } else {
                    await CartDB().removeItemFromCart(oldCart);
                  }
                  await invoiceController.updateCart();
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.delete,
                  color: AppTheme.errorColor,
                ),
                tooltip: 'Delete item',
              ),
            ],
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
                            double totalWithGST = net + (net * Val.gstPrecentage);
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
                        labelText: 'Quantity',
                        controller: qtyController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^-?\d*'))
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingMd),
                PosTextFormField(
                  height: 100,
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
                Item? item = ItemDB().getItem(oldCart.itemId);
                if (item == null) {
                  AlertMessage.snakMessage(
                    'This item cannot be found in the stock. Cannot update',
                    context,
                  );
                  return;
                }

                double itemPrice = net;
                String comment =
                    MyFormat.divideStringIntoLines(commentController.text);
                int qty = qtyController.text.isEmpty
                    ? 0
                    : int.parse(qtyController.text);

                Cart newCart = oldCart.copyWith(
                  comment: comment,
                  netPrice: itemPrice,
                  qty: qty,
                  isPostedItem: isDeliveryItem.value,
                );

                if (list.isNotEmpty) {
                  await CartDB().updateOldCart(list[0], newCart);
                } else {
                  await CartDB().updateCart(oldCart, newCart);
                }
                await invoiceController.updateCart();

                Navigator.of(context).pop();
              },
              style: AppTheme.primaryButtonStyle(),
              child: const Text('Update Item'),
            ),
          ],
        );
      },
    );
  }

  /// Edit extra charge dialog
  Future<void> editExtraDialog(int index) async {
    ExtraCharges oldExtra = invoiceController.extraList[index];
    TextEditingController netPriceController =
        TextEditingController(text: MyFormat.formatPrice(oldExtra.price));
    TextEditingController totalPriceController = TextEditingController(
      text: MyFormat.formatPrice(oldExtra.price * Val.gstTotalPrecentage),
    );
    TextEditingController commentController =
        TextEditingController(text: oldExtra.comment);
    TextEditingController qtyController =
        TextEditingController(text: oldExtra.qty.toString());
    TextEditingController nameController =
        TextEditingController(text: oldExtra.name);
    double net = oldExtra.price;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Edit Extra Charges',
                style: AppTheme.headlineSmall,
              ),
              IconButton(
                onPressed: () {
                  invoiceController.extraList.removeAt(index);
                  invoiceController.updateExtraTotal();
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.delete,
                  color: AppTheme.errorColor,
                ),
                tooltip: 'Delete extra charge',
              ),
            ],
          ),
          content: SizedBox(
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PosTextFormField(
                  labelText: 'Name',
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter extra charges name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppTheme.spacingMd),
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
                            double totalWithGST = net + (net * Val.gstPrecentage);
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
                        labelText: 'Quantity',
                        controller: qtyController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^-?\d*'))
                        ],
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
                String name = nameController.text;
                int qty = qtyController.text.isEmpty
                    ? 0
                    : int.parse(qtyController.text);

                if (name.isNotEmpty && itemPrice >= 0) {
                  ExtraCharges extraCharges = ExtraCharges(
                    name: name,
                    qty: qty,
                    price: itemPrice,
                    comment: comment,
                  );
                  invoiceController.extraList[index] = extraCharges;
                  invoiceController.updateExtraTotal();
                } else {
                  AlertMessage.snakMessage('Invalid Input', context);
                }
                Navigator.of(context).pop();
              },
              style: AppTheme.primaryButtonStyle(),
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
