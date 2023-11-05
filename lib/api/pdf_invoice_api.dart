import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:pos/database/store_db.dart';
import 'package:pos/enums/enums.dart';
import 'package:pos/models/extra_charges.dart';
import 'package:pos/utils/my_format.dart';
import 'package:printing/printing.dart';
import '../models/address.dart';
import '../models/invoice.dart';
import '../models/invoice_item.dart';
import '../models/store.dart';
import '../models/supply_invoice.dart';
import 'pdf_api.dart';

class PdfInvoiceApi {
  static Future<File> generateInvoicePDF(Invoice invoice,
      {required InvoiceType invoiceType}) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      build: (context) => [
        buildHeader(invoice, invoiceType),
        SizedBox(height: 0.5 * PdfPageFormat.cm),
        buildInvoice(invoice),
        Spacer(),
        buildTotal(invoice),
      ],
      footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(
        name: 'Invoice_${invoice.invoiceId}.pdf', pdf: pdf);
  }

  static Future<void> printInvoice(invoice,
      {required InvoiceType invoiceType, required Printer printer}) async {
    var pdfFile;

    if (invoiceType == InvoiceType.supplyInvoice ||
        invoiceType == InvoiceType.returnNote) {
      pdfFile = await PdfInvoiceApi.generateSupplyInvoicePDF(invoice);
    } else {
      pdfFile = await PdfInvoiceApi.generateInvoicePDF(invoice,
          invoiceType: invoiceType);
    }

    await Printing.directPrintPdf(
        printer: printer,
        onLayout: (PdfPageFormat format) async =>
            Uint8List.fromList(await pdfFile.readAsBytes()));
  }

  static Future<File> generateSupplyInvoicePDF(SupplyInvoice invoice) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      build: (context) => [
        buildSupplyerHeader(invoice),
        SizedBox(height: 0.5 * PdfPageFormat.cm),
        buildInvoice(invoice),
        Spacer(),
        buildTotal(invoice),
      ],
      footer: (context) => buildSupplyFooter(invoice),
    ));

    return PdfApi.saveDocument(
        name: 'supply_invoice_${invoice.invoiceId}.pdf', pdf: pdf);
  }

  static Widget buildHeader(Invoice invoice, invoiceType) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildCompanyInfo(),
                buildTitle(invoiceType),
              ]),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                buildInvoiceInfo('INVOICE#', invoice.invoiceId),
                buildInvoiceInfo('CUSTOMER ID#', invoice.customerId),
                buildInvoiceInfo('MOBILE NO#', invoice.customerMobile),
                buildInvoiceInfo(
                    'DATE', MyFormat.formatDateOne(invoice.createdDate)),
              ])
            ],
          ),
        ],
      );

  static Widget buildSupplyerHeader(SupplyInvoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildCompanyInfo(),
                buildTitle(invoice.isReturnNote
                    ? InvoiceType.returnNote
                    : InvoiceType.supplyInvoice)
              ]),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(
                invoice.billingAddress,
                invoice.supplyerName,
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildInvoiceInfo(
                        invoice.isReturnNote ? 'RETRUN NOTE' : 'INVOICE#',
                        invoice.invoiceId),
                    if (!invoice.isReturnNote)
                      buildInvoiceInfo('REF#', invoice.referenceId ?? ''),
                    buildInvoiceInfo('SUPPLYER ID#', invoice.supplyerId),
                    buildInvoiceInfo('MOBILE NO#', invoice.supplyerMobile),
                    buildInvoiceInfo(
                        'DATE', MyFormat.formatDateOne(invoice.createdDate)),
                  ])
            ],
          ),
        ],
      );

  static Widget buildCustomerAddress(
    Address? address,
    String cusName,
  ) {
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

    return SizedBox(
        width: 130,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(key, style: style_01), Text(value, style: style)]));
  }

  static Widget buildCompanyInfo() {
    Store store = StoreDB().getStore();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(store.companyName.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.bold)),
        if (store.slogan.isNotEmpty)
          Text(store.slogan, style: TextStyle(fontWeight: FontWeight.bold)),
        Text('ABN ${store.abn}', style: const TextStyle(fontSize: 10.0)),
        Text('${store.street},${store.city},${store.state},${store.postalcode}',
            style: const TextStyle(fontSize: 10.0)),
        Text('Mobile : ${store.mobileNumber1}',
            style: const TextStyle(fontSize: 10.0)),
        Text('E-mail : ${store.email}', style: const TextStyle(fontSize: 10.0)),
      ],
    );
  }

  static Widget buildTitle(InvoiceType type) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            type.name(),
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.2 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(var invoice) {
    bool isReturnNote = false;

    if (invoice is SupplyInvoice) {
      isReturnNote = invoice.isReturnNote;
    }
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
      final total = (isReturnNote ? -item.netTotal : item.netTotal) *
          (1 + invoice.gstPrecentage);
      items.add([
        item.isPostedItem ? 'P${item.itemId}' : item.itemId,
        item.name,
        isReturnNote ? '${-item.qty}' : '${item.qty}',
        (item.netPrice.toStringAsFixed(2)),
        ((item.netPrice * invoice.gstPrecentage).toStringAsFixed(2)),
        (total.toStringAsFixed(2)),
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
        (extra.price.toStringAsFixed(2)),
        ((extra.price * invoice.gstPrecentage).toStringAsFixed(2)),
        (total.toStringAsFixed(2)),
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
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellPadding: const EdgeInsets.only(top: 1),
      cellStyle: const TextStyle(fontSize: 10.0),
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

  static Widget buildTotal(var invoice) {
    bool isReturnNote = false;
    if (invoice is SupplyInvoice) {
      isReturnNote = invoice.isReturnNote;
    }
    final netTotal =
        isReturnNote ? -invoice.totalNetPrice : invoice.totalNetPrice;
    final vat = isReturnNote ? -invoice.totalGstPrice : invoice.totalGstPrice;
    final total = isReturnNote ? -invoice.total : invoice.total;

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
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(Invoice invoice) {
    Store store = StoreDB().getStore();

    return Column(
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
            Text(store.companyName,
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(store.slogan, style: TextStyle(fontWeight: FontWeight.bold)),
            Text('ABN ${store.abn}', style: const TextStyle(fontSize: 10.0)),
            Text(
                '${store.street},${store.city},${store.state},${store.postalcode}',
                style: const TextStyle(fontSize: 10.0)),
          ]),
          Column(children: [
            buildSimpleText(title: 'Invoice ID', value: invoice.invoiceId),
            buildSimpleText(title: 'Customer ID', value: invoice.customerId),
            buildSimpleText(
                title: 'Date',
                value: MyFormat.formatDateOne(invoice.createdDate)),
            buildSimpleText(
                title: 'Total', value: MyFormat.formatCurrency(invoice.total)),
          ])
        ]),
      ],
    );
  }

  static Widget buildSupplyFooter(SupplyInvoice invoice) {
    Store store = StoreDB().getStore();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        SizedBox(height: 1 * PdfPageFormat.mm),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(children: [
            buildCustomerAddress(
              invoice.billingAddress,
              invoice.supplyerName,
            ),
          ]),
          Column(children: [
            Text(store.companyName,
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(store.slogan, style: TextStyle(fontWeight: FontWeight.bold)),
            Text('ABN ${store.abn}', style: const TextStyle(fontSize: 10.0)),
            Text(
                '${store.street},${store.city},${store.state},${store.postalcode}',
                style: const TextStyle(fontSize: 10.0)),
          ]),
          Column(children: [
            buildSimpleText(title: 'Invoice ID', value: invoice.invoiceId),
            buildSimpleText(title: 'Supplyer ID', value: invoice.supplyerId),
            buildSimpleText(
                title: 'Date',
                value: MyFormat.formatDateOne(invoice.createdDate)),
            buildSimpleText(
                title: 'Total', value: MyFormat.formatCurrency(invoice.total)),
          ])
        ]),
      ],
    );
  }

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
