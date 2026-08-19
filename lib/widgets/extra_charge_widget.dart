import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos/repositories/extra_charge_template_repository.dart';

import '../models/extra_charges.dart';
import '../utils/my_format.dart';
import '../utils/val.dart';
import 'pos_text_form_field.dart';

class ExtraChargeDialog extends StatelessWidget {
  String? name;
  double? netPrice;
  String? comment;
  Function(ExtraCharges) onPressed;
  Function()? showSavedCharges;
  bool showSavedItem;

  ExtraChargeDialog(
      {super.key,
      this.name,
      this.netPrice,
      required this.onPressed,
      this.showSavedCharges,
      this.showSavedItem = true,
      this.comment});
  TextEditingController netPriceController = TextEditingController();
  TextEditingController totalPriceController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  double net = 0.0;
  @override
  Widget build(BuildContext context) {
    net = netPrice ?? 0.00;
    nameController.text = name ?? '';
    netPriceController.text = MyFormat.formatPrice(netPrice ?? 0.00);
    commentController.text = comment ?? '';
    totalPriceController.text = netPrice != null
        ? MyFormat.formatPrice(netPrice! * Val.gstTotalPrecentage)
        : '0.00';
    qtyController.text = '1';

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          showSavedItem
              ? const Text('Add Extra Charges')
              : const Text('Add New Extra Charges'),
          Visibility(
            visible: showSavedItem,
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  showSavedCharges!();
                },
                icon: const Icon(Icons.bookmark)),
          )
        ],
      ),
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
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        net = double.parse(value);
                        double totalWithGST = net +
                            (net * Val.gstPrecentage); // Assuming GST is 10%
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
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
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
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^-?\d*'))
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
            int qty =
                qtyController.text.isEmpty ? 0 : int.parse(qtyController.text);
            if (name.isNotEmpty && itemPrice >= 0.0) {
              ExtraCharges extraCharges = ExtraCharges(
                  name: name, qty: qty, price: itemPrice, comment: commnet);
              onPressed(extraCharges);
            } else {}
            Navigator.of(context).pop();
          },
          child: Text(showSavedItem ? 'Add to Invoice' : 'Add New'),
        ),
      ],
    );
  }
}

class ExtraChargeSavedDialog extends StatefulWidget {
  Function(ExtraCharges) onPressedSavedExtra;
  ExtraChargeSavedDialog({super.key, required this.onPressedSavedExtra});

  @override
  State<ExtraChargeSavedDialog> createState() => _ExtraChargeSavedDialogState();
}

class _ExtraChargeSavedDialogState extends State<ExtraChargeSavedDialog> {
  final ExtraChargeTemplateRepository _templateRepo = Get.find<ExtraChargeTemplateRepository>();
  late Function(ExtraCharges) onPressedSavedExtra;

  @override
  void initState() {
    super.initState();
    onPressedSavedExtra = widget.onPressedSavedExtra;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Saved Extra Charges'),
          IconButton(
              splashRadius: 20.0,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => ExtraChargeDialog(
                          showSavedItem: false,
                          onPressed: (ExtraCharges extraCharge) async {
                            await _templateRepo.createTemplate(
                              name: extraCharge.name,
                              price: extraCharge.price,
                              quantity: extraCharge.qty,
                              comment: extraCharge.comment,
                            );
                          },
                        ));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      content: SizedBox(
        width: 300.0,
        height: 500.0,
        child: StreamBuilder(
          stream: _templateRepo.watchAllTemplates(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No saved extra charges'));
            }

            final templates = snapshot.data!;

            return ListView.separated(
              itemCount: templates.length,
              itemBuilder: (context, index) {
                final template = templates[index];
                String name = template.name;
                double charge = template.price;
                String comment = template.comment ?? '';
                int qty = template.quantity;

                return ListTile(
                  title: Text(name),
                  trailing: IconButton(
                    splashRadius: 20.0,
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await _templateRepo.deleteTemplate(template.id);
                    },
                  ),
                  subtitle: Text('${MyFormat.formatPrice(charge)} x $qty'),
                  onTap: () {
                    ExtraCharges extraCharges = ExtraCharges(
                        name: name, qty: qty, price: charge, comment: comment);
                    onPressedSavedExtra(extraCharges);
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            );
          },
        ),
      ),
    );
  }
}
