import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos/Pages/invoice_draft_manager/invoice_customer_select.dart';
import 'package:pos/Pages/invoice_manager/invoice_edit_page.dart';
import 'package:pos/Pages/invoice_manager/save_invoice_page.dart';
import 'package:pos/Pages/invoice_manager/search_invoice_page.dart';
import 'package:pos/database/invoice_db_service.dart';
import 'package:pos/models/payment.dart';
import 'package:pos/utils/alert_message.dart';
import 'package:pos/widgets/alert_dialog.dart';
import 'package:pos/widgets/pos_button.dart';
import 'package:pos/widgets/pos_text_form_field.dart';
import 'package:window_manager/window_manager.dart';
import '../../api/pdf_api.dart';
import '../../api/pdf_invoice_api.dart';
import '../../controllers/invoice_edit_controller.dart';
import '../../models/invoice.dart';
import '../../theme/t_colors.dart';
import '../main_window.dart';

class InvoicePage extends StatefulWidget {
  String? searchInvoiceId;
  InvoicePage({super.key, this.searchInvoiceId});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  List<Invoice> invoiceList = [];
  late Invoice invoice;
  final RxInt index = 0.obs;
  String? searchInvoiceId;

  @override
  void initState() {
    // TODO: implement initState
    searchInvoiceId = widget.searchInvoiceId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WindowOptions windowOptions = const WindowOptions(
        minimumSize: Size(1300, 800), size: Size(1300, 800), center: true);

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColors.blue,
        title: const Text('Invoice Page'),
        leading: IconButton(
            onPressed: () {
              Get.offAll(const MainWindow());
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Row(
        children: [
          /*
            // Menu items
            */

          Container(
            child: Padding(
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
                    onPressed: () => printInvoice(context),
                    text: 'Print',
                  ),
                  PosButton(
                    onPressed: () => payAmout(),
                    text: 'Pay',
                    color: Colors.green,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  PosButton(
                    onPressed: () => deleteInvoice(),
                    text: 'Remove',
                    color: Colors.red.shade400,
                  ),
                  SizedBox(height: 150),
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
                              icon: Icon(
                                  Icons.keyboard_double_arrow_left_rounded),
                              onPressed: () {
                                searchInvoiceId = null;
                                index.value = invoiceList.length - 1;
                                invoice = invoiceList[index.value];
                              },
                            ),
                            IconButton(
                              color: Colors.white,
                              icon: Icon(Icons.keyboard_arrow_left_rounded),
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
                              icon: Icon(Icons.keyboard_arrow_right_rounded),
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
                              icon: Icon(
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
            child: InvoiceCustomerSelectPage(),
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
    Get.put(InvoiceEditController(invoice: invoice));
    Get.to(InvoiceEditPage());
  }

  Future<void> printInvoice(context) async {
    final pdfFile = await PdfInvoiceApi.generate(invoiceList[index.value]);
    PdfApi.openFile(pdfFile);
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
          builder: (context) => POSAleartDialog(
                title: 'Delete Invoice #${invoice.invoiceId}',
                content: 'Do you want to delete this invoice?',
                onCountinue: () async {
                  await InvoiceDB().deleteInvoice(invoice);
                  Navigator.of(context).pop();
                },
                textContine: 'Delete',
                color: Colors.red,
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
                    style: TextStyle(fontWeight: FontWeight.bold),
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
                        TextInputType.numberWithOptions(decimal: true),
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
    Get.to(InvoiceSearchPage());
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
              ),
            );
          });
    }
  }
}
