import 'dart:io';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:pos/models/extra_charges.dart';
import 'package:pos/utils/my_format.dart';
import '../models/address.dart';
import '../models/invoice.dart';
import '../models/invoice_item.dart';
import 'pdf_api.dart';

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      build: (context) => [
        buildHeader(invoice),
        SizedBox(height: 0.5 * PdfPageFormat.cm),
        buildTitle(invoice),
        buildInvoice(invoice),
        buildTotal(invoice),
      ],
      footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Widget buildHeader(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildCompanyInfo(),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(
                invoice.billingAddress,
                invoice.customerName,
              ),
              buildCustomerAddress(
                invoice.shippingAddress,
                invoice.customerName,
              ),
            ],
          ),
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            buildInvoiceInfo(
                'Date', MyFormat.formatDateOne(invoice.createdDate)),
            buildInvoiceInfo('Invoice ID', '#${invoice.invoiceId}'),
            buildInvoiceInfo('Customer ID', '#${invoice.customerId}'),
            buildInvoiceInfo('Mobile Number', invoice.customerMobile)
          ])
        ],
      );

  static Widget buildCustomerAddress(Address? address, String cusName) {
    const style = TextStyle(fontSize: 10.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (address!.street!.isNotEmpty) Text(cusName, style: style),
        Text(address.street!, style: style),
        Text(address.city!, style: style),
        Text('${address.state!} ${address.postalCode!}', style: style),
      ],
    );
  }

  static Widget buildInvoiceInfo(String key, String value) {
    const style = TextStyle(fontSize: 10.0);
    var style_01 = TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold);

    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Text(key, style: style_01), Text(value, style: style)]);
  }

  static Widget buildCompanyInfo() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('HTT CLOTHING', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('Work Wear Specialists',
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text('ABN 79 659 875 789', style: const TextStyle(fontSize: 10.0)),
          Text('5 Waston Gardens Berwick',
              style: const TextStyle(fontSize: 10.0)),
          Text('Victoria 3806', style: const TextStyle(fontSize: 10.0)),
          Text('Mobile : Aruna 0481 508 908 , Frank 0430 355 000',
              style: const TextStyle(fontSize: 10.0)),
          Text('E-mail : httclothing@dodo.com.au',
              style: const TextStyle(fontSize: 10.0)),
        ],
      );

  static Widget buildTitle(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INVOICE',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.2 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(Invoice invoice) {
    final headers = [
      'Item Id',
      'Description',
      'Quantity',
      'Unit Price',
      'Gst',
      'Total'
    ];
    List<List> items = [];
    items.add(['', '', '', '', '', '']);
    items.add(['', '', '', '', '', '']);
    items.add(['', '', '', '', '', '']);
    items.add(['', '', '', '', '', '']);
    for (InvoicedItem item in invoice.itemList) {
      final total = item.netTotal * (1 + invoice.gstPrecentage);
      items.add([
        item.isPostedItem ? 'P${item.itemId}' : item.itemId,
        item.name,
        '${item.qty}',
        '${item.netPrice.toStringAsFixed(2)}',
        '${(item.netPrice * invoice.gstPrecentage).toStringAsFixed(2)}',
        '${total.toStringAsFixed(2)}',
      ]);
      if (item.comment != null) {
        if (item.comment!.isNotEmpty) {
          items.add(['', item.comment.toString(), '', '', '', '']);
          items.add(['', '', '', '', '', '']);
          items.add(['', '', '', '', '', '']);
          items.add(['', '', '', '', '', '']);
        }
      } else {
        items.add(['', '', '', '', '', '']);
        items.add(['', '', '', '', '', '']);
        items.add(['', '', '', '', '', '']);
      }
    }

    for (ExtraCharges extra in invoice.extraCharges ?? []) {
      final total = extra.netTotal * (1 + invoice.gstPrecentage);

      items.add([
        '#${(invoice.extraCharges?.indexOf(extra)) ?? 0 + 1}',
        extra.name,
        '${extra.qty}',
        '${extra.price.toStringAsFixed(2)}',
        '${(extra.price * invoice.gstPrecentage).toStringAsFixed(2)}',
        '${total.toStringAsFixed(2)}',
      ]);
      if (extra.comment != null) {
        if (extra.comment!.isNotEmpty) {
          items.add(['', extra.comment.toString(), '', '', '', '']);
          items.add(['', '', '', '', '', '']);
          items.add(['', '', '', '', '', '']);
          items.add(['', '', '', '', '', '']);
        }
      } else {
        items.add(['', '', '', '', '', '']);
        items.add(['', '', '', '', '', '']);
        items.add(['', '', '', '', '', '']);
      }
    }

    items.add(['', '', '', '', '', '']);
    items.add(['', '', '', '', '', '']);
    items.add(['', '', '', '', '', '']);
    items.add(['', '', '', '', '', '']);
    items.add(['', '', '', '', '', '']);
    items.add(['', '', '', '', '', '']);

    for (String comment in invoice.comments ?? []) {
      items += comment
          .split('\n')
          .map((e) => [
                '',
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
      cellPadding: EdgeInsets.only(top: 1),
      cellStyle: TextStyle(fontSize: 10.0),
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.center,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
        6: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(Invoice invoice) {
    final netTotal = invoice.totalNetPrice;
    final vat = invoice.totalGstPrice;
    final total = invoice.total;

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
                Divider(thickness: 0.2),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Thank you for your Business',
              style: TextStyle(fontWeight: FontWeight.bold)),
          Divider(),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(children: [
              buildCustomerAddress(
                invoice.billingAddress,
                invoice.customerName,
              ),
            ]),
            Column(children: [
              Text('HTT CLOTHING',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Work Wear Specialists',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('ABN 79 659 875 789',
                  style: const TextStyle(fontSize: 10.0)),
              Text('5 Waston Gardens Berwick',
                  style: const TextStyle(fontSize: 10.0)),
              Text('Victoria 3806', style: const TextStyle(fontSize: 10.0)),
            ]),
            Column(children: [
              buildSimpleText(title: 'Invoice ID', value: invoice.invoiceId),
              buildSimpleText(title: 'Customer ID', value: invoice.customerId),
              buildSimpleText(
                  title: 'Date',
                  value: MyFormat.formatDateOne(invoice.createdDate)),
              buildSimpleText(
                  title: 'Total',
                  value: MyFormat.formatCurrency(invoice.total)),
            ])
          ]),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0);
    final style_01 = TextStyle(fontWeight: FontWeight.normal, fontSize: 10.0);

    return SizedBox(
        width: 100.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: style),
            Text(value, style: style_01),
          ],
        ));
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
