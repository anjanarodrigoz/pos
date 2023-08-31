import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos/Pages/invoice_draft_manager/invoice_item_select_page.dart';
import 'package:pos/Pages/invoice_manager/invoice_edit_view.dart';
import 'package:pos/Pages/invoice_manager/invoice_page.dart';
import 'package:pos/controllers/invoice_draft_contorller.dart';
import 'package:pos/controllers/invoice_edit_controller.dart';
import 'package:pos/database/Cart_db_service.dart';
import 'package:pos/database/invoice_db_service.dart';
import 'package:pos/models/extra_charges.dart';
import 'package:pos/utils/val.dart';
import '../../models/invoice.dart';
import '../../theme/t_colors.dart';
import '../../utils/my_format.dart';
import '../../widgets/pos_button.dart';
import '../../widgets/pos_text_form_field.dart';

class InvoiceEditPage extends StatelessWidget {
  InvoiceEditPage({super.key});
  final InvoiceEditController _controller = Get.find<InvoiceEditController>();
  late BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Invoice - #${_controller.invoice.invoiceId}',
          style: TStyle.titleBarStyle,
        ),
      ),
      body: Row(
        children: [
          /*
            // Menu items
            */

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                PosButton(
                    text: 'Add Item',
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: ((context) => Dialog(
                                child: InvoiceItemSelectPage(
                                  invoiceEditController: _controller,
                                ),
                              )));
                    }),
                PosButton(
                    text: 'Add Extra',
                    onPressed: () {
                      addExtraCharges();
                    }),
                PosButton(
                    text: 'Comments',
                    onPressed: () {
                      addComments();
                    }),
                SizedBox(height: 50.0),
                PosButton(
                  text: 'Update Invoice',
                  onPressed: () {
                    updateInvoice();
                  },
                ),
                PosButton(
                  text: 'Close',
                  onPressed: () async {
                    final storage = CartDB();
                    await storage.resetCart();
                    Get.offAll(InvoicePage());
                  },
                ),
              ],
            ),
          ),
          Column(
            children: [
              Expanded(child: InvoiceEditView()),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> addExtraCharges() async {
    TextEditingController netPriceController =
        TextEditingController(text: MyFormat.formatPrice(0));
    TextEditingController totalPriceController =
        TextEditingController(text: MyFormat.formatPrice(0));
    TextEditingController commentController = TextEditingController();
    TextEditingController qtyController = TextEditingController(text: '1');
    TextEditingController nameController = TextEditingController();
    double net = 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Extra Charges'),
          content: SizedBox(
            height: 250,
            child: Column(
              children: [
                PosTextFormField(
                  width: 400.0,
                  labelText: 'Name',
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter extra charges name';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      PosTextFormField(
                        width: 100.0,
                        labelText: 'Net price',
                        controller: netPriceController,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*')),
                        ],
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            net = double.parse(value);
                            double totalWithGST = net +
                                (net *
                                    Val.gstPrecentage); // Assuming GST is 10%
                            totalPriceController.text =
                                totalWithGST.toStringAsFixed(2);
                          } else {
                            totalPriceController.clear();
                          }
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      PosTextFormField(
                        width: 100.0,
                        controller: totalPriceController,
                        labelText: 'Total Price',
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*')),
                        ],
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            double totalWithGST = double.parse(value);
                            net = totalWithGST /
                                Val.gstTotalPrecentage; // Reverse GST calculation
                            netPriceController.text = net.toStringAsFixed(2);
                          } else {
                            netPriceController.clear();
                          }
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      PosTextFormField(
                        width: 100.0,
                        labelText: 'Quantity',
                        controller: qtyController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ],
                  ),
                ),
                PosTextFormField(
                  width: 400.0,
                  height: 80.0,
                  maxLines: 3,
                  labelText: 'Comment',
                  controller: commentController,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                double itemPrice = net;
                String commnet = commentController.text;
                String name = nameController.text;
                int qty = qtyController.text.isEmpty
                    ? 0
                    : int.parse(qtyController.text);
                if (name.isNotEmpty && itemPrice >= 0) {
                  ExtraCharges extraCharges = ExtraCharges(
                      name: name, qty: qty, price: itemPrice, comment: commnet);
                  _controller.addExtraCharges(extraCharges);
                } else {}
                Navigator.of(context).pop();
              },
              child: Text('Add to Invoice'),
            ),
          ],
        );
      },
    );
  }

  Future<void> addComments() async {
    String oldComment = '';
    if (_controller.comments.isNotEmpty) {
      for (String comment in _controller.comments) {
        oldComment += comment;
      }
    }
    TextEditingController commentController =
        TextEditingController(text: oldComment);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Comments'),
          content: SizedBox(
              height: 600,
              child: Column(children: [
                PosTextFormField(
                  width: 400.0,
                  height: 550.0,
                  maxLines: 30,
                  keyboardType: TextInputType.multiline,
                  labelText: 'Comment',
                  controller: commentController,
                ),
              ])),
          actions: [
            TextButton(
              onPressed: () {
                String comment = commentController.text;

                if (comment.isNotEmpty) {
                  _controller.addComments(comment);
                } else {
                  _controller.comments.clear();
                }
                Navigator.of(context).pop();
              },
              child: Text('Add to Invoice'),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateInvoice() async {
    await _controller.updateInvoice();
    Get.offAll(InvoicePage());
  }
}
