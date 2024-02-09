import 'package:flutter/material.dart';
import 'package:pos/models/invoice_item.dart';
import 'package:pos/utils/constant.dart';
import 'package:pos/widgets/outstanding_date_widget.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../data_sources/invoiceDataSource.dart';
import '../../enums/enums.dart';
import '../../models/extra_charges.dart';
import '../../models/invoice.dart';
import '../../models/invoice_row.dart';
import '../../models/supply_invoice.dart';
import '../../theme/t_colors.dart';
import '../../utils/my_format.dart';
import '../../utils/val.dart';
import '../../widgets/paid_status_widget.dart';

class QuoteInvoicePage extends StatelessWidget {
  Invoice invoice;

  QuoteInvoicePage({super.key, required this.invoice});

  final ScrollController controller = ScrollController();

  final ScrollController controller2 = ScrollController();

  List<ExtraCharges> extraList = [];

  List<String> comments = [];

  double gstPrecentage = Val.gstPrecentage;

  List<InvoicedItem> invoicedItemList = [];

  double totalNetPrice = 0;

  double totalGstPrice = 0;

  double total = 0;

  late BuildContext context;

  InvoiceDataSource invoiceDataSource = InvoiceDataSource(invoiceData: []);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    gstPrecentage = invoice.gstPrecentage;
    extraList = invoice.extraCharges ?? [];
    invoicedItemList = invoice.itemList;
    comments = invoice.comments ?? [];
    totalNetPrice = invoice.totalNetPrice;
    totalGstPrice = invoice.totalGstPrice;
    total = invoice.total;

    return SizedBox(
      width: MediaQuery.of(context).size.width - 200,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              elevation: 5.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'INVOICE  #${invoice.invoiceId}',
                                          style: const TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          MyFormat.formatDate(
                                              invoice.createdDate),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 1,
                            height: 70,
                            color: Colors.black,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              detailsRowWidget(
                                  'Customer ID  ', invoice.customerId),
                              const SizedBox(
                                height: 5.0,
                              ),
                              detailsRowWidget('Name  ', invoice.customerName),
                              const SizedBox(
                                height: 5.0,
                              ),
                              detailsRowWidget(
                                  'Mobile  ', invoice.customerMobile),
                            ],
                          ),
                          Container(
                            width: 1,
                            height: 70,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 150.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                detailsRowWidget('Net Total',
                                    MyFormat.formatCurrency(totalNetPrice)),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                detailsRowWidget('GST Total',
                                    MyFormat.formatCurrency(totalGstPrice)),
                                const Divider(),
                                detailsRowWidget(
                                    'Total', MyFormat.formatCurrency(total)),
                              ],
                            ),
                          ),
                        ]),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: invoiceItemView(),
          )
        ],
      ),
    );
  }

  Widget detailsRowWidget(String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$key ',
          style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w400,
              fontSize: 14.0),
        ),
        Text(
          value,
          style: const TextStyle(
              color: TColors.blue, fontWeight: FontWeight.w700, fontSize: 14.0),
        )
      ],
    );
  }

  invoiceItemView() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 200,
      height: MediaQuery.of(context).size.height - 250,
      child: SfDataGrid(
        gridLinesVisibility: GridLinesVisibility.both,
        headerGridLinesVisibility: GridLinesVisibility.both,
        allowColumnsResizing: true,
        rowHeight: Const.tableRowHeight,
        columnWidthMode: ColumnWidthMode.auto,
        allowSwiping: true,
        source: generateDataRowList(),
        columns: [
          GridColumn(
              columnName: InvoiceRow.itemIdKey,
              label: const Center(child: Text('Item ID'))),
          GridColumn(
              maximumWidth: 300.0,
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
      ),
    );
  }

  Widget cell(
    String value,
  ) {
    return Container(
      child: Text(
        value,
        style: Const.tableValuesTextStyle,
      ),
    );
  }

  commentDataRow(String comment) {
    return comment
        .split('\n')
        .map((e) => InvoiceRow(
            itemId: {-1: ''}, itemName: {InvoiceItemCategory.comment: e}))
        .toList();
  }

  InvoiceDataSource generateDataRowList() {
    List<InvoiceRow> invoiceData = [];

    for (InvoicedItem item in invoicedItemList) {
      String itemId = item.isPostedItem ? 'P ${item.itemId}' : item.itemId;
      invoiceData.add(InvoiceRow(
          itemId: {invoicedItemList.indexOf(item): itemId},
          itemName: {InvoiceItemCategory.item: item.name},
          gst: MyFormat.formatCurrency(item.netPrice * invoice.gstPrecentage),
          netPrice: MyFormat.formatCurrency(item.netPrice),
          itemPrice: MyFormat.formatCurrency(
              item.netPrice * (1 + invoice.gstPrecentage)),
          total: MyFormat.formatCurrency(
              item.netTotal * (1 + invoice.gstPrecentage)),
          qty: item.qty.toString()));

      if (item.comment != null) {
        if (item.comment!.isNotEmpty) {
          invoiceData += commentDataRow(item.comment!);
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
}
