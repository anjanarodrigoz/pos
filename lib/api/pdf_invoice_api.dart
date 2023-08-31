import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:pos/models/address.dart';
import 'package:pos/models/extra_charges.dart';
import 'package:pos/utils/my_format.dart';

import '../models/customer.dart';
import '../models/invoice.dart';
import '../models/invoice_item.dart';
import 'pdf_api.dart';

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(invoice),
        SizedBox(height: 3 * PdfPageFormat.cm),
        buildTitle(invoice),
        buildInvoice(invoice),
        Divider(),
        buildTotal(invoice),
      ],
      footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Widget buildHeader(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildCompanyInfo(),
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(invoice),
              buildInvoiceInfo(invoice),
            ],
          ),
        ],
      );

  static Widget buildCustomerAddress(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(invoice.customerName,
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text(invoice.customerMobile),
          Text(invoice.billingAddress!.street!),
          Text(invoice.billingAddress!.city!),
          Text(invoice.billingAddress!.postalCode!),
          Text(invoice.billingAddress!.state!),
        ],
      );

  static Widget buildInvoiceInfo(Invoice info) {
    final paymentTerms =
        '${info.createdDate.add(Duration(days: 3)).difference(info.createdDate).inDays} days';
    final titles = <String>[
      'Invoice Number:',
      'Invoice Date:',
      'Invoice Time:',
    ];
    final data = <String>[
      '# ${info.invoiceId}',
      MyFormat.formatDateOne(info.createdDate),
      MyFormat.formatTime(info.createdDate),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static Widget buildCompanyInfo() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Aruna Stores', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text('Work Wear Specialists'),
        ],
      );

  static Widget buildTitle(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INVOICE',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(Invoice invoice) {
    final headers = ['Description', 'Quantity', 'Unit Price', 'Gst', 'Total'];
    List<List> items = [];
    for (InvoicedItem item in invoice.itemList) {
      final total = item.netTotal * (1 + invoice.gstPrecentage);
      items.add([
        item.name,
        '${item.qty}',
        '\$ ${item.netPrice.toStringAsFixed(2)}',
        '\$ ${(item.netPrice * invoice.gstPrecentage).toStringAsFixed(2)}',
        '\$ ${total.toStringAsFixed(2)}',
      ]);
      if (item.comment != null) {
        if (item.comment!.isNotEmpty) {
          items.add([item.comment.toString(), '', '', '', '']);
        }
      }
    }

    for (ExtraCharges extra in invoice.extraCharges ?? []) {
      final total = extra.netTotal * (1 + invoice.gstPrecentage);

      items.add([
        extra.name,
        '${extra.qty}',
        '\$ ${extra.price.toStringAsFixed(2)}',
        '\$ ${(extra.price * invoice.gstPrecentage).toStringAsFixed(2)}',
        '\$ ${total.toStringAsFixed(2)}',
      ]);
      if (extra.comment != null) {
        if (extra.comment!.isNotEmpty) {
          items.add([extra.comment.toString(), '', '', '', '']);
        }
      }
    }

    for (String comment in invoice.comments ?? []) {
      items += comment
          .split('\n')
          .map((e) => [
                e,
                '',
                '',
                '',
                '',
              ])
          .toList();
    }

    return Table.fromTextArray(
      headers: headers,
      data: items,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.normal),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 8,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(Invoice invoice) {
    final data = invoice.calculteTotalNetPrice();
    final netTotal = data[0];
    final vat = data[1];
    final total = data[2];

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Net total',
                  value: MyFormat.formatCurrency(netTotal),
                  unite: true,
                ),
                buildText(
                  title: 'GST total',
                  value: MyFormat.formatCurrency(vat),
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'Total amount due',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: MyFormat.formatCurrency(total),
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(
              title: 'Address', value: 'invoice.billingAddress.city'),
          SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(
              title: 'Paypal', value: 'invoice.supplier.paymentInfo'),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
