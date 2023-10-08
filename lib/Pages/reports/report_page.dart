import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:pos/controllers/report_controller.dart';
import 'package:pos/utils/my_format.dart';
import 'package:pos/widgets/pos_button.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:window_manager/window_manager.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class ReportPage extends StatefulWidget {
  ReportPage({super.key});

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
  @override
  Widget build(BuildContext context) {
    WindowOptions windowOptions = const WindowOptions(
        minimumSize: Size(1300, 800), size: Size(1300, 800), center: true);

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
    });

    return Obx(() {
      List<DataGridRow> rows = controller.rows;
      List<GridColumn> columns = controller.columns;

      return columns.isEmpty
          ? const Center(child: Text('Select Report Type'))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          MyFormat.formatDateTwo(
                              controller.dateTimeRange.start),
                          style: TextStyle(fontSize: 14.0),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "-",
                          style: TextStyle(fontSize: 14.0),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          MyFormat.formatDateTwo(controller.dateTimeRange.end),
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          controller.title.value.keys.first,
                          style: const TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          controller.title.value.values.first,
                          style: const TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    PosButton(
                        color: Colors.yellow.shade900,
                        height: 40.0,
                        width: 150.0,
                        text: 'Export',
                        icon: Icons.picture_as_pdf_rounded,
                        onPressed: () async {
                          late PdfStringFormat format;
                          PdfDocument document = pdfKey.currentState!
                              .exportToPdfDocument(
                                  exportTableSummaries:
                                      controller.isRequiredTableSummery,
                                  headerFooterExport:
                                      (DataGridPdfHeaderFooterExportDetails
                                          headerFooterExport) {
                                    final double width = headerFooterExport
                                        .pdfPage
                                        .getClientSize()
                                        .width;
                                    final PdfPageTemplateElement header =
                                        PdfPageTemplateElement(
                                            Rect.fromLTWH(0, 0, width, 65));
                                    header.graphics.drawString(
                                      controller.title.keys.first,
                                      PdfStandardFont(PdfFontFamily.courier, 12,
                                          style: PdfFontStyle.bold),
                                      bounds:
                                          const Rect.fromLTWH(0, 0, 200, 50),
                                    );

                                    if (controller.dateTimeRange.start.year !=
                                        0) {
                                      header.graphics.drawString(
                                        'From ${MyFormat.formatDateTwo(controller.dateTimeRange.start)} To ${MyFormat.formatDateTwo(controller.dateTimeRange.end)}',
                                        PdfStandardFont(
                                            PdfFontFamily.courier, 8,
                                            style: PdfFontStyle.regular),
                                        bounds:
                                            const Rect.fromLTRB(350, 10, 0, 0),
                                      );
                                    }
                                    header.graphics.drawString(
                                      controller.title.values.first,
                                      PdfStandardFont(PdfFontFamily.courier, 8,
                                          style: PdfFontStyle.regular),
                                      bounds:
                                          const Rect.fromLTWH(0, 15, 200, 40),
                                    );
                                    headerFooterExport.pdfDocumentTemplate.top =
                                        header;
                                  },
                                  fitAllColumnsInOnePage: true,
                                  cellExport: (details) {
                                    format = PdfStringFormat(
                                        alignment: PdfTextAlignment.center,
                                        lineAlignment:
                                            PdfVerticalAlignment.middle);

                                    if (details.columnName ==
                                            ReportController.salepriceKey ||
                                        details.columnName ==
                                            ReportController.receiptsPriceKey) {
                                      format = PdfStringFormat(
                                          alignment: PdfTextAlignment.right,
                                          lineAlignment:
                                              PdfVerticalAlignment.middle);
                                    }

                                    if (details.columnName ==
                                            ReportController.customerSaleKey ||
                                        details.columnName ==
                                            ReportController.receiptsKey) {
                                      format = PdfStringFormat(
                                          alignment: PdfTextAlignment.left,
                                          lineAlignment:
                                              PdfVerticalAlignment.middle);
                                    }

                                    if (details.cellType ==
                                        DataGridExportCellType
                                            .tableSummaryRow) {
                                      if ((details.cellValue as String)
                                          .isNotEmpty) {
                                        details.pdfCell.value =
                                            MyFormat.formatPrice(double.parse(
                                                details.cellValue as String));
                                        format = PdfStringFormat(
                                            alignment: PdfTextAlignment.right,
                                            lineAlignment:
                                                PdfVerticalAlignment.middle);
                                      }
                                    }
                                    if (details.cellValue is double) {
                                      details.pdfCell.value =
                                          MyFormat.formatPrice(
                                              details.cellValue as double);
                                      format = PdfStringFormat(
                                          alignment: PdfTextAlignment.right,
                                          lineAlignment:
                                              PdfVerticalAlignment.middle);
                                    }

                                    details.pdfCell.stringFormat = format;
                                  },
                                  autoColumnWidth: true);

                          final List<int> bytes = await document.save();
                          File file =
                              await File('DataGrid.pdf').writeAsBytes(bytes);
                          ReportPage.openFile(file);
                          document.dispose();
                        }),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: SfDataGrid(
                    key: pdfKey,
                    allowColumnsResizing: true,
                    rowHeight: 40.0,
                    gridLinesVisibility: GridLinesVisibility.both,
                    headerGridLinesVisibility: GridLinesVisibility.both,
                    columnWidthMode: ColumnWidthMode.auto,
                    source: DataSource(rows),
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
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Text(
        MyFormat.formatCurrency(double.parse(summaryValue)),
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    // TODO: implement buildRow
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      if (e.columnName == ReportController.salepriceKey ||
          e.columnName == ReportController.receiptsPriceKey) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          alignment: Alignment.centerRight,
          child: Text(
            e.value.toString(),
            style: const TextStyle(fontSize: 13.0),
          ),
        );
      }

      if (e.value is int) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          alignment: Alignment.centerRight,
          child: Text(
            e.value.toString(),
            style: const TextStyle(fontSize: 13.0),
          ),
        );
      }

      if (e.value is double) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          alignment: Alignment.centerRight,
          child: Text(
            MyFormat.formatPrice(e.value),
            style: const TextStyle(fontSize: 13.0),
          ),
        );
      }

      if (e.value is String) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          alignment: Alignment.centerLeft,
          child: Text(
            e.value.toString(),
            style: const TextStyle(fontSize: 13.0),
          ),
        );
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        alignment: Alignment.center,
        child: Text(
          e.value.toString(),
          style: const TextStyle(fontSize: 13.0),
        ),
      );
    }).toList());
  }
}
