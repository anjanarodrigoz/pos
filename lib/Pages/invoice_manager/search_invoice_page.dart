import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos/Pages/invoice_manager/invoice_page.dart';
import 'package:pos/database/invoice_db_service.dart';
import 'package:pos/models/invoice.dart';
import 'package:pos/theme/t_colors.dart';
import 'package:pos/utils/constant.dart';
import 'package:pos/utils/my_format.dart';
import 'package:pos/utils/val.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class InvoiceSearchPage extends StatefulWidget {
  const InvoiceSearchPage({super.key});

  @override
  State<InvoiceSearchPage> createState() => _InvoiceSearchPageState();
}

class _InvoiceSearchPageState extends State<InvoiceSearchPage> {
  late final _databaseService; // Use your DatabaseService class

  List<Invoice> _invoice = [];
  InvoiceDataSource invoiceDataSource = InvoiceDataSource(invoiceData: []);
  Function? disposeListen;

  @override
  void initState() {
    super.initState();
    _databaseService = InvoiceDB();

    disposeListen = GetStorage(DBVal.invoice).listen(() {
      getInvoiceData();
    });
    getInvoiceData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    disposeListen?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40.0,
        backgroundColor: TColors.blue,
        leading: IconButton(
            onPressed: () {
              Get.offAll(InvoicePage());
            },
            icon: const Icon(Icons.arrow_back_outlined)),
        title: Text(
          'Search Invoice',
          style: TStyle.titleBarStyle,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: SfDataGrid(
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
                  int selectedRowIndex = details.rowColumnIndex.rowIndex - 1;
                  var row = invoiceDataSource.effectiveRows
                      .elementAt(selectedRowIndex);
                  String invoiceId = row.getCells()[0].value;

                  Get.offAll(InvoicePage(
                    searchInvoiceId: invoiceId,
                  ));
                }
              }),
              columns: [
                GridColumn(
                    width: 120.0,
                    columnName: Invoice.invoiceIdKey,
                    label: const Center(child: Text('Invoice ID'))),
                GridColumn(
                    columnWidthMode: ColumnWidthMode.fitByCellValue,
                    columnName: Invoice.customerNameKey,
                    label: const Center(child: Text('Name'))),
                GridColumn(
                    width: 70.0,
                    columnName: Invoice.customerIdKey,
                    label: const Center(child: Text('ID'))),
                GridColumn(
                    width: 180,
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
                GridColumn(
                    columnName: Invoice.paykey,
                    label: const Center(child: Text('Out Standing'))),

                // Add more columns as needed
              ],
            ),
          )
        ]),
      ),
    );
  }

  Future<void> getInvoiceData() async {
    _invoice = await _databaseService.getAllInvoices();
    invoiceDataSource =
        InvoiceDataSource(invoiceData: _invoice.reversed.toList());
    setState(() {});
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
          padding: Const.tableValuesPadding,
          child: Text(
            MyFormat.formatDate(e.value),
            style: Const.tableValuesTextStyle,
          ),
        );
      }

      if (e.columnName == Invoice.netKey ||
          e.columnName == Invoice.gstKey ||
          e.columnName == Invoice.totalKey ||
          e.columnName == Invoice.paykey) {
        return Container(
          alignment: Alignment.centerRight,
          padding: Const.tableValuesPadding,
          child: Text(
            MyFormat.formatCurrency(e.value),
            style: Const.tableValuesTextStyle,
          ),
        );
      }

      return Container(
        alignment: Alignment.center,
        padding: Const.tableValuesPadding,
        child: Text(
          e.value.toString(),
          style: Const.tableValuesTextStyle,
        ),
      );
    }).toList());
  }
}
