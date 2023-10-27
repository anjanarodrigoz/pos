import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:pos/Pages/main_window.dart';

import 'package:pos/Pages/stock_manager.dart/stock_page.dart';
import 'package:pos/Pages/supply_invoice_manager/supply_invoice_page.dart';
import 'package:pos/database/supplyer_invoice_db_service.dart';
import 'package:pos/models/invoice.dart';
import 'package:pos/theme/t_colors.dart';
import 'package:pos/utils/my_format.dart';
import 'package:pos/widgets/pos_appbar.dart';
import 'package:pos/widgets/pos_button.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../models/supply_invoice.dart';
import 'select_supplyer_page.dart';

class SupplyAllInvoice extends StatelessWidget {
  SupplyAllInvoice({super.key});

  List<SupplyInvoice> supplyInvoice = [];
  SupplyInvoiceDataSource invoiceDataSource =
      SupplyInvoiceDataSource(invoiceData: []);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PosAppBar(title: 'Supply Invoice'),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 10.0,
          ),
          PosButton(
            text: ' + Add Supply Invoice',
            onPressed: () {
              Get.to(SelectSupplyerPage());
            },
            width: 200.0,
          ),
          Expanded(
            child: FutureBuilder(
                future: SupplyerInvoiceDB().getAllInvoices(),
                builder: (context, snapshot) {
                  supplyInvoice = snapshot.data ?? [];
                  invoiceDataSource = SupplyInvoiceDataSource(
                      invoiceData: supplyInvoice.reversed.toList());

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (supplyInvoice.isEmpty) {
                    return const Center(
                      child: Text('+ Add Supply invoices'),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: SfDataGrid(
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      allowFiltering: true,
                      rowHeight: 30.0,
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

                          Get.to(SupplyInvoicePage(
                            invoiceId: invoiceId,
                          ));
                        }
                      }),
                      columns: [
                        GridColumn(
                            columnName: Invoice.invoiceIdKey,
                            label: Center(child: const Text('Invoice ID'))),
                        GridColumn(
                            columnName: Invoice.invoiceIdKey,
                            label: Center(child: const Text('Reference ID'))),
                        GridColumn(
                            columnName: Invoice.customerNameKey,
                            label: Center(child: const Text('Supplyer Name'))),
                        GridColumn(
                            columnName: Invoice.customerIdKey,
                            label: Center(child: const Text('Supplyer ID'))),
                        GridColumn(
                            columnName: Invoice.createdDateKey,
                            label: Center(child: const Text('Created Date'))),
                        GridColumn(
                            columnName: Invoice.netKey,
                            label: Center(child: const Text('Net Total'))),
                        GridColumn(
                            columnName: Invoice.gstKey,
                            label: Center(child: const Text('GST Total'))),
                        GridColumn(
                            columnName: Invoice.totalKey,
                            label: Center(child: const Text('Total'))),

                        // Add more columns as needed
                      ],
                    ),
                  );
                }),
          )
        ]),
      ),
    );
  }
}

class SupplyInvoiceDataSource extends DataGridSource {
  List<DataGridRow> _customersData = [];

  SupplyInvoiceDataSource({required List<SupplyInvoice> invoiceData}) {
    _customersData = invoiceData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell(
                  columnName: Invoice.invoiceIdKey, value: e.invoiceId),
              DataGridCell(
                  columnName: Invoice.invoiceIdKey, value: e.referenceId),
              DataGridCell(
                  columnName: Invoice.customerNameKey, value: e.supplyerName),
              DataGridCell(
                  columnName: Invoice.customerIdKey, value: e.supplyerId),
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
          padding: EdgeInsets.all(4.0),
          child: Text(
            MyFormat.formatDate(e.value),
            style: const TextStyle(fontSize: 13.0),
          ),
        );
      }

      if (e.columnName == Invoice.netKey ||
          e.columnName == Invoice.gstKey ||
          e.columnName == Invoice.totalKey ||
          e.columnName == Invoice.paykey) {
        return Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.all(4.0),
          child: Text(
            MyFormat.formatCurrency(e.value),
            style: const TextStyle(fontSize: 13.0),
          ),
        );
      }

      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(4.0),
        child: Text(
          e.value.toString(),
          style: const TextStyle(fontSize: 13.0),
        ),
      );
    }).toList());
  }
}
