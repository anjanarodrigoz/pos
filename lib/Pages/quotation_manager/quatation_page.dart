import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pos/Pages/invoice_draft_manager/invoice_customer_select.dart';
import 'package:pos/Pages/quotation_manager/all_quotation_invoice.dart';
import 'package:pos/Pages/quotation_manager/quatation_draft_page.dart';
import 'package:pos/controllers/quote_draft_controller.dart';
import 'package:pos/database/quatation_db_serive.dart';

import 'package:pos/enums/enums.dart';
import 'package:pos/models/customer.dart';

import 'package:pos/utils/alert_message.dart';
import 'package:pos/widgets/alert_dialog.dart';

import 'package:pos/widgets/pos_button.dart';

import 'package:window_manager/window_manager.dart';
import '../../api/pdf_api.dart';
import '../../api/pdf_invoice_api.dart';

import '../../models/invoice.dart';

import '../../theme/t_colors.dart';
import 'QuoteInvoicePage.dart';

class QuotationPage extends StatelessWidget {
  final String invoiceId;

  QuotationPage({super.key, required this.invoiceId});

  late final Invoice invoice;
  late final BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    invoice = QuotationDB().getInvoice(invoiceId);
    WindowOptions windowOptions = const WindowOptions(
        minimumSize: Size(1300, 800), size: Size(1300, 800), center: true);

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
    });

    return Scaffold(
        appBar: AppBar(
          backgroundColor: TColors.blue,
          title: Text('Quote #$invoiceId'),
          leading: IconButton(
              onPressed: () {
                Get.offAll(AllQuotesPage());
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        body: Row(children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  PosButton(
                    onPressed: () => openEditInvoice(),
                    text: 'Edit',
                  ),
                  PosButton(
                    onPressed: () => openCopyInvoice(),
                    text: 'Copy',
                  ),
                  PosButton(
                    onPressed: () => printInvoice(context),
                    text: 'Print',
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  PosButton(
                    onPressed: () => deleteInvoice(),
                    text: 'Remove',
                    color: Colors.red.shade400,
                  ),
                  SizedBox(height: 150),
                ],
              ),
            ),
          ),
          QuoteInvoicePage(invoice: invoice)
        ]));
  }

  Future<void> printInvoice(context) async {
    final pdfFile = await PdfInvoiceApi.generateInvoicePDF(invoice,
        invoiceType: InvoiceType.quotation);
    PdfApi.openFile(pdfFile);
  }

  Future<void> deleteInvoice() async {
    showDialog(
        context: context,
        builder: (context) => POSAleartDialog(
              title: 'Delete Invoice #${invoice.invoiceId}',
              content: 'Do you want to delete this invoice?',
              onCountinue: () async {
                await QuotationDB().deleteInvoice(invoice);
                Get.offAll(AllQuotesPage());
              },
              textContine: 'Delete',
              color: Colors.red,
            ));
  }

  Future<void> openCopyInvoice() async {
    if (invoice.itemList.isEmpty) {
      AlertMessage.snakMessage('This invoice can not be copy', context);
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Copy Quote'),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  PosButton(
                      text: 'Copy to Invoice',
                      onPressed: () => showCopyDialog(InvoiceType.invoice)),
                  const SizedBox(height: 20),
                  PosButton(
                      text: 'Copy to Quote',
                      onPressed: () => showCopyDialog(InvoiceType.quotation)),
                  const SizedBox(height: 20),
                  PosButton(
                      text: 'Copy to Credit Note',
                      onPressed: () => showCopyDialog(InvoiceType.creditNote))
                ]),
              ));
    }
  }

  void showCopyDialog(InvoiceType invoiceType) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Show the dialog
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: InvoiceCustomerSelectPage(
                invoice: invoice,
                invoiceType: invoiceType,
              ),
            );
          });
    });
  }

  openEditInvoice() {
    Get.put(QuoteDraftController(
        customer: Customer(
            id: invoice.customerId,
            firstName: invoice.customerName,
            mobileNumber: invoice.customerMobile,
            lastName: ''),
        wantToUpdate: true,
        copyInvoice: invoice));
    Get.offAll(QuoteDraftPage());
  }
}
