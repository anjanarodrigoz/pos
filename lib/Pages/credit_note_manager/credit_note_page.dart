import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pos/Pages/credit_note_manager/all_credit_note_page.dart';
import 'package:pos/Pages/credit_note_manager/credit_draft_page.dart';
import 'package:pos/Pages/invoice_draft_manager/invoice_customer_select.dart';
import 'package:pos/Pages/quotation_manager/all_quotation_invoice.dart';
import 'package:pos/controllers/credit_draft_controller.dart';
import 'package:pos/controllers/quote_draft_controller.dart';
import 'package:pos/database/credit_db_serive.dart';
import 'package:pos/enums/enums.dart';
import 'package:pos/models/customer.dart';
import 'package:pos/utils/alert_message.dart';
import 'package:pos/widgets/alert_dialog.dart';
import 'package:pos/widgets/pos_button.dart';
import 'package:pos/widgets/verify_dialog.dart';
import 'package:printing/printing.dart';
import '../../api/email_sender.dart';
import '../../api/pdf_api.dart';
import '../../api/pdf_invoice_api.dart';
import '../../models/invoice.dart';
import '../../theme/t_colors.dart';
import 'creditInvoicePage.dart';

class CreditNotePage extends StatelessWidget {
  final String invoiceId;

  CreditNotePage({super.key, required this.invoiceId});

  late final Invoice invoice;
  late final BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    invoice = CreditNoteDB().getInvoice(invoiceId);

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 40.0,
          backgroundColor: TColors.blue,
          title: Text('Credit Note #$invoiceId'),
          leading: IconButton(
              onPressed: () {
                Get.offAll(AllCreditNotePage());
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        body: Row(children: [
          Padding(
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
                  onPressed: () async => await PdfInvoiceApi.printInvoice(
                      invoice,
                      invoiceType: InvoiceType.creditNote),
                  text: 'Print',
                ),
                PosButton(
                  onPressed: () async =>
                      await EmailSender.showEmailSendingDialog(
                          context, invoice, InvoiceType.creditNote),
                  text: 'Email',
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
          CreditInvoicePage(invoice: invoice)
        ]));
  }

  Future<void> deleteInvoice() async {
    showDialog(
        context: context,
        builder: (context) => POSVerifyDialog(
              title: 'Delete Invoice #${invoice.invoiceId}',
              content: 'Do you want to delete this invoice?',
              onContinue: () async {
                await CreditNoteDB().deleteInvoice(invoice);
                Get.offAll(AllCreditNotePage());
              },
              verifyText: invoice.invoiceId,
              continueText: 'Delete',
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
                      text: 'Copy to Credit Note',
                      onPressed: () => showCopyDialog(InvoiceType.creditNote)),
                  const SizedBox(height: 20),
                  PosButton(
                      text: 'Copy to Quote',
                      onPressed: () => showCopyDialog(InvoiceType.quotation)),
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
    Get.put(CreditDraftController(
        customer: Customer(
            id: invoice.customerId,
            firstName: invoice.customerName,
            mobileNumber: invoice.customerMobile,
            lastName: ''),
        wantToUpdate: true,
        copyInvoice: invoice));
    Get.offAll(CreditDraftPage());
  }
}
