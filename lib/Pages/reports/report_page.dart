import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:pos/api/email_sender.dart';
import 'package:pos/api/pdf_api.dart';
import 'package:pos/api/printer_manager.dart';
import 'package:pos/api/report_pdf.dart';
import 'package:pos/controllers/report_controller.dart';
import 'package:pos/database/store_db.dart';
import 'package:pos/utils/constant.dart';
import 'package:pos/utils/my_format.dart';
import 'package:pos/widgets/pos_button.dart';
import 'package:pos/widgets/printer_setup_buttton.dart';
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}

class _ReportPageState extends State<ReportPage> {
  final GlobalKey<SfDataGridState> pdfKey = GlobalKey<SfDataGridState>();

  ReportController controller = Get.put(ReportController());
  final DataGridController _dataGridController = DataGridController();

  DataSource _dataSource = DataSource([]);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<DataGridRow> rows = controller.rows;
      List<GridColumn> columns = controller.columns;
      _dataSource = DataSource(rows);

      return columns.isEmpty
          ? const Center(child: Text('Select Report Type'))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (controller.isDateFilter())
                      Row(
                        children: [
                          Text(
                            MyFormat.formatDateTwo(
                                controller.dateTimeRange.start),
                            style: const TextStyle(fontSize: 14.0),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          if (!controller.checkDate())
                            const Text(
                              "-",
                              style: TextStyle(fontSize: 14.0),
                            ),
                          const SizedBox(
                            width: 10,
                          ),
                          if (!controller.checkDate())
                            Text(
                              MyFormat.formatDateTwo(controller
                                  .dateTimeRange.end
                                  .subtract(const Duration(days: 1))),
                              style: const TextStyle(fontSize: 14.0),
                            ),
                        ],
                      ),
                    Text(
                      '${controller.title.value.keys.first} - ${controller.title.value.values.first}',
                      style: const TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.bold),
                    ),
                    PosButton(
                      color: Colors.yellow.shade900,
                      width: 70.0,
                      height: 35.0,
                      icon: Icons.picture_as_pdf_rounded,
                      onPressed: () async {
                        String companyName = StoreDB().getStore().companyName;
                        String reportType = controller.title.value.keys.first;
                        String reportTitle =
                            controller.title.value.values.first;
                        var pdf = await ReportPdf(
                                columns: controller.columns.value
                                    .map((element) => element.columnName)
                                    .toList(),
                                rows: _dataSource.effectiveRows
                                    .map((DataGridRow row) => row
                                        .getCells()
                                        .map((DataGridCell e) =>
                                            e.value.toString())
                                        .toList())
                                    .toList(),
                                companyName: companyName,
                                reportType: reportType,
                                reportTitle: reportTitle,
                                createdDate: DateTime.now(),
                                dateTimeRange: controller.dateTimeRange)
                            .generatePDF();

                        await showExport(pdf, reportType, reportTitle);
                      },
                      text: '',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: SfDataGrid(
                    key: pdfKey,
                    allowColumnsResizing: true,
                    rowHeight: Const.tableRowHeight,
                    controller: _dataGridController,
                    gridLinesVisibility: GridLinesVisibility.both,
                    headerGridLinesVisibility: GridLinesVisibility.both,
                    columnWidthMode: ColumnWidthMode.auto,
                    source: _dataSource,
                    allowFiltering: true,
                    columns: columns,
                    tableSummaryRows: [
                      GridTableSummaryRow(
                          color: Colors.grey.shade200,
                          showSummaryInRow: false,
                          title: 'Summery Total',
                          columns: [
                            const GridSummaryColumn(
                                name: 'Sum',
                                columnName: ReportController.netKey,
                                summaryType: GridSummaryType.sum),
                            const GridSummaryColumn(
                                name: 'Sum',
                                columnName: ReportController.gstKey,
                                summaryType: GridSummaryType.sum),
                            const GridSummaryColumn(
                                name: 'Sum',
                                columnName: ReportController.totalKey,
                                summaryType: GridSummaryType.sum),
                            const GridSummaryColumn(
                                name: 'Sum',
                                columnName: ReportController.paykey,
                                summaryType: GridSummaryType.sum),
                          ],
                          position: GridTableSummaryRowPosition.bottom)
                    ],
                  ),
                ),
              ],
            );
    });
  }

  Future<void> showExport(pdf, String reportType, String reportTitle) async {
    PrinterManager printerManager = PrinterManager();

    showDialog(
        context: context,
        builder: (c) {
          return AlertDialog(
            content: Row(
              children: [
                PosButton(
                    text: 'Print',
                    onPressed: () async {
                      if (printerManager.printer != null) {
                        try {
                          await Printing.directPrintPdf(
                              printer: printerManager.printer!,
                              onLayout: (format) async =>
                                  Uint8List.fromList(await pdf.save()));
                        } catch (e) {
                          Get.dialog(
                              barrierDismissible: true,
                              AlertDialog(
                                content: Text('$e'),
                              ));
                        }
                      } else {
                        showDialog(
                            context: context,
                            builder: (c) {
                              return const AlertDialog(
                                content: Text('Please setup printer'),
                              );
                            });
                      }
                    }),
                PosButton(
                    text: 'View',
                    onPressed: () async {
                      final file = await PdfApi.saveDocument(
                          name: '$reportTitle-$reportType.pdf', pdf: pdf);
                      await PdfApi.openFile(file);
                    }),
                PosButton(
                    text: 'E-mail',
                    onPressed: () async {
                      EmailSender.showReportEmailSending(
                          context, pdf, reportTitle, reportType);
                    }),
                PrintSetupButton(onPrinterSelected: (Printer? printer) {
                  printerManager.printer = printer;
                })
              ],
            ),
          );
        });
  }
}

class DataSource extends DataGridSource {
  final List<DataGridRow> data;
  DataSource(this.data);

  @override
  List<DataGridRow> get rows => data;

  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    return Container(
      alignment: Alignment.centerRight,
      padding: Const.tableValuesPadding,
      child: Text(
        MyFormat.formatCurrency(double.parse(summaryValue)),
        style: Const.tableValuesTextStyle,
      ),
    );
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      if (e.columnName == ReportController.salepriceKey ||
          e.columnName == ReportController.receiptsPriceKey) {
        return Container(
          padding: Const.tableValuesPadding,
          alignment: Alignment.centerRight,
          child: Text(e.value.toString(), style: Const.tableValuesTextStyle),
        );
      }

      if (e.value is int) {
        return Container(
          padding: Const.tableValuesPadding,
          alignment: Alignment.centerRight,
          child: Text(e.value.toString(), style: Const.tableValuesTextStyle),
        );
      }

      if (e.value is double) {
        return Container(
          padding: Const.tableValuesPadding,
          alignment: Alignment.centerRight,
          child: Text(MyFormat.formatPrice(e.value),
              style: Const.tableValuesTextStyle),
        );
      }

      if (e.value is String) {
        return Container(
          padding: Const.tableValuesPadding,
          alignment: Alignment.centerLeft,
          child: Text(e.value.toString(), style: Const.tableValuesTextStyle),
        );
      }

      return Container(
        padding: Const.tableValuesPadding,
        alignment: Alignment.center,
        child: Text(e.value.toString(), style: Const.tableValuesTextStyle),
      );
    }).toList());
  }
}
