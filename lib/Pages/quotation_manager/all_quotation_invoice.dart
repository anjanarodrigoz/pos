import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:pos/Pages/invoice_draft_manager/invoice_customer_select.dart';

import 'package:pos/Pages/invoice_manager/invoice_page.dart';
import 'package:pos/Pages/main_window.dart';
import 'package:pos/Pages/quotation_manager/quatation_page.dart';

import 'package:pos/database/quatation_db_serive.dart';
import 'package:pos/enums/enums.dart';
import 'package:pos/models/invoice.dart';
import 'package:pos/theme/t_colors.dart';
import 'package:pos/utils/constant.dart';
import 'package:pos/utils/my_format.dart';
import 'package:pos/widgets/pos_appbar.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../widgets/pos_button.dart';

class AllQuotesPage extends StatelessWidget {
  AllQuotesPage({super.key});

  // Use your DatabaseService class

  List<Invoice> _invoice = [];
  InvoiceDataSource invoiceDataSource = InvoiceDataSource(invoiceData: []);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PosAppBar(title: 'Quatation'),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 10.0,
          ),
          PosButton(
            text: ' + Add Quote',
            onPressed: () {
              Get.to((const InvoiceCustomerSelectPage(
                invoiceType: InvoiceType.quotation,
              )));
            },
            width: 200.0,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: StreamBuilder(
                  stream: QuotationDB().getStreamInvoice(),
                  builder: (context, snapshot) {
                    _invoice = snapshot.data ?? [];
                    invoiceDataSource = InvoiceDataSource(
                        invoiceData: _invoice.reversed.toList());

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (_invoice.isEmpty) {
                      return const Center(
                        child: Text('+ Add Quote'),
                      );
                    }
                    return SfDataGrid(
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      allowFiltering: true,
                      rowHeight: Const.tableRowHeight,
                      allowColumnsResizing: true,
                      showFilterIconOnHover: true,
                      columnWidthMode: ColumnWidthMode.auto,
                      source: invoiceDataSource,
                      onCellTap: ((details) {
                        if (details.rowColumnIndex.rowIndex != 0) {
                          int selectedRowIndex =
                              details.rowColumnIndex.rowIndex - 1;
                          var row = invoiceDataSource.effectiveRows
                              .elementAt(selectedRowIndex);
                          String invoiceId = row.getCells()[0].value;

                          Get.offAll(QuotationPage(
                            invoiceId: invoiceId,
                          ));
                        }
                      }),
                      columns: [
                        GridColumn(
                            width: 100.0,
                            columnName: Invoice.invoiceIdKey,
                            label: const Center(child: Text('Invoice ID'))),
                        GridColumn(
                            columnName: Invoice.customerNameKey,
                            label: const Center(child: Text('Name'))),
                        GridColumn(
                            width: 80.0,
                            columnName: Invoice.customerIdKey,
                            label: const Center(child: Text('ID'))),
                        GridColumn(
                            width: 180.0,
                            columnName: Invoice.createdDateKey,
                            label: const Center(child: Text('Date'))),
                        GridColumn(
                            columnName: Invoice.netKey,
                            label: const Center(child: Text('Net Total'))),
                        GridColumn(
                            columnName: Invoice.gstKey,
                            label: const Center(child: Text('GST Total'))),
                        GridColumn(
                            columnName: Invoice.totalKey,
                            label: const Center(child: Text('Total'))),

                        // Add more columns as needed
                      ],
                    );
                  }),
            ),
          )
        ]),
      ),
    );
  }
}

class InvoiceDataSource extends DataGridSource {
  List<DataGridRow> _customersData = [];

  InvoiceDataSource({required List<Invoice> invoiceData}) {
    _customersData = invoiceData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell(
                  columnName: Invoice.invoiceIdKey, value: e.invoiceId),
              DataGridCell(
                  columnName: Invoice.customerNameKey, value: e.customerName),
              DataGridCell(
                  columnName: Invoice.customerIdKey, value: e.customerId),
              DataGridCell(
                  columnName: Invoice.createdDateKey, value: e.createdDate),
              DataGridCell(columnName: Invoice.netKey, value: e.totalNetPrice),
              DataGridCell(columnName: Invoice.gstKey, value: e.totalGstPrice),
              DataGridCell(columnName: Invoice.totalKey, value: e.total),
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => _customersData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    // TODO: implement buildRow
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      if (e.columnName == Invoice.createdDateKey) {
        return Container(
          alignment: Alignment.center,
          padding: Const.tableValuesPadding,
          child: Text(MyFormat.formatDate(e.value),
              style: Const.tableValuesTextStyle),
        );
      }

      if (e.columnName == Invoice.netKey ||
          e.columnName == Invoice.gstKey ||
          e.columnName == Invoice.totalKey) {
        return Container(
          alignment: Alignment.centerRight,
          padding: Const.tableValuesPadding,
          child: Text(MyFormat.formatCurrency(e.value),
              style: Const.tableValuesTextStyle),
        );
      }

      return Container(
        alignment: Alignment.center,
        padding: Const.tableValuesPadding,
        child: Text(e.value.toString(), style: Const.tableValuesTextStyle),
      );
    }).toList());
  }
}
