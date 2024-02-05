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
  bool isRetunManager;
  SupplyAllInvoice({super.key, this.isRetunManager = false});

  List<SupplyInvoice> supplyInvoice = [];
  SupplyInvoiceDataSource invoiceDataSource =
      SupplyInvoiceDataSource(invoiceData: [], isRetunManager: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PosAppBar(title: 'Supply Invoice'),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 10.0,
          ),
          PosButton(
            text:
                isRetunManager ? '+ Add Return Note' : ' + Add Supply Invoice',
            onPressed: () {
              Get.to(SelectSupplyerPage(isRetunManager: isRetunManager));
            },
            width: 200.0,
          ),
          Expanded(
            child: FutureBuilder(
                future: isRetunManager
                    ? SupplyerInvoiceDB().getReturnNotes()
                    : SupplyerInvoiceDB().getNormalInvoice(),
                builder: (context, snapshot) {
                  supplyInvoice = snapshot.data ?? [];
                  invoiceDataSource = SupplyInvoiceDataSource(
                      isRetunManager: isRetunManager,
                      invoiceData: supplyInvoice.reversed.toList());

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (supplyInvoice.isEmpty) {
                    return Center(
                      child: Text(isRetunManager
                          ? '+ Add Return Note'
                          : '+ Add Supply invoices'),
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
                            isReturnManger: isRetunManager,
                          ));
                        }
                      }),
                      columns: [
                        GridColumn(
                            columnName: User.invoiceIdKey,
                            label: const Center(child: Text('Invoice ID'))),
                        if (!isRetunManager)
                          GridColumn(
                              columnName: User.invoiceIdKey,
                              label: const Center(child: Text('Reference ID'))),
                        GridColumn(
                            columnName: User.customerNameKey,
                            label: const Center(child: Text('Supplyer Name'))),
                        GridColumn(
                            columnName: User.customerIdKey,
                            label: const Center(child: Text('Supplyer ID'))),
                        GridColumn(
                            columnName: User.createdDateKey,
                            label: const Center(child: Text('Created Date'))),
                        GridColumn(
                            columnName: User.netKey,
                            label: const Center(child: Text('Net Total'))),
                        GridColumn(
                            columnName: User.gstKey,
                            label: const Center(child: Text('GST Total'))),
                        GridColumn(
                            columnName: User.totalKey,
                            label: const Center(child: Text('Total'))),

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

  SupplyInvoiceDataSource(
      {required List<SupplyInvoice> invoiceData, required isRetunManager}) {
    _customersData = invoiceData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell(columnName: User.invoiceIdKey, value: e.invoiceId),
              if (!isRetunManager)
                DataGridCell(
                    columnName: User.invoiceIdKey, value: e.referenceId),
              DataGridCell(
                  columnName: User.customerNameKey, value: e.supplyerName),
              DataGridCell(columnName: User.customerIdKey, value: e.supplyerId),
              DataGridCell(
                  columnName: User.createdDateKey, value: e.createdDate),
              DataGridCell(columnName: User.netKey, value: e.totalNetPrice),
              DataGridCell(columnName: User.gstKey, value: e.totalGstPrice),
              DataGridCell(columnName: User.totalKey, value: e.total),
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
      if (e.columnName == User.createdDateKey) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(4.0),
          child: Text(
            MyFormat.formatDate(e.value),
            style: const TextStyle(fontSize: 13.0),
          ),
        );
      }

      if (e.columnName == User.netKey ||
          e.columnName == User.gstKey ||
          e.columnName == User.totalKey ||
          e.columnName == User.paykey) {
        return Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(4.0),
          child: Text(
            MyFormat.formatCurrency(e.value),
            style: const TextStyle(fontSize: 13.0),
          ),
        );
      }

      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(4.0),
        child: Text(
          e.value.toString(),
          style: const TextStyle(fontSize: 13.0),
        ),
      );
    }).toList());
  }
}
