import 'package:flutter/material.dart';
import 'package:pos/models/invoice_item.dart';
import 'package:pos/utils/constant.dart';
import 'package:pos/widgets/invoice_summery_card.dart';
import 'package:pos/widgets/outstanding_date_widget.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../data_sources/invoiceDataSource.dart';
import '../../enums/enums.dart';
import '../../models/extra_charges.dart';
import '../../models/invoice.dart';
import '../../models/invoice_row.dart';
import '../../theme/t_colors.dart';
import '../../utils/my_format.dart';
import '../../utils/val.dart';
import '../../widgets/paid_status_widget.dart';

class SaveInvoiceViewPage extends StatefulWidget {
  Invoice invoice;

  SaveInvoiceViewPage({super.key, required this.invoice});

  @override
  State<SaveInvoiceViewPage> createState() => _SaveInvoiceViewPageState();
}

class _SaveInvoiceViewPageState extends State<SaveInvoiceViewPage> {
  final ScrollController controller = ScrollController();

  final ScrollController controller2 = ScrollController();

  List<ExtraCharges> extraList = [];

  List<String> comments = [];

  double gstPrecentage = Val.gstPrecentage;

  List<InvoicedItem> invoicedItemList = [];

  double totalNetPrice = 0;

  double totalGstPrice = 0;

  double total = 0;

  InvoiceDataSource invoiceDataSource = InvoiceDataSource(invoiceData: []);

  @override
  Widget build(BuildContext context) {
    gstPrecentage = widget.invoice.gstPrecentage;
    extraList = widget.invoice.extraCharges ?? [];
    invoicedItemList = widget.invoice.itemList;
    comments = widget.invoice.comments ?? [];
    totalNetPrice = widget.invoice.totalNetPrice;
    totalGstPrice = widget.invoice.totalGstPrice;
    total = widget.invoice.total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: InvoiceSummeryCard(
                invoice: widget.invoice,
              )),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: invoiceItemView(),
        )
      ],
    );
  }

  invoiceItemView() {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 200,
      height: MediaQuery.of(context).size.height - 250,
      child: Align(
        alignment: Alignment.topCenter,
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
          gst: MyFormat.formatCurrency(
              item.netPrice * widget.invoice.gstPrecentage),
          netPrice: MyFormat.formatCurrency(item.netPrice),
          itemPrice: MyFormat.formatCurrency(
              item.netPrice * (1 + widget.invoice.gstPrecentage)),
          total: MyFormat.formatCurrency(
              item.netTotal * (1 + widget.invoice.gstPrecentage)),
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
