import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/invoice_draft_contorller.dart';
import 'package:pos/controllers/invoice_edit_controller.dart';
import 'package:pos/data_sources/invoiceDataSource.dart';
import 'package:pos/database/cart_db_service.dart';
import 'package:pos/enums/enums.dart';
import 'package:pos/models/customer.dart';
import 'package:pos/models/extra_charges.dart';
import 'package:pos/utils/alert_message.dart';
import '../../models/invoice_row.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../models/cart.dart';
import '../../theme/t_colors.dart';
import '../../utils/my_format.dart';
import '../../utils/val.dart';
import '../../widgets/pos_text_form_field.dart';

class InvoiceEditView extends StatefulWidget {
  InvoiceEditView({
    super.key,
  });

  @override
  State<InvoiceEditView> createState() => _InvoiceEditViewState();
}

class _InvoiceEditViewState extends State<InvoiceEditView> {
  final ScrollController controller = ScrollController();
  final ScrollController controller2 = ScrollController();
  late InvoiceEditController invoiceController;
  final dbService = CartDB();
  InvoiceDataSource invoiceDataSource = InvoiceDataSource(invoiceData: []);
  late BuildContext context;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    invoiceController = Get.find<InvoiceEditController>();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Container(
      width: MediaQuery.of(context).size.width - 200,
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Card(
            elevation: 5.0,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Invoice #${invoiceController.invoice.invoiceId}',
                              style: const TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            detailsRowWidget('Customer ID',
                                invoiceController.invoice.customerId),
                            const SizedBox(
                              height: 5.0,
                            ),
                            detailsRowWidget('Customer Name',
                                invoiceController.invoice.customerName),
                            const SizedBox(
                              height: 5.0,
                            ),
                            detailsRowWidget('Customer Name',
                                invoiceController.invoice.customerMobile),
                          ],
                        ),
                        SizedBox(
                          width: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Obx(() => detailsRowWidget(
                                  'Net Total',
                                  MyFormat.formatCurrency(
                                      invoiceController.netTotal.value))),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Obx(() => detailsRowWidget(
                                  'GST Total',
                                  MyFormat.formatCurrency(
                                      invoiceController.gstTotal.value))),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Obx(() => detailsRowWidget(
                                  'Total',
                                  MyFormat.formatCurrency(
                                      invoiceController.total.value))),
                              const SizedBox(
                                height: 5.0,
                              ),
                            ],
                          ),
                        )
                      ]),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          invoiceItemView()
        ],
      ),
    );
  }

  Widget detailsRowWidget(String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$key : ',
          style: TextStyle(
              color: Colors.grey.shade600, fontWeight: FontWeight.w400),
        ),
        Text(
          value,
          style: TextStyle(color: TColors.blue, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  invoiceItemView() {
    return Expanded(
        child: Obx(() => SfDataGrid(
              gridLinesVisibility: GridLinesVisibility.both,
              headerGridLinesVisibility: GridLinesVisibility.both,
              allowColumnsResizing: true,
              rowHeight: 27.0,
              columnWidthMode: ColumnWidthMode.auto,
              allowSwiping: true,
              swipeMaxOffset: 80.0,
              onCellDoubleTap: (details) {
                final row = invoiceDataSource.effectiveRows
                    .elementAt(details.rowColumnIndex.rowIndex - 1);
                InvoiceItemCategory itemCategory =
                    row.getCells()[1].value.keys.toList()[0];
                int cartId = row.getCells()[0].value.keys.toList()[0];

                if (itemCategory == InvoiceItemCategory.comment ||
                    itemCategory == InvoiceItemCategory.empty) {
                } else {
                  if (itemCategory == InvoiceItemCategory.item) {
                    editItemDialog(cartId);
                  } else {
                    editExtraDialog(cartId);
                  }
                }
              },
              source: generateDataRowList(invoiceController.newCartList,
                  invoiceController.extraList, invoiceController.comments),
              columns: [
                GridColumn(
                    columnName: InvoiceRow.itemIdKey,
                    maximumWidth: 120,
                    label: Center(child: const Text('Item ID'))),
                GridColumn(
                    minimumWidth: 500.0,
                    columnName: InvoiceRow.nameKey,
                    label: Center(child: const Text('Item Name'))),
                GridColumn(
                    columnName: InvoiceRow.qtyKey,
                    label: Center(child: const Text('Qty'))),
                GridColumn(
                    columnName: InvoiceRow.netPriceKey,
                    label: Center(child: const Text('Net Price'))),
                GridColumn(
                    columnName: InvoiceRow.gstKey,
                    label: Center(child: const Text('GST'))),
                GridColumn(
                    columnName: InvoiceRow.itemPriceKey,
                    label: Center(child: const Text('Item Price'))),
                GridColumn(
                    minimumWidth: 120.0,
                    columnName: InvoiceRow.totalKey,
                    label: Center(child: const Text('Total'))),

                // Add more columns as needed
              ],
            )));
  }

  Widget cell(
    String value,
  ) {
    return Text(
      value,
      style: TStyle.style_01,
    );
  }

  commentDataRow(String comment) {
    return comment
        .split('\n')
        .map((e) => InvoiceRow(
            itemId: {-1: ''}, itemName: {InvoiceItemCategory.comment: e}))
        .toList();
  }

  InvoiceDataSource generateDataRowList(List<Cart> cartList,
      List<ExtraCharges> extraList, List<String> comments) {
    List<InvoiceRow> invoiceData = [];

    for (Cart cart in cartList) {
      invoiceData.add(InvoiceRow(
          itemId: {cartList.indexOf(cart): cart.itemId},
          itemName: {InvoiceItemCategory.item: cart.name},
          gst: MyFormat.formatCurrency(cart.gst),
          netPrice: MyFormat.formatCurrency(cart.netPrice),
          itemPrice: MyFormat.formatCurrency(cart.itemPrice),
          total: MyFormat.formatCurrency(cart.totalPrice),
          qty: cart.qty.toString()));

      if (cart.comment != null) {
        if (cart.comment!.isNotEmpty) {
          invoiceData += commentDataRow(cart.comment!);
        }
      }
    }
    invoiceData += [
      InvoiceRow(itemId: {-1: ''}, itemName: {InvoiceItemCategory.empty: ''})
    ];

    for (ExtraCharges chrage in extraList) {
      double gstPrice = (chrage.price * Val.gstPrecentage);
      double itemPrcie = (chrage.price * Val.gstTotalPrecentage);
      double totalPrice = (itemPrcie * chrage.qty);
      invoiceData.add(InvoiceRow(
        itemId: {
          extraList.indexOf(chrage): '#${extraList.indexOf(chrage) + 1}'
        },
        itemName: {InvoiceItemCategory.extraChrage: chrage.name},
        gst: MyFormat.formatCurrency(gstPrice),
        netPrice: MyFormat.formatCurrency(chrage.price),
        itemPrice: MyFormat.formatCurrency(itemPrcie),
        total: MyFormat.formatCurrency(totalPrice),
        qty: chrage.qty.toString(),
      ));

      if (chrage.comment != null) {
        if (chrage.comment!.isNotEmpty) {
          invoiceData += commentDataRow(chrage.comment!);
        }
      }
    }
    invoiceData += [
      InvoiceRow(itemId: {-1: ''}, itemName: {InvoiceItemCategory.empty: ''})
    ];
    for (String comment in comments) {
      invoiceData += commentDataRow(comment);
    }
    invoiceData += [
      InvoiceRow(itemId: {-1: ''}, itemName: {InvoiceItemCategory.empty: ''})
    ];

    invoiceDataSource = InvoiceDataSource(invoiceData: invoiceData);

    return invoiceDataSource;
  }

  Future<void> editItemDialog(int index) async {
    Cart oldCart = invoiceController.newCartList[index];
    TextEditingController netPriceController = TextEditingController();
    TextEditingController totalPriceController = TextEditingController();
    TextEditingController commentController = TextEditingController();
    TextEditingController qtyController = TextEditingController();
    double net = oldCart.netPrice;

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
              Text(oldCart.name),
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
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red.shade900,
                  ))
            ],
          ),
          content: SizedBox(
            height: 200,
            child: Column(
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
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*')),
                        ],
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            net = double.parse(value);
                            double totalWithGST = net +
                                (net *
                                    Val.gstPrecentage); // Assuming GST is 10%
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
                            net = totalWithGST /
                                Val.gstTotalPrecentage; // Reverse GST calculation
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
                        width: 100.0,
                        labelText: 'Quantity',
                        controller: qtyController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^-?\d*'))
                        ],
                      ),
                    ],
                  ),
                ),
                PosTextFormField(
                  width: 400.0,
                  height: 100,
                  maxLines: 3,
                  labelText: 'Comment',
                  controller: commentController,
                ),
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

                Cart newCart = oldCart.copyWith(
                    comment: commnet, netPrice: itemPrice, qty: qty);
                if (list.isNotEmpty) {
                  await CartDB().updateOldCart(list[0], newCart);
                } else {
                  await CartDB().updateCart(oldCart, newCart);
                }
                await invoiceController.updateCart();

                Navigator.of(context).pop();
              },
              child: const Text('Update Item'),
            ),
          ],
        );
      },
    );
  }

  Future<void> editExtraDialog(int index) async {
    ExtraCharges oldExtra = invoiceController.extraList[index];
    TextEditingController netPriceController =
        TextEditingController(text: MyFormat.formatPrice(oldExtra.price));
    TextEditingController totalPriceController = TextEditingController(
        text: MyFormat.formatPrice(oldExtra.price * Val.gstTotalPrecentage));
    TextEditingController commentController =
        TextEditingController(text: oldExtra.comment);
    TextEditingController qtyController =
        TextEditingController(text: oldExtra.qty.toString());
    TextEditingController nameController =
        TextEditingController(text: oldExtra.name);
    double net = 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Add Extra Charges'),
              IconButton(
                  onPressed: () {
                    invoiceController.extraList.removeAt(index);
                    invoiceController.updateExtraTotal();

                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red.shade900,
                  ))
            ],
          ),
          content: SizedBox(
            height: 250,
            child: Column(
              children: [
                PosTextFormField(
                  width: 400.0,
                  labelText: 'Name',
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter extra charges name';
                    }
                    return null;
                  },
                ),
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
                            double totalWithGST = net +
                                (net *
                                    Val.gstPrecentage); // Assuming GST is 10%
                            totalPriceController.text =
                                totalWithGST.toStringAsFixed(2);
                          } else {
                            totalPriceController.clear();
                          }
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      PosTextFormField(
                        width: 100.0,
                        controller: totalPriceController,
                        labelText: 'Total Price',
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*')),
                        ],
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            double totalWithGST = double.parse(value);
                            net = totalWithGST /
                                Val.gstTotalPrecentage; // Reverse GST calculation
                            netPriceController.text = net.toStringAsFixed(2);
                          } else {
                            netPriceController.clear();
                          }
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      PosTextFormField(
                        width: 100.0,
                        labelText: 'Quantity',
                        controller: qtyController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^-?\d*'))
                        ],
                      ),
                    ],
                  ),
                ),
                PosTextFormField(
                  width: 400.0,
                  height: 80.0,
                  maxLines: 3,
                  labelText: 'Comment',
                  controller: commentController,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                double itemPrice = net;
                String commnet = commentController.text;
                String name = nameController.text;
                int qty = qtyController.text.isEmpty
                    ? 0
                    : int.parse(qtyController.text);
                if (name.isNotEmpty && itemPrice >= 0) {
                  ExtraCharges extraCharges = ExtraCharges(
                      name: name, qty: qty, price: itemPrice, comment: commnet);
                  invoiceController.extraList[index] = extraCharges;
                  invoiceController.updateExtraTotal();
                } else {
                  AlertMessage.snakMessage('Invalid Input', context);
                }
                Navigator.of(context).pop();
              },
              child: Text('Update Item'),
            ),
          ],
        );
      },
    );
  }
}
