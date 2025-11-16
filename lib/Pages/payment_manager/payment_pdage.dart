import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/repositories/invoice_repository.dart';
import 'package:pos/utils/invoice_converter.dart';
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
  final InvoiceRepository _invoiceRepo = Get.find<InvoiceRepository>();

  List<Payment> _payments = [];
  PaymentDataSource paymentDataSource = PaymentDataSource(paymentsData: []);

  @override
  void initState() {
    super.initState();
    getPaymentData();
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
    final result = await _invoiceRepo.getAllInvoices();

    if (result.isSuccess) {
      final driftInvoices = result.data ?? [];

      _payments = [];

      // Get payments for each invoice
      for (var driftInvoice in driftInvoices) {
        final paymentsResult = await _invoiceRepo.getInvoicePayments(driftInvoice.invoiceId);

        if (paymentsResult.isSuccess) {
          final driftPayments = paymentsResult.data ?? [];

          for (var driftPayment in driftPayments) {
            _payments.add(Payment(
              date: driftPayment.date,
              amount: driftPayment.amount,
              paymethod: driftPayment.paymentMethod,
              comment: driftPayment.comment,
              payId: driftPayment.payId,
              invoiceId: driftInvoice.invoiceId,
              customerName: driftInvoice.customerName,
              customerId: driftInvoice.customerId,
            ));
          }
        }
      }

      _payments.sort((a, b) => b.date.compareTo(a.date));

      paymentDataSource = PaymentDataSource(paymentsData: _payments);
      setState(() {});
    }
  }

  Future<void> removePayment(String invoiceId, String payId) async {
    showDialog(
        context: context,
        builder: (context) => POSVerifyDialog(
              title: 'Delete Payament',
              content:
                  'Do you want to delete in #$invoiceId invoice #$payId payment?',
              onContinue: () async {
                await _invoiceRepo.removePayment(invoiceId, payId);
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
