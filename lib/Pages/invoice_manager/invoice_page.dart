import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos/Pages/invoice_draft_manager/invoice_customer_select.dart';
import 'package:pos/Pages/invoice_manager/invoice_edit_page.dart';
import 'package:pos/Pages/invoice_manager/save_invoice_page.dart';
import 'package:pos/Pages/invoice_manager/search_invoice_page.dart';
import 'package:pos/api/email_sender.dart';
import 'package:pos/api/printer_manager.dart';
import 'package:pos/database/invoice_db_service.dart';
import 'package:pos/enums/enums.dart';
import 'package:pos/models/payment.dart';
import 'package:pos/utils/alert_message.dart';
import 'package:pos/widgets/pos_appbar.dart';
import 'package:pos/widgets/pos_button.dart';
import 'package:pos/widgets/pos_text_form_field.dart';
import 'package:pos/widgets/print_verify.dart';
import 'package:pos/widgets/verify_dialog.dart';
import 'package:printing/printing.dart';

import '../../api/pdf_invoice_api.dart';
import '../../controllers/invoice_edit_controller.dart';

import '../../models/invoice.dart';
import '../../theme/t_colors.dart';

class InvoicePage extends StatefulWidget {
  String? searchInvoiceId;
  InvoicePage({super.key, this.searchInvoiceId});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  List<Invoice> invoiceList = [];
  late final Invoice invoice;
  final RxInt index = 0.obs;
  String? searchInvoiceId;
  int ss = 77;

