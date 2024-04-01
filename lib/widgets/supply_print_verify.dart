import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/models/address.dart';
import 'package:pos/models/supply_invoice.dart';
import 'package:pos/widgets/pos_button.dart';
import 'package:printing/printing.dart';
import '../api/printer_manager.dart';
import 'pos_text_form_field.dart';
import 'printer_setup_buttton.dart';

class SupplyPrintVerify extends StatelessWidget {
  SupplyPrintVerify(
      {super.key,
      required this.invoice,
      required this.onPrintPressed,
      required this.onViewPressed,
      required this.onEmailPressed});

  final Function(Printer printer, SupplyInvoice invoice) onPrintPressed;
  final Function(SupplyInvoice invoice) onEmailPressed;
  final SupplyInvoice invoice;
  final Function(SupplyInvoice invoice) onViewPressed;

  final _formKey = GlobalKey<FormState>();

  final Address billingAddress = Address();

  String supplyerName = '';

  PrinterManager printerManager = PrinterManager();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 800.0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PosTextFormField(
                initialValue: invoice.supplyerName,
                labelText: 'Customer Name',
                onSaved: (value) =>
                    supplyerName = value ?? invoice.supplyerName,
              ),
              const SizedBox(
                height: 20.0,
              ),
              billingAddressForm(),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  PosButton(
                      text: 'Print',
                      onPressed: () {
                        updateInvoice();
                        if (printerManager.printer != null) {
                          onPrintPressed(printerManager.printer!, invoice);
                          Get.back();
                        } else {
                          showDialog(
                              context: context,
                              builder: (a) => const AlertDialog(
                                    content: Text('Please setup printer'),
                                  ));
                        }
                      }),
                  PosButton(
                      text: 'View',
                      onPressed: () {
                        updateInvoice();
                        onViewPressed(invoice);
                      }),
                  PosButton(
                      text: 'Email',
                      onPressed: () {
                        updateInvoice();
                        onEmailPressed(invoice);
                        Get.back();
                      }),
                  PrintSetupButton(onPrinterSelected: (Printer? printer) async {
                    printerManager.printer = printer;
                  })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  billingAddressForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '- Billing Address -',
          style: TextStyle(color: Colors.grey.shade500),
        ),
        PosTextFormField(
          initialValue: invoice.billingAddress?.street ?? '',
          labelText: 'Street',
          onSaved: (value) => billingAddress.street = value,
        ),
        PosTextFormField(
          initialValue: invoice.billingAddress?.city ?? '',
          labelText: 'City',
          onSaved: (value) => billingAddress.city = value,
        ),
        PosTextFormField(
          initialValue: invoice.billingAddress?.state ?? '',
          labelText: 'State',
          onSaved: (value) => billingAddress.state = value,
        ),
        PosTextFormField(
          initialValue: invoice.billingAddress?.postalCode ?? '',
          labelText: 'Postal Code',
          onSaved: (value) => billingAddress.postalCode = value,
        ),
      ],
    );
  }

  Future<void> updateInvoice() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      invoice.billingAddress = billingAddress;
      invoice.supplyerName = supplyerName;
    }
  }
}
