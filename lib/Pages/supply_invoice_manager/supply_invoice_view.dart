import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/suppy_invoice_draft_controller.dart';
import 'package:pos/data_sources/invoiceDataSource.dart';
import 'package:pos/database/cart_db_service.dart';
import 'package:pos/enums/enums.dart';
import 'package:pos/models/extra_charges.dart';
import 'package:pos/models/supplyer.dart';
import 'package:pos/utils/alert_message.dart';
import 'package:pos/utils/constant.dart';
import '../../models/invoice_row.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../models/cart.dart';
import '../../theme/t_colors.dart';
import '../../utils/my_format.dart';
import '../../utils/val.dart';
import '../../widgets/pos_text_form_field.dart';

class SupplyInvoiceView extends StatefulWidget {
  const SupplyInvoiceView({
    super.key,
  });

  @override
  State<SupplyInvoiceView> createState() => _SupplyInvoiceViewState();
}

class _SupplyInvoiceViewState extends State<SupplyInvoiceView> {
  final ScrollController controller = ScrollController();
  final ScrollController controller2 = ScrollController();
  late Supplyer supplyer;
  late SupplyInvoiceDraftController invoiceController;
  final dbService = CartDB();
  InvoiceDataSource invoiceDataSource = InvoiceDataSource(invoiceData: []);
  late String invoiceId;
  @override
  late BuildContext context;

  @override
  void initState() {
    super.initState();
    invoiceController = Get.find<SupplyInvoiceDraftController>();
    supplyer = invoiceController.supplyer;
    invoiceId = invoiceController.invoiceId.value;
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
                              invoiceController.isRetunManager
                                  ? 'Retun Note #$invoiceId'
                                  : 'Invoice #$invoiceId',
                              style: const TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            if (!invoiceController.isRetunManager)
                              Obx(() => InkWell(
                                    onTap: () => openDailog(),
                                    child: Text(
                                      'Reference No #${invoiceController.referenceId.value}',
                                      style: const TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                            if (!invoiceController.isRetunManager)
                              const SizedBox(
                                height: 10.0,
                              ),
                            detailsRowWidget('Supplyer ID', supplyer.id),
                            const SizedBox(
                              height: 5.0,
                            ),
                            detailsRowWidget('Supplyer Name',
                                '${supplyer.firstName} ${supplyer.lastName}'),
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
          style:
              const TextStyle(color: TColors.blue, fontWeight: FontWeight.bold),
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
              rowHeight: Const.tableRowHeight,
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
              source: generateDataRowList(invoiceController.cartList,
                  invoiceController.extraList, invoiceController.comments),
              columns: [
                GridColumn(
                    columnName: InvoiceRow.itemIdKey,
                    label: const Center(child: Text('Item ID'))),
                GridColumn(
                    maximumWidth: 400.0,
                    columnName: InvoiceRow.nameKey,
                    label: const Center(child: Text('Item Name'))),
                GridColumn(
                    columnName: InvoiceRow.qtyKey,
                    label: const Center(child: Text('Qty'))),
                GridColumn(
                    columnName: InvoiceRow.netPriceKey,
                    label: const Center(child: Text('Net Price'))),
                GridColumn(
                    columnName: InvoiceRow.gstKey,
                    label: const Center(child: Text('GST'))),
                GridColumn(
                    columnName: InvoiceRow.itemPriceKey,
                    label: const Center(child: Text('Item Price'))),
                GridColumn(
                    columnName: InvoiceRow.totalKey,
                    label: const Center(child: Text('Total'))),

                // Add more columns as needed
              ],
            )));
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
      String itemId = cart.isPostedItem ? 'P ${cart.itemId}' : cart.itemId;
      invoiceData.add(InvoiceRow(
          itemId: {cartList.indexOf(cart): itemId},
          itemName: {InvoiceItemCategory.item: cart.name},
          gst: MyFormat.formatCurrency(cart.gst),
          netPrice: MyFormat.formatCurrency(cart.price),
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
      invoiceData.add(InvoiceRow(
        itemId: {
          extraList.indexOf(chrage): '#${extraList.indexOf(chrage) + 1}'
        },
        itemName: {InvoiceItemCategory.extraChrage: chrage.name},
        gst: MyFormat.formatCurrency(chrage.gst),
        netPrice: MyFormat.formatCurrency(chrage.price),
        itemPrice: MyFormat.formatCurrency(chrage.itemPrice),
        total: MyFormat.formatCurrency(chrage.totalPrice),
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
    Cart oldCart = invoiceController.cartList[index];
    TextEditingController netPriceController = TextEditingController();
    TextEditingController totalPriceController = TextEditingController();
    TextEditingController commentController = TextEditingController();
    TextEditingController qtyController = TextEditingController();
    double net = oldCart.price;
    RxBool isDeliveryItem = oldCart.isPostedItem.obs;
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
                    invoiceController.cartList.remove(oldCart);
                    invoiceController.updateCart();
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
                  height: 60,
                  maxLines: 3,
                  labelText: 'Comment',
                  controller: commentController,
                ),
                const SizedBox(
                  height: 5.0,
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
                  Cart newCart = oldCart.copyWith(
                      comment: commnet,
                      netPrice: itemPrice,
                      qty: qty,
                      isPostedItem: isDeliveryItem.value);
                  invoiceController.cartList[index] = newCart;
                  invoiceController.updateCart();
                }
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
    double net = oldExtra.price;

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
              child: const Text('Update Item'),
            ),
          ],
        );
      },
    );
  }

  void openDailog() {
    TextEditingController realInvoiceIdController =
        TextEditingController(text: invoiceController.referenceId.value);
    showDialog(
        context: context,
        builder: (context) => SizedBox(
              height: 200.0,
              width: 400.0,
              child: AlertDialog(
                title: const Text('Reference ID'),
                content: PosTextFormField(
                    controller: realInvoiceIdController,
                    labelText: 'Reference ID'),
                actions: [
                  TextButton(
                      onPressed: () {
                        invoiceController.referenceId.value =
                            realInvoiceIdController.text;
                        Navigator.of(context).pop();
                      },
                      child: const Text('save')),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('close'))
                ],
              ),
            ));
  }
}
