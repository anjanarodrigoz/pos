import 'package:flutter/material.dart';
import 'package:pos/models/invoice_item.dart';

import '../../models/cart.dart';
import '../../models/extra_charges.dart';
import '../../models/invoice.dart';
import '../../theme/t_colors.dart';
import '../../utils/my_format.dart';
import '../../utils/val.dart';
import '../../widgets/paid_status_widget.dart';

class SaveInvoiceViewPage extends StatelessWidget {
  Invoice invoice;

  SaveInvoiceViewPage({super.key, required this.invoice});

  final ScrollController controller = ScrollController();
  final ScrollController controller2 = ScrollController();
  List<ExtraCharges> extraList = [];
  List<String> comments = [];
  double gstPrecentage = Val.gstPrecentage;
  List<InvoicedItem> invoicedItemList = [];
  double totalNetPrice = 0;
  double totalGstPrice = 0;
  double total = 0;

  @override
  Widget build(BuildContext context) {
    gstPrecentage = invoice.gstPrecentage;
    extraList = invoice.extraCharges ?? [];
    invoicedItemList = invoice.itemList;
    comments = invoice.comments ?? [];
    List prices = invoice.calculteTotalNetPrice();
    totalNetPrice = prices[0];
    totalGstPrice = prices[1];
    total = prices[2];

    return Container(
      width: 1100,
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Card(
            elevation: 5.0,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Invoice #${invoice.invoiceId}',
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                      PaidStatus(isPaid: invoice.isPaid)
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 10.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              detailsRowWidget(
                                  'Customer ID', invoice.customerId),
                              const SizedBox(
                                height: 5.0,
                              ),
                              detailsRowWidget('Name', invoice.customerName),
                              const SizedBox(
                                height: 5.0,
                              ),
                              detailsRowWidget(
                                  'Mobile', invoice.customerMobile),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              detailsRowWidget('Created',
                                  MyFormat.formatDate(invoice.createdDate)),
                              const SizedBox(
                                height: 5.0,
                              ),
                              detailsRowWidget(
                                  'Closed',
                                  invoice.closeDate != null
                                      ? MyFormat.formatDate(invoice.closeDate!)
                                      : ''),
                            ],
                          ),
                          SizedBox(
                            width: 150,
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
                                const SizedBox(
                                  height: 5.0,
                                ),
                                detailsRowWidget(
                                    'Total', MyFormat.formatCurrency(total)),
                                const SizedBox(
                                  height: 5.0,
                                ),
                              ],
                            ),
                          )
                        ]),
                  ),
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
      child: Scrollbar(
        controller: controller2,
        child: SingleChildScrollView(
          controller: controller2,
          scrollDirection: Axis.horizontal,
          child: Scrollbar(
            controller: controller,
            thumbVisibility: true,
            trackVisibility: true,
            child: SingleChildScrollView(
              controller: controller,
              scrollDirection: Axis.vertical,
              child: DataTable(
                  dataRowHeight: 22.0,
                  headingRowColor:
                      MaterialStateProperty.all<Color>(Colors.grey.shade300),
                  border: TableBorder(
                    top: BorderSide(),
                    bottom: BorderSide(),
                    left: BorderSide(),
                    right: BorderSide(),
                    verticalInside: BorderSide(),
                  ),
                  columns: const [
                    DataColumn(label: Text('Item Id')),
                    DataColumn(label: Text('Item Name')),
                    DataColumn(label: Text('Qty')),
                    DataColumn(label: Text('Net Price'), numeric: true),
                    DataColumn(label: Text('GST'), numeric: true),
                    DataColumn(label: Text('Item Price'), numeric: true),
                    DataColumn(label: Text('Total'), numeric: true),
                  ],
                  rows: generateDataRowList(invoicedItemList)),
            ),
          ),
        ),
      ),
    );
  }

  Widget cell(
    String value,
  ) {
    return Container(
      child: Text(
        value,
        style: TStyle.style_01,
      ),
    );
  }

  commentDataRow(String comment) {
    return comment
        .split('\n')
        .map((e) => DataRow(cells: [
              DataCell(
                cell(''),
              ),
              DataCell(SizedBox(
                width: 400.0,
                child: Text(
                  e,
                  style: TStyle.style_02,
                ),
              )),
              DataCell(
                cell(''),
              ),
              DataCell(
                cell(''),
              ),
              DataCell(
                cell(''),
              ),
              DataCell(
                cell(''),
              ),
              DataCell(
                cell(''),
              )
            ]))
        .toList();
  }

  DataRow dataRow(
          {required String id,
          required String name,
          required int qty,
          required double netPrice,
          required double gst,
          required double itemPrice,
          required double total}) =>
      DataRow(cells: [
        DataCell(
          cell(id),
        ),
        DataCell(cell(name)),
        DataCell(cell('$qty')),
        DataCell(cell(MyFormat.formatCurrency(netPrice))),
        DataCell(cell(MyFormat.formatCurrency(gst))),
        DataCell(cell(MyFormat.formatCurrency(itemPrice))),
        DataCell(cell(MyFormat.formatCurrency(total)))
      ]);

  List<DataRow> generateDataRowList(List<InvoicedItem> cartList) {
    List<DataRow> dataRowList = [];

    for (InvoicedItem invoicedItem in cartList) {
      String itemId = invoicedItem.isPostedItem
          ? 'P ${invoicedItem.itemId}'
          : invoicedItem.itemId;

      double gstPrice = (invoicedItem.netPrice * gstPrecentage);
      double itemPrcie = (invoicedItem.netPrice * (1 + gstPrecentage));
      double totalPrice = (itemPrcie * invoicedItem.qty);
      dataRowList.add(dataRow(
        id: itemId,
        name: invoicedItem.name,
        gst: gstPrice,
        netPrice: invoicedItem.netPrice,
        itemPrice: itemPrcie,
        total: totalPrice,
        qty: invoicedItem.qty,
      ));

      if (invoicedItem.comment != null) {
        if (invoicedItem.comment!.isNotEmpty) {
          dataRowList += commentDataRow(invoicedItem.comment!);
        }
      }
    }
    dataRowList += commentDataRow('');

    for (ExtraCharges chrage in extraList) {
      double gstPrice = (chrage.price * gstPrecentage);
      double itemPrcie = (chrage.price * (1 + gstPrecentage));
      double totalPrice = (itemPrcie * chrage.qty);
      dataRowList.add(dataRow(
        id: '# ${extraList.indexOf(chrage) + 1}',
        name: chrage.name,
        gst: gstPrice,
        netPrice: chrage.price,
        itemPrice: itemPrcie,
        total: totalPrice,
        qty: chrage.qty,
      ));

      if (chrage.comment != null) {
        if (chrage.comment!.isNotEmpty) {
          dataRowList += commentDataRow(chrage.comment!);
        }
      }
    }

    dataRowList += commentDataRow('');

    for (String comment in comments) {
      dataRowList += commentDataRow(comment);
    }

    return dataRowList;
  }
}
