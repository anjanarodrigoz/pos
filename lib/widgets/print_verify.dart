import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pos/api/printer_manager.dart';
import 'package:pos/models/address.dart';
import 'package:pos/utils/alert_message.dart';
import 'package:pos/widgets/pos_button.dart';
import 'package:pos/widgets/printer_setup_buttton.dart';
import 'package:printing/printing.dart';

import '../models/invoice.dart';
import 'pos_text_form_field.dart';

class PrintVerify extends StatelessWidget {
  PrintVerify(
      {super.key,
      required this.invoice,
      required this.onPrintPressed,
      required this.onEmailPressed});

  final Invoice invoice;
  final Function(Printer printer, Invoice invoice) onPrintPressed;
  final Function(Invoice invoice) onEmailPressed;

  final _formKey = GlobalKey<FormState>();

  final Address shippingAddress = Address();

  final Address billingAddress = Address();

  String customerName = '';

  PrinterManager printerManager = PrinterManager();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 700.0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PosTextFormField(
                initialValue: invoice.customerName,
                labelText: 'Customer Name',
                onSaved: (value) =>
                    customerName = value ?? invoice.customerName,
              ),
              const SizedBox(
                height: 30.0,
              ),
              Row(
                children: [
                  billingAddressForm(),
                  const SizedBox(
                    width: 20.0,
                  ),
                  shippingAddressForm(),
                ],
              ),
              const SizedBox(
                height: 30.0,
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

  shippingAddressForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '- Shipping Address -',
          style: TextStyle(color: Colors.grey.shade500),
        ),
        PosTextFormField(
          initialValue: invoice.shippingAddress?.street ?? '',
          labelText: 'Street',
          onSaved: (value) => shippingAddress.street = value,
        ),
        PosTextFormField(
          initialValue: invoice.shippingAddress?.city ?? '',
          labelText: 'City',
          onSaved: (value) => shippingAddress.city = value,
        ),
        PosTextFormField(
          initialValue: invoice.shippingAddress?.state ?? '',
          labelText: 'State',
          onSaved: (value) => shippingAddress.state = value,
        ),
        PosTextFormField(
          initialValue: invoice.shippingAddress?.postalCode ?? '',
          labelText: 'Postal Code',
          onSaved: (value) => shippingAddress.postalCode = value,
        ),
      ],
    );
  }

  Future<void> updateInvoice() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      invoice.billingAddress = billingAddress;
      invoice.shippingAddress = shippingAddress;
      invoice.customerName = customerName;
    }
  }
}
