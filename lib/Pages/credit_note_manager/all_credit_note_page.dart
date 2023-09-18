import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:pos/Pages/credit_note_manager/credit_note_page.dart';
import 'package:pos/Pages/invoice_draft_manager/invoice_customer_select.dart';

import 'package:pos/Pages/invoice_manager/invoice_page.dart';
import 'package:pos/Pages/main_window.dart';
import 'package:pos/Pages/quotation_manager/quatation_page.dart';
import 'package:pos/database/credit_db_serive.dart';

import 'package:pos/database/quatation_db_serive.dart';
import 'package:pos/enums/enums.dart';
import 'package:pos/models/invoice.dart';
import 'package:pos/theme/t_colors.dart';
import 'package:pos/utils/my_format.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:window_manager/window_manager.dart';

import '../../widgets/pos_button.dart';

class AllCreditNotePage extends StatelessWidget {
  AllCreditNotePage({super.key});

  // Use your DatabaseService class

  List<Invoice> _invoice = [];
  InvoiceDataSource invoiceDataSource = InvoiceDataSource(invoiceData: []);

  @override
  Widget build(BuildContext context) {
    WindowOptions windowOptions = const WindowOptions(
        minimumSize: Size(1300, 800), size: Size(1300, 800), center: true);

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColors.blue,
        leading: IconButton(
            onPressed: () {
              Get.offAll(const MainWindow());
            },
            icon: Icon(Icons.arrow_back_outlined)),
        title: Text(
          'Credit Note',
          style: TStyle.titleBarStyle,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 10.0,
          ),
          PosButton(
            text: ' + Add Credit Note',
            onPressed: () {
              Get.to((InvoiceCustomerSelectPage(
                invoiceType: InvoiceType.creditNote,
              )));
            },
            width: 200.0,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: StreamBuilder(
                  stream: CreditNoteDB().getStreamInvoice(),
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
                        child: Text('+ Add Credit Note'),
                      );
                    }
                    return SfDataGrid(
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      allowFiltering: true,
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

                          Get.offAll(CreditNotePage(
                            invoiceId: invoiceId,
                          ));
                        }
                      }),
                      columns: [
                        GridColumn(
                            columnName: Invoice.invoiceIdKey,
                            label: Center(child: const Text('Invoice ID'))),
                        GridColumn(
                            columnName: Invoice.customerNameKey,
                            label: Center(child: const Text('Customer Name'))),
                        GridColumn(
                            columnName: Invoice.customerIdKey,
                            label: Center(child: const Text('Customer ID'))),
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
                        GridColumn(
                            columnName: Invoice.paykey,
                            label: Center(child: const Text('Out Standing'))),

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
              DataGridCell(columnName: Invoice.paykey, value: e.toPay),
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
          padding: EdgeInsets.all(8.0),
          child: Text(MyFormat.formatDate(e.value)),
        );
      }

      if (e.columnName == Invoice.netKey ||
          e.columnName == Invoice.gstKey ||
          e.columnName == Invoice.totalKey ||
          e.columnName == Invoice.paykey) {
        return Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.all(8.0),
          child: Text(MyFormat.formatCurrency(e.value)),
        );
      }

      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}
