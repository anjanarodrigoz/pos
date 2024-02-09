import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos/database/invoice_db_service.dart';
import 'package:pos/utils/constant.dart';
import 'package:pos/utils/my_format.dart';
import 'package:pos/utils/val.dart';
import 'package:pos/widgets/pos_appbar.dart';
import 'package:pos/widgets/verify_dialog.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../models/invoice.dart';
import '../../models/payment.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late final _databaseService; // Use your DatabaseService class

  List<Payment> _payments = [];
  PaymentDataSource paymentDataSource = PaymentDataSource(paymentsData: []);
  Function? disposeListen;

  @override
  void initState() {
    super.initState();
    _databaseService = InvoiceDB();

    disposeListen = GetStorage(DBVal.invoice).listen(() {
      getPaymentData();
    });
    getPaymentData();
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
      appBar: const PosAppBar(title: 'Payments'),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: SfDataGrid(
              gridLinesVisibility: GridLinesVisibility.both,
              headerGridLinesVisibility: GridLinesVisibility.both,
              allowFiltering: true,
              rowHeight: Const.tableRowHeight,
              allowColumnsResizing: true,
              showFilterIconOnHover: true,
              columnWidthMode: ColumnWidthMode.auto,
              source: paymentDataSource,
              onCellDoubleTap: ((details) {
                if (details.rowColumnIndex.rowIndex != 0) {
                  int selectedRowIndex = details.rowColumnIndex.rowIndex - 1;
                  var row = paymentDataSource.effectiveRows
                      .elementAt(selectedRowIndex);

                  String invoiceId = row.getCells()[3].value;
                  String payId = row.getCells()[2].value;

                  removePayment(invoiceId, payId);
                }
              }),
              columns: [
                GridColumn(
                    width: 120.0,
                    columnName: Payment.dateKey,
                    label: const Center(child: Text('Date'))),
                GridColumn(
                    width: 100.0,
                    columnName: Payment.timeKey,
                    label: const Center(child: Text('Time'))),
                GridColumn(
                    columnName: Payment.payIdKey,
                    label: const Center(child: Text('Pay ID'))),
                GridColumn(
                    columnName: Invoice.invoiceIdKey,
                    label: const Center(child: Text('Invoice ID'))),

                GridColumn(
                    columnName: Payment.paymethodKey,
                    label: const Center(child: Text('Payment Method'))),
                GridColumn(
                    columnName: Payment.amountKey,
                    label: const Center(child: Text('Pay Amount'))),
                GridColumn(
                    columnName: Payment.commentKey,
                    label: const Center(child: Text('Comment'))),
                GridColumn(
                    columnName: Invoice.customerNameKey,
                    label: const Center(child: Text('Name'))),
                GridColumn(
                    width: 80.0,
                    columnName: Invoice.customerIdKey,
                    label: const Center(child: Text('ID'))),
                // Add more columns as needed
              ],
            ),
          )
        ]),
      ),
    );
  }

  Future<void> getPaymentData() async {
    List<Invoice> invoices = await _databaseService.getAllInvoices();

    _payments = [];

    for (Invoice invoice in invoices) {
      for (Payment payment in invoice.payments ?? []) {
        _payments.add(Payment(
            date: payment.date,
            amount: payment.amount,
            paymethod: payment.paymethod,
            comment: payment.comment,
            payId: payment.payId,
            invoiceId: invoice.invoiceId,
            customerName: invoice.customerName,
            customerId: invoice.customerId));
      }
    }

    _payments.sort((a, b) => b.date.compareTo(a.date));

    paymentDataSource = PaymentDataSource(paymentsData: _payments);
    setState(() {});
  }

  Future<void> removePayment(String invoiceId, String payId) async {
    showDialog(
        context: context,
        builder: (context) => POSVerifyDialog(
              title: 'Delete Payament',
              content:
                  'Do you want to delete in #$invoiceId invoice #$payId payment?',
              onContinue: () async {
                await InvoiceDB()
                    .removeInvoicePayment(invoiceId, payId, context);
                Get.back();
              },
              continueText: 'Delete',
              verifyText: payId,
            ));
  }
}

class PaymentDataSource extends DataGridSource {
  List<DataGridRow> _paymentsData = [];

  PaymentDataSource({required List<Payment> paymentsData}) {
    _paymentsData = paymentsData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell(columnName: Payment.dateKey, value: e.date),
              DataGridCell(columnName: Payment.timeKey, value: e.date),
              DataGridCell(columnName: Payment.payIdKey, value: e.payId),
              DataGridCell(
                  columnName: Invoice.invoiceIdKey, value: e.invoiceId),
              DataGridCell(
                  columnName: Payment.paymethodKey,
                  value: e.paymethod.displayName),
              DataGridCell(columnName: Payment.amountKey, value: e.amount),
              DataGridCell(columnName: Payment.commentKey, value: e.comment),
              DataGridCell(
                  columnName: Invoice.customerNameKey, value: e.customerName),
              DataGridCell(
                  columnName: Invoice.customerIdKey, value: e.customerId),
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => _paymentsData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    // TODO: implement buildRow
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      if (e.columnName == Payment.dateKey) {
        return Container(
          alignment: Alignment.center,
          padding: Const.tableValuesPadding,
          child: Text(MyFormat.formatDateOne(e.value),
              style: Const.tableValuesTextStyle),
        );
      }
      if (e.columnName == Payment.timeKey) {
        return Container(
          alignment: Alignment.center,
          padding: Const.tableValuesPadding,
          child: Text(MyFormat.formatTime(e.value),
              style: Const.tableValuesTextStyle),
        );
      }
      if (e.columnName == Payment.amountKey) {
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
