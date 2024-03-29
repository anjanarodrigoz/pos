import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/Pages/credit_note_manager/credit_draft_page.dart';
import 'package:pos/Pages/invoice_draft_manager/invoice_draft_page.dart';
import 'package:pos/Pages/quotation_manager/all_quotation_invoice.dart';
import 'package:pos/controllers/credit_draft_controller.dart';
import 'package:pos/controllers/invoice_draft_contorller.dart';
import 'package:pos/controllers/quote_draft_controller.dart';
import 'package:pos/enums/enums.dart';

import '../../database/customer_db_service.dart';
import '../../models/address.dart';
import '../../models/customer.dart';
import '../../models/invoice.dart';
import '../../theme/t_colors.dart';
import '../../widgets/pos_text_form_field.dart';
import '../quotation_manager/quatation_draft_page.dart';

class InvoiceCustomerViewPage extends StatefulWidget {
  String cusId;
  Invoice? invoice;
  InvoiceType invoiceType;
  InvoiceCustomerViewPage(
      {super.key,
      required this.cusId,
      this.invoice,
      required this.invoiceType});

  @override
  State<InvoiceCustomerViewPage> createState() =>
      _InvoiceCustomerViewPageState();
}

class _InvoiceCustomerViewPageState extends State<InvoiceCustomerViewPage> {
  late Customer _customer;
  final _formKey = GlobalKey<FormState>();
  final Address deliveryAddress = Address();
  final Address postalAddress = Address();
  final dbService = CustomerDB();
  Invoice? invoice;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _customer = dbService.getCustomer(widget.cusId);
    invoice = widget.invoice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40.0,
        title: Text(
          '${_customer.firstName} ${_customer.lastName} - #${_customer.id}',
          style: const TextStyle(fontSize: 13.0),
        ),
      ),
      body: Container(
        color: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '- Customer Details -',
                                  style: TextStyle(color: Colors.grey.shade500),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                PosTextFormField(
                                  initialValue: _customer.firstName,
                                  labelText: 'First Name',
                                  onSaved: (value) =>
                                      _customer.firstName = value!,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter first name';
                                    }
                                    return null;
                                  },
                                ),
                                PosTextFormField(
                                  initialValue: _customer.lastName,
                                  labelText: 'Last Name',
                                  onSaved: (value) =>
                                      _customer.lastName = value!,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter last name';
                                    }
                                    return null;
                                  },
                                ),
                                PosTextFormField(
                                  initialValue: _customer.mobileNumber,
                                  labelText: 'Mobile Number',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter mobile number';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) =>
                                      _customer.mobileNumber = value!,
                                ),
                                // Add more TextFormField widgets for other customer properties
                                PosTextFormField(
                                  initialValue: _customer.fax ?? '',
                                  labelText: 'Fax',
                                  onSaved: (value) => _customer.fax = value,
                                ),
                                PosTextFormField(
                                  initialValue: _customer.web ?? '',
                                  labelText: 'Web',
                                  onSaved: (value) => _customer.web = value,
                                ),
                                PosTextFormField(
                                  initialValue: _customer.email ?? '',
                                  labelText: 'Email',
                                  onSaved: (value) => _customer.email = value,
                                ),
                                PosTextFormField(
                                  initialValue: _customer.abn ?? '',
                                  labelText: 'ABN',
                                  onSaved: (value) => _customer.web = value,
                                ),
                                PosTextFormField(
                                  initialValue: _customer.acn ?? '',
                                  labelText: 'ACN',
                                  onSaved: (value) => _customer.web = value,
                                ),

                                // Add more TextFormField widgets for other customer properties
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '- Delivery Address -',
                                          style: TextStyle(
                                              color: Colors.grey.shade500),
                                        ),
                                        const SizedBox(
                                          height: 20.0,
                                        ),
                                        PosTextFormField(
                                          initialValue: _customer
                                                  .deliveryAddress?.street ??
                                              '',
                                          labelText: 'Street',
                                          onSaved: (value) =>
                                              deliveryAddress.street = value,
                                        ),
                                        PosTextFormField(
                                          initialValue:
                                              _customer.deliveryAddress?.city ??
                                                  '',
                                          labelText: 'City',
                                          onSaved: (value) =>
                                              deliveryAddress.city = value,
                                        ),
                                        PosTextFormField(
                                          initialValue: _customer
                                                  .deliveryAddress?.state ??
                                              '',
                                          labelText: 'State',
                                          onSaved: (value) =>
                                              deliveryAddress.state = value,
                                        ),
                                        PosTextFormField(
                                          initialValue: _customer
                                                  .deliveryAddress?.areaCode ??
                                              '',
                                          labelText: 'Area Code',
                                          onSaved: (value) =>
                                              deliveryAddress.areaCode = value,
                                        ),
                                        PosTextFormField(
                                          initialValue: _customer
                                                  .deliveryAddress
                                                  ?.postalCode ??
                                              '',
                                          labelText: 'Postal Code',
                                          onSaved: (value) => deliveryAddress
                                              .postalCode = value,
                                        ),
                                        PosTextFormField(
                                          initialValue: _customer
                                                  .deliveryAddress?.county ??
                                              '',
                                          labelText: 'Country',
                                          onSaved: (value) =>
                                              deliveryAddress.county = value,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          '- Postal Address -',
                                          style: TextStyle(
                                              color: Colors.grey.shade500),
                                        ),
                                        const SizedBox(
                                          height: 20.0,
                                        ),
                                        PosTextFormField(
                                          initialValue:
                                              _customer.postalAddress?.street ??
                                                  '',
                                          labelText: 'Street',
                                          onSaved: (value) =>
                                              postalAddress.street = value,
                                        ),
                                        PosTextFormField(
                                          initialValue:
                                              _customer.postalAddress?.city ??
                                                  '',
                                          labelText: 'City',
                                          onSaved: (value) =>
                                              postalAddress.city = value,
                                        ),
                                        PosTextFormField(
                                          initialValue:
                                              _customer.postalAddress?.state ??
                                                  '',
                                          labelText: 'State',
                                          onSaved: (value) =>
                                              postalAddress.state = value,
                                        ),
                                        PosTextFormField(
                                          initialValue: _customer
                                                  .postalAddress?.areaCode ??
                                              '',
                                          labelText: 'Area Code',
                                          onSaved: (value) =>
                                              postalAddress.areaCode = value,
                                        ),
                                        PosTextFormField(
                                          initialValue: _customer
                                                  .postalAddress?.postalCode ??
                                              '',
                                          labelText: 'Postal Code',
                                          onSaved: (value) =>
                                              postalAddress.postalCode = value,
                                        ),
                                        PosTextFormField(
                                          initialValue:
                                              _customer.postalAddress?.county ??
                                                  '',
                                          labelText: 'Country',
                                          onSaved: (value) =>
                                              postalAddress.county = value,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '- Add customer comment -',
                                      style: TextStyle(
                                          color: Colors.grey.shade500),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: PosTextFormField(
                                        initialValue: _customer.comment ?? '',
                                        width: 650.0,
                                        labelText: 'Commnet',
                                        onSaved: (value) =>
                                            _customer.comment = value,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30.0, bottom: 30.0),
              child: IconButton(
                  icon: const Icon(
                    Icons.arrow_circle_right_rounded,
                    size: 45,
                  ),
                  color: Colors.blue,
                  splashRadius: 20.0,
                  onPressed: () => _updateCustomerDetails()),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _updateCustomerDetails() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      _customer.deliveryAddress = deliveryAddress;
      _customer.postalAddress = postalAddress;
      switch (widget.invoiceType) {
        case InvoiceType.invoice:
          Get.put(InvoiceDraftController(
              customer: _customer, copyInvoice: invoice));
          Get.offAll(InvoiceDraftPage());
        case InvoiceType.supplyInvoice:
        // TODO: Handle this case.
        case InvoiceType.quotation:
          Get.put(
              QuoteDraftController(customer: _customer, copyInvoice: invoice));
          Get.offAll(QuoteDraftPage());
        case InvoiceType.creditNote:
          // TODO: Handle this case.
          Get.put(
              CreditDraftController(customer: _customer, copyInvoice: invoice));
          Get.offAll(const CreditDraftPage());
        case InvoiceType.returnNote:
        // TODO: Handle this case.
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid Value')),
      );
    }
  }
}