  @override
  void initState() {
    // TODO: implement initState
    searchInvoiceId = widget.searchInvoiceId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PosAppBar(title: 'Invoice Page'),
      body: Row(
        children: [
          /*
            // Menu items
            */

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                PosButton(
                  onPressed: () => openNewInvoice(context),
                  text: '+ New invoice',
                ),
                PosButton(
                  onPressed: () => searchInvoices(),
                  text: 'Search invoice',
                ),
                PosButton(
                  onPressed: () => openOldInvoice(),
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
                //           context, invoice, InvoiceType.invoice),
                //   text: 'Email',
                // ),
                PosButton(
                  onPressed: () => payAmout(),
                  text: 'Pay',
                  color: Colors.green,
                ),
                const SizedBox(
                  height: 50,
                ),
                PosButton(
                  onPressed: () => deleteInvoice(),
                  text: 'Remove',
                  color: Colors.red.shade400,
                ),
                const SizedBox(height: 150),
                Card(
                  color: TColors.blue,
                  elevation: 5.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            color: Colors.white,
                            icon: const Icon(
                                Icons.keyboard_double_arrow_left_rounded),
                            onPressed: () {
                              searchInvoiceId = null;
                              index.value = invoiceList.length - 1;
                              invoice = invoiceList[index.value];
                            },
                          ),
                          IconButton(
                            color: Colors.white,
                            icon: const Icon(Icons.keyboard_arrow_left_rounded),
                            onPressed: () {
                              if (index.value < invoiceList.length - 1) {
                                searchInvoiceId = null;
                                index.value += 1;
                                invoice = invoiceList[index.value];
                              }
                            },
                          ),
                          IconButton(
                            color: Colors.white,
                            icon:
                                const Icon(Icons.keyboard_arrow_right_rounded),
                            onPressed: () {
                              if (index.value != 0) {
                                searchInvoiceId = null;
                                index.value -= 1;
                                invoice = invoiceList[index.value];
                              }
                            },
                          ),
                          IconButton(
                            color: Colors.white,
                            icon: const Icon(
                                Icons.keyboard_double_arrow_right_rounded),
                            onPressed: () {
                              searchInvoiceId = null;
                              index.value = 0;
                              invoice = invoiceList[index.value];
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          StreamBuilder(
            stream: InvoiceDB().getStreamInvoice(),
            builder: (context, snapshot) {
              final list = snapshot.data ?? [];
              invoiceList = list.reversed.toList();
              if (searchInvoiceId != null) {
                (index.value = invoiceList.indexOf(invoiceList
                    .where((element) => element.invoiceId == searchInvoiceId)
                    .first));
              }
              return invoiceList.isNotEmpty
                  ? Obx(() {
                      invoice = invoiceList[index.value];

                      return SaveInvoiceViewPage(invoice: invoice);
                    })
                  : const Center(
                      child: Text('No invoices found'),
                    );
            },
          ),
        ],
      ),
    );
  }

  openNewInvoice(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: InvoiceCustomerSelectPage(
              invoiceType: InvoiceType.invoice,
            ),
          );
        });
  }

  void openOldInvoice() async {
    if (invoice.isDeleted) {
      AlertMessage.snakMessage(
          'This invoice has been deleted and Can nott open be edited.',
          context);
      return;
    }
    if (invoice.isPaid) {
      AlertMessage.snakMessage(
          'This invoice has been paid and Can not be edited.', context);
      return;
    }

    final controller = Get.put(InvoiceEditController(invoice: invoice));
    Get.to(() => InvoiceEditPage(
          controller: controller,
        ));
  }

  Future<void> deleteInvoice() async {
    if (invoice.isPaid == true) {
      AlertMessage.snakMessage(
          'Invoice has been paid and cannot be deleted.', context);
    } else if ((invoice.payments ?? []).isNotEmpty) {
      AlertMessage.snakMessage(
          'This invoive has some payments.please remove the payments.',
          context);
    } else if (invoice.isDeleted) {
      AlertMessage.snakMessage(
          'This invoive has been deleted already.', context);
    } else {
      showDialog(
          context: context,
          builder: (context) => POSVerifyDialog(
                title: 'Delete Invoice #${invoice.invoiceId}',
                content: 'Do you want to delete this invoice?',
                onContinue: () async {
                  await InvoiceDB().deleteInvoice(invoice);
                  Get.back();
                },
                continueText: 'Delete',
                color: Colors.red,
                verifyText: invoice.invoiceId,
              ));
    }
    setState(() {});
  }

  void payAmout() {
    TextEditingController paymentAmountController =
        TextEditingController(text: invoice.toPay.toStringAsFixed(2));
    Rx<Paymethod> payMethod = Paymethod.cash.obs;
    TextEditingController commentController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Make a Payment'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'To Pay: \$${invoice.toPay.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  PosTextFormField(
                    onTap: () => paymentAmountController.selection =
                        TextSelection(
                            baseOffset: 0,
                            extentOffset:
                                paymentAmountController.value.text.length),
                    controller: paymentAmountController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                    ],
                    labelText: 'Pay amount',
                    prefixIcon: Icon(Icons.attach_money_outlined),
                  ),
                  const SizedBox(height: 20),
                  Obx(
                    () => DropdownButtonFormField(
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                      value: payMethod.value,
                      onChanged: (Paymethod? newValue) {
                        setState(() {
                          payMethod.value = newValue!;
                        });
                      },
                      items: Paymethod.values.map((Paymethod value) {
                        return DropdownMenuItem<Paymethod>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(value.displayName),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  PosTextFormField(
                    labelText: 'Comment',
                    controller: commentController,
                    prefixIcon: const Icon(Icons.comment),
                  ),
                ],
              ),
              actions: [
                PosButton(
                  onPressed: () async {
                    double paymentAmount =
                        double.tryParse(paymentAmountController.text) ?? 0.0;
                    if (paymentAmount > 0.0 && paymentAmount <= invoice.toPay) {
                      Payment payment = Payment(
                          date: DateTime.now(),
                          amount: paymentAmount,
                          comment: commentController.text,
                          paymethod: payMethod.value);

                      await InvoiceDB().addInvoicePayment(payment, invoice);
                      Navigator.of(context).pop();
                    } else {
                      AlertMessage.snakMessage('Enter valid amount', context);
                    }
                  },
                  text: 'Pay',
                ),
              ],
            ));
  }

  void searchInvoices() {
    Get.to(const InvoiceSearchPage());
  }

  Future<void> openCopyInvoice() async {
    if (invoice.isDeleted) {
      AlertMessage.snakMessage('This invoice can not be copy', context);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: InvoiceCustomerSelectPage(
                invoice: invoice,
                invoiceType: InvoiceType.invoice,
              ),
            );
          });
    }
  }

  void printInvoice() async {
    Invoice oldInvoice = invoice.copyWith();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: PrintVerify(
              invoice: oldInvoice,
              onPrintPressed: (Printer printer, Invoice invoice) async {
                await PdfInvoiceApi.printInvoice(invoice,
                    printer: printer, invoiceType: InvoiceType.invoice);
              },
              onEmailPressed: (Invoice invoice) async {
                await EmailSender.showEmailSendingDialog(
                    context, invoice, InvoiceType.invoice);
              },
            ),
          );
        });
  }
}
