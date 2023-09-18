import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos/controllers/invoice_draft_contorller.dart';
import 'package:pos/controllers/invoice_edit_controller.dart';
import 'package:pos/database/cart_db_service.dart';
import 'package:pos/theme/t_colors.dart';
import 'package:pos/utils/my_format.dart';
import 'package:pos/utils/val.dart';
import 'package:pos/widgets/pos_text_form_field.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../database/item_db_service.dart';
import '../../models/cart.dart';
import '../../models/item.dart';
import '../stock_manager.dart/stock_page.dart';

class InvoiceItemSelectPage extends StatefulWidget {
  final InvoiceDraftController? invoiceController;
  final InvoiceEditController? invoiceEditController;
  const InvoiceItemSelectPage(
      {super.key, this.invoiceController, this.invoiceEditController});

  @override
  State<InvoiceItemSelectPage> createState() => InvoiceItemSelectPageState();
}

class InvoiceItemSelectPageState extends State<InvoiceItemSelectPage> {
  late final _databaseService; // Use your DatabaseService class
  List<Item> _item = [];
  ItemDataSource itemDataSource = ItemDataSource(itemData: []);
  Function? disposeListen;
  var invoiceController;

  @override
  void initState() {
    super.initState();
    _databaseService = ItemDB();
    invoiceController =
        widget.invoiceController ?? widget.invoiceEditController;
    disposeListen = GetStorage(DBVal.items).listen(() {
      getItemData();
    });
    getItemData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    disposeListen?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100.0,
        title: Text(
          'Select Item',
          style: TStyle.titleBarStyle,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Obx(() => detailsRowWidget('Net Total',
                    MyFormat.formatCurrency(invoiceController.netTotal.value))),
                const SizedBox(
                  height: 5.0,
                ),
                Obx(() => detailsRowWidget('GST Total',
                    MyFormat.formatCurrency(invoiceController.gstTotal.value))),
                const SizedBox(
                  height: 5.0,
                ),
                Obx(() => detailsRowWidget('Total',
                    MyFormat.formatCurrency(invoiceController.total.value))),
                const SizedBox(
                  height: 5.0,
                ),
              ],
            ),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SfDataGrid(
                gridLinesVisibility: GridLinesVisibility.both,
                headerGridLinesVisibility: GridLinesVisibility.both,
                allowFiltering: true,
                allowColumnsResizing: true,
                showFilterIconOnHover: true,
                columnWidthMode: ColumnWidthMode.auto,
                source: itemDataSource,
                onCellTap: ((details) {
                  if (details.rowColumnIndex.rowIndex != 0) {
                    int selectedRowIndex = details.rowColumnIndex.rowIndex - 1;
                    var row = itemDataSource.effectiveRows
                        .elementAt(selectedRowIndex);

                    addItemtoList(row.getCells()[0].value.toString());
                  }
                }),
                columns: [
                  GridColumn(
                      columnName: Item.idKey,
                      label: Center(child: const Text('Item ID'))),
                  GridColumn(
                      columnName: Item.nameKey,
                      label: Center(child: const Text('Item Name'))),
                  GridColumn(
                      columnName: Item.qtyKey,
                      label: Center(child: const Text('Qty'))),
                  GridColumn(
                      columnName: Item.priceKey,
                      label: Center(child: const Text('Price'))),
                  GridColumn(
                      columnName: Item.priceTwoKey,
                      label: Center(child: const Text('Price 02'))),
                  GridColumn(
                      columnName: Item.priceThreeKey,
                      label: Center(child: const Text('Price 03'))),
                  GridColumn(
                      columnName: Item.priceFourKey,
                      label: Center(child: const Text('Price 04'))),
                  GridColumn(
                      columnName: Item.priceFiveKey,
                      label: Center(child: const Text('Price 05'))),
                  GridColumn(
                      columnName: Item.lastInDateKey,
                      label: Center(child: const Text('Last In Date'))),
                  GridColumn(
                      columnName: Item.lastOutDateKey,
                      label: Center(child: const Text('Last Out Date'))),

                  // Add more columns as needed
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getItemData() async {
    _item = await _databaseService.getAllItems();
    itemDataSource = ItemDataSource(itemData: _item);
    setState(() {});
  }

  Future<void> addItemtoList(String itemId) async {
    Item item = _databaseService.getItem(itemId);
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
          title: Text(item.name),
          content: SizedBox(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      PosTextFormField(
                        width: 100.0,
                        labelText: 'Net price',
                        controller: netPriceController,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*')),
                        ],
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            net = double.parse(value);
                            double totalWithGST = (net *
                                (1 +
                                    Val.gstTotalPrecentage)); // Assuming GST is 10%
                            totalPriceController.text =
                                totalWithGST.toStringAsFixed(2);
                          } else {
                            totalPriceController.clear();
                          }
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      PosTextFormField(
                        width: 100.0,
                        controller: totalPriceController,
                        labelText: 'Total Price',
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*')),
                        ],
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            double totalWithGST = double.parse(value);
                            net = totalWithGST / 1.1; // Reverse GST calculation
                            netPriceController.text = net.toStringAsFixed(2);
                          } else {
                            netPriceController.clear();
                          }
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      PosTextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\-?\d*'))
                        ],
                        width: 100.0,
                        labelText: 'Quantity',
                        controller: qtyController,
                      ),
                    ],
                  ),
                ),
                PosTextFormField(
                  width: 400.0,
                  height: 70.0,
                  labelText: 'Comment',
                  controller: commentController,
                ),
                Row(
                  children: [
                    Obx(() => Checkbox(
                        semanticLabel: 'Delivery Item',
                        value: isDeliveryItem.value,
                        onChanged: (onChanged) {
                          isDeliveryItem.value = onChanged ?? false;
                        })),
                    const Text('Delivery Item')
                  ],
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                double itemPrice = net;
                String commnet = commentController.text;
                int qty = qtyController.text.isEmpty
                    ? 0
                    : int.parse(qtyController.text);
                if (qty != 0) {
                  Cart cartItem = Cart(
                      itemId: item.id,
                      name: item.name,
                      netPrice: itemPrice,
                      qty: qty,
                      isPostedItem: isDeliveryItem.value,
                      comment: commnet);
                  await CartDB().addItemToCart(cartItem);
                  await invoiceController.updateCart();
                }
                Navigator.of(context).pop();
              },
              child: Text('Add to Invoice'),
            ),
          ],
        );
      },
    );
  }

  Widget detailsRowWidget(String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$key : ',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
        ),
        Text(
          value,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
