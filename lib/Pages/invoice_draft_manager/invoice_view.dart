import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/controllers/invoice_draft_contorller.dart';
import 'package:pos/data_sources/invoiceDataSource.dart';
import 'package:pos/database/Cart_db_service.dart';
import 'package:pos/enums/enums.dart';
import 'package:pos/models/customer.dart';
import 'package:pos/models/extra_charges.dart';
import '../../models/invoice_row.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../models/cart.dart';
import '../../theme/t_colors.dart';
import '../../utils/my_format.dart';
import '../../utils/val.dart';

class InvoiceView extends StatefulWidget {
  InvoiceView({
    super.key,
  });

  @override
  State<InvoiceView> createState() => _InvoiceViewState();
}

class _InvoiceViewState extends State<InvoiceView> {
  final ScrollController controller = ScrollController();
  final ScrollController controller2 = ScrollController();
  late Customer customer;
  late InvoiceDraftController invoiceController;
  final dbService = CartDB();
  InvoiceDataSource invoiceDataSource = InvoiceDataSource(invoiceData: []);
  late String invoiceId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    invoiceController = Get.find<InvoiceDraftController>();
    customer = invoiceController.customer;
    invoiceId = invoiceController.invoiceId.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1100,
      padding: EdgeInsets.all(10.0),
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
                              'Invoice #$invoiceId',
                              style: const TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            detailsRowWidget('Customer ID', customer.id),
                            const SizedBox(
                              height: 5.0,
                            ),
                            detailsRowWidget('Customer Name',
                                '${customer.firstName} ${customer.lastName}'),
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
    return Obx(() => Expanded(
          child: SfDataGrid(
            gridLinesVisibility: GridLinesVisibility.both,
            headerGridLinesVisibility: GridLinesVisibility.both,
            allowColumnsResizing: true,
            rowHeight: 25.0,
            columnWidthMode: ColumnWidthMode.auto,
            source: generateDataRowList(invoiceController.cartList,
                invoiceController.extraList, invoiceController.comments),
            // onCellTap: ((details) {
            //   if (details.rowColumnIndex.rowIndex != 0) {
            //     int selectedRowIndex = details.rowColumnIndex.rowIndex - 1;
            //     var row = itemDataSource.effectiveRows
            //         .elementAt(selectedRowIndex);

            //     addItemtoList(row.getCells()[0].value.toString());
            //   }
            // }),
            columns: [
              GridColumn(
                  minimumWidth: 120,
                  columnName: InvoiceRow.itemIdKey,
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
          ),
        ));
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
        .map((e) => InvoiceRow(itemName: {InvoiceItemCategory.comment: e}))
        .toList();
  }

  InvoiceDataSource generateDataRowList(List<Cart> cartList,
      List<ExtraCharges> extraList, List<String> comments) {
    List<InvoiceRow> invoiceData = [];

    for (Cart cart in cartList) {
      invoiceData.add(InvoiceRow(
          itemId: cart.itemId,
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
      InvoiceRow(itemName: {InvoiceItemCategory.empty: ''})
    ];

    for (ExtraCharges chrage in extraList) {
      double gstPrice = (chrage.price * Val.gstPrecentage);
      double itemPrcie = (chrage.price * Val.gstTotalPrecentage);
      double totalPrice = (itemPrcie * chrage.qty);
      invoiceData.add(InvoiceRow(
        itemId: '#',
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
      InvoiceRow(itemName: {InvoiceItemCategory.empty: ''})
    ];
    for (String comment in comments) {
      invoiceData += commentDataRow(comment);
    }
    invoiceData += [
      InvoiceRow(itemName: {InvoiceItemCategory.empty: ''})
    ];

    return InvoiceDataSource(invoiceData: invoiceData);
  }
}
