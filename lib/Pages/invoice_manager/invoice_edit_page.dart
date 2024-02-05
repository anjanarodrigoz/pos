import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos/Pages/invoice_draft_manager/invoice_item_select_page.dart';
import 'package:pos/Pages/invoice_manager/invoice_edit_view.dart';
import 'package:pos/Pages/invoice_manager/invoice_page.dart';
import 'package:pos/controllers/invoice_draft_contorller.dart';
import 'package:pos/controllers/invoice_edit_controller.dart';
import 'package:pos/database/cart_db_service.dart';
import 'package:pos/database/invoice_db_service.dart';
import 'package:pos/models/extra_charges.dart';
import 'package:pos/utils/val.dart';
import '../../models/invoice.dart';
import '../../theme/t_colors.dart';
import '../../utils/my_format.dart';
import '../../widgets/comments_widget.dart';
import '../../widgets/extra_charge_widget.dart';
import '../../widgets/pos_button.dart';
import '../../widgets/pos_text_form_field.dart';

class InvoiceEditPage extends StatelessWidget {
  final InvoiceEditController controller;
  late BuildContext context;

  InvoiceEditPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40.0,
        title: Text(
          'Edit Invoice - #${controller.invoice.invoiceId}',
          style: TStyle.titleBarStyle,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            await back();
          },
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
                                  invoiceEditController: controller,
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
                    await back();
                  },
                ),
              ],
            ),
          ),
          Column(
            children: [
              Expanded(
                  child: InvoiceEditView(
                invoiceController: controller,
              )),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> addExtraCharges() async {
    showDialog(
      context: context,
      builder: (context) {
        return ExtraChargeDialog(onPressed: (ExtraCharges extraCharges) {
          controller.addExtraCharges(extraCharges);
        }, showSavedCharges: () {
          showDialog(
              context: context,
              builder: (context) => ExtraChargeSavedDialog(
                      onPressedSavedExtra: (ExtraCharges extraCharges) {
                    showDialog(
                        context: context,
                        builder: (context) => ExtraChargeDialog(
                            name: extraCharges.name,
                            comment: extraCharges.comment,
                            netPrice: extraCharges.price,
                            onPressed: (ExtraCharges extraCharges) {
                              controller.addExtraCharges(extraCharges);
                            }));
                  }));
        });
      },
    );
  }

  Future<void> addComments() async {
    String oldComment = '';
    if (controller.comments.isNotEmpty) {
      for (String comment in controller.comments) {
        oldComment += comment;
      }
    }
    showDialog(
        context: context,
        builder: (context) {
          return CommentsDialog(
              oldComment: oldComment,
              onPressed: (comment) {
                if (comment.isNotEmpty) {
                  controller.addComments(comment);
                  controller.close();
                } else {
                  controller.comments.clear();
                  controller.close();
                }
              });
        });
  }

  Future<void> updateInvoice() async {
    await controller.updateInvoice();
    Get.offAll(InvoicePage(searchInvoiceId: controller.invoice.invoiceId));
  }

  Future<void> back() async {
    final storage = CartDB();
    await storage.resetCart();

    if (!controller.isClosed) {
      Get.delete<InvoiceEditController>();
    }
    Get.back();
  }
}
