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
      maxPages: 100,
      pageFormat: PdfPageFormat.a4,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      build: (context) => [
        buildHeader(invoice, invoiceType),
        SizedBox(height: 0.5 * PdfPageFormat.cm),
        buildInvoice(invoice),
        Spacer(),
        buildTotal(invoice),
      ],
      footer: (context) => buildFooter(invoice, context, invoiceType),
    ));

    return PdfApi.saveDocument(
        name: 'Invoice_${invoice.invoiceId}.pdf', pdf: pdf);
  }

  static Future<void> printInvoice(invoice,
      {required InvoiceType invoiceType, required Printer printer}) async {
    File pdfFile;

    if (invoiceType == InvoiceType.supplyInvoice ||
        invoiceType == InvoiceType.returnNote) {
      pdfFile = await PdfInvoiceApi.generateSupplyInvoicePDF(invoice);
    } else {
      pdfFile = await PdfInvoiceApi.generateInvoicePDF(invoice,
          invoiceType: invoiceType);
    }

    try {
      await Printing.directPrintPdf(
          printer: printer,
          onLayout: (PdfPageFormat format) async =>
              Uint8List.fromList(await pdfFile.readAsBytes()));
    } on Exception catch (e) {
      Get.snackbar('Print error', '$e',
          animationDuration: const Duration(seconds: 5));
    }
  }

  static Future<File> generateSupplyInvoicePDF(SupplyInvoice invoice) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      maxPages: 100,
      pageFormat: PdfPageFormat.a4,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      build: (context) => [
        buildSupplyerHeader(invoice),
        SizedBox(height: 0.5 * PdfPageFormat.cm),
        buildInvoice(invoice),
        Spacer(),
        buildTotal(invoice),
      ],
      footer: (context) => buildSupplyFooter(invoice, context),
    ));

    return PdfApi.saveDocument(
        name: 'supply_invoice_${invoice.invoiceId}.pdf', pdf: pdf);
  }

  static Widget buildHeader(Invoice invoice, InvoiceType invoiceType) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Expanded(
          //           flex: 1,
          //           child: Align(
          //               alignment: Alignment.centerLeft,
          //               child: buildTitle(invoiceType))),
          //       Expanded(
          //         flex: 2,
          //         child: companyName(),
          //       ),
          //       Expanded(child: SizedBox(), flex: 1),
          //     ]),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                companyName(),
                Align(
                    alignment: Alignment.center,
                    child: buildTitle(invoiceType)),
              ]),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(
                invoice.billingAddress,
                invoice.customerName,
              ),
              Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                buildInvoiceInfo(
                    '${invoiceType.name()} No.', invoice.invoiceId),
                buildInvoiceInfo('Customer Id', invoice.customerId),
                buildInvoiceInfo('Mobile No.', invoice.customerMobile),
                buildInvoiceInfo(
                    'Date', MyFormat.formatDateOne(invoice.createdDate)),
              ]),
              buildCustomerAddress(
                invoice.shippingAddress,
                invoice.customerName,
              ),
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
                Expanded(child: SizedBox(), flex: 1),
                Expanded(
                  flex: 2,
                  child: companyName(),
                ),
                Expanded(
                    flex: 1,
                    child: buildTitle(invoice.isReturnNote
                        ? InvoiceType.returnNote
                        : InvoiceType.supplyInvoice)),
              ]),
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
                        invoice.isReturnNote
                            ? 'Return Note No.'
                            : 'Supply Invoice No.',
                        invoice.invoiceId),
                    if (!invoice.isReturnNote)
                      buildInvoiceInfo('Ref', invoice.referenceId ?? ''),
                    buildInvoiceInfo('Supplyer Id', invoice.supplyerId),
                    buildInvoiceInfo('Mobile No', invoice.supplyerMobile),
                    buildInvoiceInfo(
                        'Date', MyFormat.formatDateOne(invoice.createdDate)),
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

    return SizedBox(
        width: 130,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(key, style: style), Text(value, style: style)]));
  }

  static Widget buildCompanyInfo() {
    Store store = StoreDB().getStore();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 1 * PdfPageFormat.cm),
        Text('ABN ${store.abn}', style: const TextStyle(fontSize: 9.0)),
        Text('${store.street},${store.city},${store.state},${store.postalcode}',
            style: const TextStyle(fontSize: 9.0)),
        Text(store.mobileNumber1, style: const TextStyle(fontSize: 9.0)),
        Text(store.email, style: const TextStyle(fontSize: 9.0)),
      ],
    );
  }

  static Widget companyName() {
    Store store = StoreDB().getStore();
    return Column(children: [
      Text(store.companyName.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
      if (store.slogan.isNotEmpty)
        Text(store.slogan,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0))
    ]);
  }

  static Widget buildTitle(InvoiceType type) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // SizedBox(height: 0.5 * PdfPageFormat.cm),
          Text(
            type.name(),
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
          items.add(['', '(${item.comment})', '', '', '', '']);
        }
      }
    }

    items.add(['', '', '', '', '', '']);
    items.add(['', '', '', '', '', '']);
    items.add(['', '', '', '', '', '']);

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
          items.add(['', '(${extra.comment})', '', '', '', '']);
        }
      }
    }

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
      headerDecoration: const BoxDecoration(
          border: Border(
              top: BorderSide(width: 0.2), bottom: BorderSide(width: 0.2))),
      data: items,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      cellPadding: const EdgeInsets.only(top: 1.5),
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

    final vat = isReturnNote ? -invoice.totalGstPrice : invoice.totalGstPrice;
    final total = isReturnNote ? -invoice.total : invoice.total;

    return Container(
      alignment: Alignment.bottomRight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            flex: 6,
            child: Text('Thank you for your Business',
                style: TextStyle(fontWeight: FontWeight.normal)),
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(thickness: 0.2),
                buildText(
                  title: 'Sub Total',
                  value: MyFormat.formatCurrency(total),
                  unite: true,
                ),
                buildText(
                  title: 'Includes GST 10%',
                  value: MyFormat.formatCurrency(vat),
                  unite: true,
                ),
                SizedBox(height: 0.1 * PdfPageFormat.cm),
                buildText(
                  title: 'Total',
                  titleStyle: TextStyle(
                    fontSize: 12,
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

  static Widget buildFooter(Invoice invoice, context, InvoiceType invoiceType) {
    Store store = StoreDB().getStore();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: Text('Page ${context.pageNumber} of ${context.pagesCount}',
              style: const TextStyle(fontSize: 9.0)),
        ),
        Divider(thickness: 0.2),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(children: [
                buildCustomerAddress(
                    invoice.billingAddress, invoice.customerName),
              ]),
              Column(children: [
                Text(store.companyName,
                    style: TextStyle(fontWeight: FontWeight.normal)),
                Text(store.slogan,
                    style: TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 9.0)),
                Text('ABN ${store.abn}', style: const TextStyle(fontSize: 9.0)),
                Text(
                    '${store.street},${store.city},${store.state},${store.postalcode}',
                    style: const TextStyle(fontSize: 9.0)),
                Text(store.email, style: const TextStyle(fontSize: 9.0)),
                Text(store.mobileNumber1,
                    style: const TextStyle(fontSize: 9.0)),
              ]),
              Column(children: [
                buildSimpleText(
                    title: '${invoiceType.name()} No.',
                    value: invoice.invoiceId),
                buildSimpleText(
                    title: 'Customer Id', value: invoice.customerId),
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
  }

  static Widget buildSupplyFooter(SupplyInvoice invoice, context) {
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
                style: TextStyle(fontWeight: FontWeight.normal)),
            Text(store.slogan,
                style:
                    TextStyle(fontWeight: FontWeight.normal, fontSize: 10.0)),
            Text('ABN ${store.abn}', style: const TextStyle(fontSize: 10.0)),
            Text(
                '${store.street},${store.city},${store.state},${store.postalcode}',
                style: const TextStyle(fontSize: 10.0)),
          ]),
          Column(children: [
            buildSimpleText(title: 'Invoice No.', value: invoice.invoiceId),
            buildSimpleText(title: 'Supplyer Id', value: invoice.supplyerId),
            buildSimpleText(
                title: 'Date',
                value: MyFormat.formatDateOne(invoice.createdDate)),
            buildSimpleText(
                title: 'Total', value: MyFormat.formatCurrency(invoice.total)),
          ])
        ]),
        Text('Page ${context.pagesCount} of ${context.pagesCount}'),
      ],
    );
  }

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.normal, fontSize: 10.0);
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
    final style =
        titleStyle ?? TextStyle(fontWeight: FontWeight.normal, fontSize: 10.0);

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
