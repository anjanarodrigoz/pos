import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pos/Pages/invoice_draft_manager/invoice_item_select_page.dart';
import 'package:pos/Pages/invoice_manager/invoice_page.dart';
import 'package:pos/controllers/invoice_draft_contorller.dart';
import 'package:pos/database/cart_db_service.dart';

import 'package:pos/models/extra_charges.dart';

import 'package:pos/widgets/comments_widget.dart';
import 'package:pos/widgets/extra_charge_widget.dart';

import '../../theme/t_colors.dart';

import '../../widgets/pos_button.dart';
import '../../widgets/invoice_draft_widget.dart';

class InvoiceDraftPage extends StatelessWidget {
  InvoiceDraftPage({super.key});
  final InvoiceDraftController _controller = Get.find<InvoiceDraftController>();
  late BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: Obx(() => Text(
              'Draft Invoice - #${_controller.invoiceId.value}',
              style: TStyle.titleBarStyle,
            )),
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
                                  invoiceController: _controller,
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
                const SizedBox(height: 50.0),
                PosButton(
                  text: 'Close Draft',
                  onPressed: () async {
                    final storage = CartDB();
                    await storage.resetCart();
                    Get.offAll(InvoicePage());
                  },
                ),
                PosButton(
                  text: 'Save Invoice',
                  onPressed: () {
                    saveDraftInvoice();
                  },
                ),
              ],
            ),
          ),
          Column(
            children: [
              Expanded(
                  child: InvoiceDraftWidget(
                invoiceController: _controller,
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
          _controller.addExtraCharges(extraCharges);
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
                              _controller.addExtraCharges(extraCharges);
                            }));
                  }));
        });
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
    showDialog(
        context: context,
        builder: (context) {
          return CommentsDialog(
              oldComment: oldComment,
              onPressed: (comment) {
                if (comment.isNotEmpty) {
                  _controller.addComments(comment);
                } else {
                  _controller.comments.clear();
                }
              });
        });
  }

  Future<void> saveDraftInvoice() async {
    await _controller.saveInvoice();
    Get.offAll(InvoicePage());
  }
}
