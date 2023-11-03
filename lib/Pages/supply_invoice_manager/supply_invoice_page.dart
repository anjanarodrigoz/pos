import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pos/Pages/invoice_draft_manager/invoice_customer_select.dart';

import 'package:pos/Pages/supply_invoice_manager/select_supplyer_page.dart';
import 'package:pos/Pages/supply_invoice_manager/supply_all_invoice.dart';
import 'package:pos/Pages/supply_invoice_manager/supply_save_invoice_page.dart';
import 'package:pos/api/email_sender.dart';

import 'package:pos/database/supplyer_invoice_db_service.dart';
import 'package:pos/enums/enums.dart';

import 'package:pos/utils/alert_message.dart';
import 'package:pos/widgets/alert_dialog.dart';
import 'package:pos/widgets/pos_button.dart';
import 'package:pos/widgets/verify_dialog.dart';

import '../../api/pdf_api.dart';
import '../../api/pdf_invoice_api.dart';

import '../../models/supply_invoice.dart';
import '../../theme/t_colors.dart';

class SupplyInvoicePage extends StatelessWidget {
  String invoiceId;
  late SupplyInvoice invoice;
  late BuildContext context;
  bool isReturnManger;
  SupplyInvoicePage(
      {super.key, required this.invoiceId, required this.isReturnManger});

  @override
  Widget build(BuildContext context) {
    this.context = context;
    invoice = SupplyerInvoiceDB().getInvoice(invoiceId);

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 40.0,
          backgroundColor: TColors.blue,
          title: Text(isReturnManger
              ? 'Return Note #$invoiceId'
              : 'Supplyer Invoice #$invoiceId'),
          leading: IconButton(
              onPressed: () {
                Get.offAll(SupplyAllInvoice(
                  isRetunManager: isReturnManger,
                ));
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        body: Row(children: [
          /*
            // Menu items
            */

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                PosButton(
                  onPressed: () => openCopyInvoice(),
                  text: 'Copy',
                ),
                PosButton(
                  onPressed: () async => await PdfInvoiceApi.printInvoice(
                      invoice,
                      invoiceType: InvoiceType.supplyInvoice),
                  text: 'Print',
                ),
                PosButton(
                  onPressed: () async =>
                      await EmailSender.showEmailSendingDialog(
                          context, invoice, InvoiceType.supplyInvoice),
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
          SupplySaveInvoicePage(invoice: invoice)
        ]));
  }

  Future<void> printInvoice(context) async {
    final pdfFile = await PdfInvoiceApi.generateSupplyInvoicePDF(invoice);
    PdfApi.openFile(pdfFile);
  }

  Future<void> deleteInvoice() async {
    showDialog(
        context: context,
        builder: (context) => POSVerifyDialog(
              title: 'Delete Invoice #${invoice.invoiceId}',
              content: 'Do you want to delete this invoice?',
              onContinue: () async {
                await SupplyerInvoiceDB().deleteInvoice(invoice);
                Get.offAll(SupplyAllInvoice());
              },
              continueText: 'Delete',
              verifyText: invoice.invoiceId,
              color: Colors.red,
            ));
  }

  Future<void> openCopyInvoice() async {
    if (invoice.itemList.isEmpty) {
      AlertMessage.snakMessage('This invoice can not be copy', context);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: SelectSupplyerPage(
                supplyInvoice: invoice,
                isRetunManager: isReturnManger,
              ),
            );
          });
    }
  }
}
