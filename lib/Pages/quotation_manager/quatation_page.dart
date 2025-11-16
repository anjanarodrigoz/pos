import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/Pages/invoice_draft_manager/invoice_customer_select.dart';
import 'package:pos/Pages/quotation_manager/all_quotation_invoice.dart';
import 'package:pos/Pages/quotation_manager/quatation_draft_page.dart';
import 'package:pos/controllers/quote_draft_controller.dart';
import 'package:pos/repositories/invoice_repository.dart';
import 'package:pos/utils/invoice_converter.dart';
import 'package:pos/enums/enums.dart';
import 'package:pos/models/customer.dart';
import 'package:pos/utils/alert_message.dart';
import 'package:pos/widgets/pos_button.dart';
import 'package:pos/widgets/verify_dialog.dart';
import 'package:printing/printing.dart';
import '../../api/email_sender.dart';
import '../../api/pdf_api.dart';
import '../../api/pdf_invoice_api.dart';
import '../../models/invoice.dart';
import '../../theme/t_colors.dart';
import '../../widgets/print_verify.dart';
import 'QuoteInvoicePage.dart';

class QuotationPage extends StatefulWidget {
  final String invoiceId;

  const QuotationPage({super.key, required this.invoiceId});

  @override
  State<QuotationPage> createState() => _QuotationPageState();
}

class _QuotationPageState extends State<QuotationPage> {
  final InvoiceRepository _invoiceRepo = Get.find<InvoiceRepository>();
  Invoice? invoice;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInvoice();
  }

  Future<void> _loadInvoice() async {
    setState(() => _isLoading = true);

    final result = await _invoiceRepo.getFullInvoiceData(widget.invoiceId);

    if (result.isSuccess && result.data != null) {
      invoice = InvoiceConverter.fromFullInvoiceData(result.data!);
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 40.0,
          backgroundColor: TColors.blue,
          title: Text('Quote #${widget.invoiceId}'),
          leading: IconButton(
              onPressed: () {
                Get.offAll(AllQuotesPage());
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (invoice == null) {
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 40.0,
          backgroundColor: TColors.blue,
          title: Text('Quote #${widget.invoiceId}'),
          leading: IconButton(
              onPressed: () {
                Get.offAll(AllQuotesPage());
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        body: const Center(child: Text('Quotation not found')),
      );
    }

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 40.0,
          backgroundColor: TColors.blue,
          title: Text('Quote #${widget.invoiceId}'),
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
                    onPressed: () async => printInvoice(),
                    text: 'Print',
                  ),
                  // PosButton(
                  //   onPressed: () async =>
                  //       await EmailSender.showEmailSendingDialog(
                  //           context, invoice!, InvoiceType.quotation),
                  //   text: 'Email',
                  // ),
                  const SizedBox(
                    height: 50,
                  ),
                  PosButton(
                    onPressed: () => deleteInvoice(),
                    text: 'Remove',
                    color: Colors.red.shade400,
                  ),
                  const SizedBox(height: 150),
                ],
              ),
            ),
          ),
          QuoteInvoicePage(invoice: invoice!)
        ]));
  }

  Future<void> viewInvoice(invoice) async {
    Invoice oldInvoice = invoice.copyWith();
    final file = await PdfInvoiceApi.generateInvoicePDF(oldInvoice,
        invoiceType: InvoiceType.quotation);
    await PdfApi.openFile(file);
  }

  Future<void> deleteInvoice() async {
    showDialog(
        context: context,
        builder: (context) => POSVerifyDialog(
              title: 'Delete Invoice #${invoice!.invoiceId}',
              content: 'Do you want to delete this invoice?',
              onContinue: () async {
                await _invoiceRepo.deleteInvoice(invoice!.invoiceId);
                Get.offAll(AllQuotesPage());
              },
              continueText: 'Delete',
              verifyText: invoice!.invoiceId,
              color: Colors.red,
            ));
  }

  Future<void> openCopyInvoice() async {
    if (invoice!.itemList.isEmpty) {
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
                invoice: invoice!,
                invoiceType: invoiceType,
              ),
            );
          });
    });
  }

  openEditInvoice() {
    Get.put(QuoteDraftController(
        customer: Customer(
            id: invoice!.customerId,
            firstName: invoice!.customerName,
            mobileNumber: invoice!.customerMobile,
            lastName: ''),
        wantToUpdate: true,
        copyInvoice: invoice!));
    Get.offAll(const QuoteDraftPage());
  }

  void printInvoice() async {
    Invoice oldInvoice = invoice!.copyWith();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: PrintVerify(
              invoice: oldInvoice,
              onPrintPressed: (Printer printer, Invoice invoice) async {
                await PdfInvoiceApi.printInvoice(invoice,
                    printer: printer, invoiceType: InvoiceType.quotation);
              },
              onEmailPressed: (Invoice invoice) async {
                await EmailSender.showEmailSendingDialog(
                    context, invoice, InvoiceType.quotation);
              },
              onViewPressed: (Invoice invoice) {
                viewInvoice(invoice);
              },
            ),
          );
        });
  }
}
