import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/Pages/supply_invoice_manager/supply_all_invoice.dart';
import 'package:pos/Pages/supply_invoice_manager/supply_invoice_view.dart';
import 'package:pos/database/supplyer_invoice_db_service.dart';
import 'package:pos/models/extra_charges.dart';
import 'package:pos/widgets/comments_widget.dart';
import 'package:pos/widgets/extra_charge_widget.dart';
import 'package:pos/widgets/item_select_widget.dart';
import 'package:pos/widgets/pos_text_form_field.dart';
import '../../controllers/suppy_invoice_draft_controller.dart';
import '../../theme/t_colors.dart';
import '../../widgets/pos_button.dart';

class SupplyInvoiceDraftPage extends StatelessWidget {
  SupplyInvoiceDraftPage({super.key});

  final SupplyInvoiceDraftController _controller =
      Get.find<SupplyInvoiceDraftController>();

  late BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Show the dialog
      openDailog();
    });

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40.0,
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
                                child: ItemSelectWidget(
                                    invoiceController: _controller),
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
                  text: 'Close Draft',
                  onPressed: () async {
                    Get.delete<SupplyInvoiceDraftController>();
                    Get.offAll(SupplyAllInvoice());
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
              Expanded(child: SupplyInvoiceView()),
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
    Get.offAll(SupplyAllInvoice());
  }

  void openDailog() {
    TextEditingController realInvoiceIdController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) => SizedBox(
              height: 200.0,
              width: 400.0,
              child: AlertDialog(
                title: const Text('Real Invoice ID'),
                content: PosTextFormField(
                    controller: realInvoiceIdController,
                    labelText: 'Real Invoice ID'),
                actions: [
                  TextButton(
                      onPressed: () {
                        _controller.referenceId.value =
                            realInvoiceIdController.text;
                        Navigator.of(context).pop();
                      },
                      child: const Text('save')),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('close'))
                ],
              ),
            ));
  }
}
