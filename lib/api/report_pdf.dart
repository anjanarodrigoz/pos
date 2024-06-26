import 'dart:ffi';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pos/controllers/report_controller.dart';
import 'package:pos/enums/enums.dart';
import 'package:pos/utils/my_format.dart';
import '../database/store_db.dart';
import '../models/store.dart';

class ReportPdf {
  final String companyName;
  final String reportType;
  final DateTime createdDate;
  final List<String> columns;
  final List<List<String>> rows;
  final String reportTitle;
  final dateTimeRange;

  ReportPdf({
    required this.companyName,
    required this.reportType,
    required this.createdDate,
    required this.columns,
    required this.rows,
    required this.reportTitle,
    this.dateTimeRange,
  });

  Future<Document> generatePDF() async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      build: (context) => [
        buildHeader(),
        SizedBox(height: 2 * PdfPageFormat.mm),
        buildTable(),
      ],
    ));

    return pdf;
  }

  Widget buildHeader() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildCompanyInfo(),
                buildTitle(),
              ]),
        ],
      );

  Widget buildTitle() => Column(children: [
        Text(
          '$reportType - $reportTitle',
          style: TextStyle(fontSize: 7, fontWeight: FontWeight.normal),
        ),
        SizedBox(height: 0.1 * PdfPageFormat.cm),
        if (dateTimeRange.start.year != 0)
          Text(
            MyFormat.reportDateTimeFormat(dateTimeRange),
            style: TextStyle(fontSize: 8, fontWeight: FontWeight.normal),
          )
      ]);

  Widget buildCompanyInfo() {
    Store store = StoreDB().getStore();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(store.companyName.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 8.0)),
        if (store.slogan.isNotEmpty)
          Text(store.slogan,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 7.0)),
        SizedBox(height: 0.1 * PdfPageFormat.cm),
        Text(
          'Created Date : ${MyFormat.formatDate(createdDate)}',
          style: TextStyle(fontSize: 7, fontWeight: FontWeight.normal),
        ),
        SizedBox(height: 0.1 * PdfPageFormat.cm),
      ],
    );
  }

  Widget buildTable() {
    final headers = columns;

    List<List<String>> items = rows;

    int net = columns.indexOf(ReportController.netKey);
    int gst = columns.indexOf(ReportController.gstKey);
    int total = columns.indexOf(ReportController.totalKey);
    int outstanding = columns.indexOf(ReportController.outstanigKey);
    int toPay = columns.indexOf(ReportController.paykey);
    int extrtotal = columns.indexOf(ReportController.extraTotalKey);
    int itemtotal = columns.indexOf(ReportController.itemTotalKey);

    List<int> prices = [
      net,
      gst,
      total,
      outstanding,
      toPay,
      extrtotal,
      itemtotal
    ];

    List<String> summery = createSummeryRow(headers, items) ?? [];

    items.add(summery);

    return Table.fromTextArray(
        headers: headers,
        data: items,
        border: null,
        headerStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 8.0,
        ),
        headerAlignment: Alignment.centerLeft,
        cellPadding: const EdgeInsets.only(top: 1),
        cellStyle: const TextStyle(fontSize: 8.0),
        cellAlignment: Alignment.centerLeft,
        cellFormat: (index, data) {
          if (prices.contains(index)) {
            double? value = double.tryParse(data);
            return value == null ? data : MyFormat.formatPrice(value);
          }

          return data;
        },
        cellAlignments: {
          net: Alignment.centerRight,
          gst: Alignment.centerRight,
          total: Alignment.centerRight,
          outstanding: Alignment.centerRight,
          toPay: Alignment.centerRight,
          extrtotal: Alignment.centerRight,
          itemtotal: Alignment.centerRight,
        });
  }

  List<String>? createSummeryRow(
      List<String> headers, List<List<String>> items) {
    double netTotal = 0.0;
    double gstTotal = 0.0;
    double totalTotal = 0.0;
    double toPayTotal = 0.0;
    int qtyTotal = 0;

    if (headers.contains(ReportController.netKey)) {
      if (headers.contains(ReportController.paykey)) {
        for (List<String> data in items) {
          netTotal += double.parse(
              data.elementAt(headers.indexOf(ReportController.netKey)));
          gstTotal += double.parse(
              data.elementAt(headers.indexOf(ReportController.gstKey)));
          totalTotal += double.parse(
              data.elementAt(headers.indexOf(ReportController.totalKey)));
          toPayTotal += double.parse(
              data.elementAt(headers.indexOf(ReportController.paykey)));
        }
        return headers.map((e) {
          if (e == ReportController.netKey) {
            return MyFormat.formatPrice(netTotal);
          }
          if (e == ReportController.gstKey) {
            return MyFormat.formatPrice(gstTotal);
          }
          if (e == ReportController.totalKey) {
            return MyFormat.formatPrice(totalTotal);
          }
          if (e == ReportController.paykey) {
            return MyFormat.formatPrice(toPayTotal);
          }

          return '';
        }).toList();
      } else {
        for (List<String> data in items) {
          netTotal += double.parse(
              data.elementAt(headers.indexOf(ReportController.netKey)));
          gstTotal += double.parse(
              data.elementAt(headers.indexOf(ReportController.gstKey)));
          totalTotal += double.parse(
              data.elementAt(headers.indexOf(ReportController.totalKey)));
          qtyTotal += int.parse(
              data.elementAt(headers.indexOf(ReportController.quantityKey)));
        }
        return headers.map((e) {
          if (headers.indexOf(e) == 0) {
            return 'Total';
          }
          if (e == ReportController.netKey) {
            return MyFormat.formatPrice(netTotal);
          }
          if (e == ReportController.gstKey) {
            return MyFormat.formatPrice(gstTotal);
          }
          if (e == ReportController.totalKey) {
            return MyFormat.formatPrice(totalTotal);
          }
          if (reportTitle == 'Supply Items' ||
              reportTitle == 'Item Return Report' ||
              reportTitle == 'Supply Item Total Report') {
            if (e == ReportController.quantityKey) {
              return qtyTotal.toString();
            }
          }

          return '';
        }).toList();
      }
    } else {
      return null;
    }
  }
}
