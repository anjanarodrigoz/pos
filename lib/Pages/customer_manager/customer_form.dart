import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pos/Pages/main_window.dart';
import 'package:pos/database/customer_db_service.dart';
import 'package:pos/models/address.dart';
import 'package:pos/theme/t_colors.dart';
import 'package:pos/widgets/pos_button.dart';
import 'package:window_manager/window_manager.dart';

import '../../models/customer.dart';
import '../../widgets/pos_text_form_field.dart';

class CustomerFormPage extends StatefulWidget {
  const CustomerFormPage({super.key});

  @override
  _CustomerFormPageState createState() => _CustomerFormPageState();
}

class _CustomerFormPageState extends State<CustomerFormPage> {
  final _formKey = GlobalKey<FormState>();
  final customerDb = CustomerDB();
  final Customer _customer =
      Customer(id: Customer.generateCustomerId(), firstName: '', lastName: '');
  final Address _deliverAddress = Address();
  final Address _postalAddress = Address();

  Future<void> _saveCustomerDetails() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      _customer.copyWith(
          deliveryAddress: _deliverAddress, postalAddress: _postalAddress);

      await customerDb.addCustomer(_customer);
      await Customer.saveLastId(_customer.id);
      Get.offAll(const MainWindow());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Customer details saved')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    WindowOptions windowOptions = const WindowOptions(
        minimumSize: Size(1150, 800), size: Size(1150, 800), center: true);

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
    });

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.offAll(const MainWindow());
            },
            icon: const Icon(Icons.arrow_back_outlined),
          ),
          backgroundColor: TColors.blue,
          title: Text(
            'New Customer - # ${_customer.id}',
            style: TextStyle(fontSize: 17.0),
          )),
      body: Container(
        color: Colors.grey.shade200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '- Customer Details -',
                                          style: TextStyle(
                                              color: Colors.grey.shade500),
                                        ),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        PosTextFormField(
                                          labelText: 'First Name',
                                          onSaved: (value) =>
                                              _customer.firstName = value!,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter first name';
                                            }
                                            return null;
                                          },
                                        ),
                                        PosTextFormField(
                                          labelText: 'Last Name',
                                          onSaved: (value) =>
                                              _customer.lastName = value!,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter last name';
                                            }
                                            return null;
                                          },
                                        ),
                                        PosTextFormField(
                                          labelText: 'Mobile Number',
                                          onSaved: (value) =>
                                              _customer.mobileNumber = value,
                                        ),
                                        // Add more TextFormField widgets for other customer properties
                                        PosTextFormField(
                                          labelText: 'Fax',
                                          onSaved: (value) =>
                                              _customer.fax = value,
                                        ),
                                        PosTextFormField(
                                          labelText: 'Web',
                                          onSaved: (value) =>
                                              _customer.web = value,
                                        ),
                                        PosTextFormField(
                                          labelText: 'Email',
                                          onSaved: (value) =>
                                              _customer.email = value,
                                        ),
                                        PosTextFormField(
                                          labelText: 'ABN',
                                          onSaved: (value) =>
                                              _customer.web = value,
                                        ),
                                        PosTextFormField(
                                          labelText: 'ACN',
                                          onSaved: (value) =>
                                              _customer.web = value,
                                        ),

                                        // Add more TextFormField widgets for other customer properties
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
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
                                            SizedBox(
                                              height: 20.0,
                                            ),
                                            PosTextFormField(
                                              labelText: 'Street',
                                              onSaved: (value) =>
                                                  _deliverAddress.street =
                                                      value,
                                            ),
                                            PosTextFormField(
                                              labelText: 'City',
                                              onSaved: (value) =>
                                                  _deliverAddress.city = value,
                                            ),
                                            PosTextFormField(
                                              labelText: 'State',
                                              onSaved: (value) =>
                                                  _deliverAddress.state = value,
                                            ),
                                            PosTextFormField(
                                              labelText: 'Area Code',
                                              onSaved: (value) =>
                                                  _deliverAddress.areaCode =
                                                      value,
                                            ),
                                            PosTextFormField(
                                              labelText: 'Postal Code',
                                              onSaved: (value) =>
                                                  _deliverAddress.postalCode =
                                                      value,
                                            ),
                                            PosTextFormField(
                                              labelText: 'Country',
                                              onSaved: (value) =>
                                                  _deliverAddress.county =
                                                      value,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
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
                                            SizedBox(
                                              height: 20.0,
                                            ),
                                            PosTextFormField(
                                              labelText: 'Street',
                                              onSaved: (value) =>
                                                  _postalAddress.street = value,
                                            ),
                                            PosTextFormField(
                                              labelText: 'City',
                                              onSaved: (value) =>
                                                  _postalAddress.city = value,
                                            ),
                                            PosTextFormField(
                                              labelText: 'State',
                                              onSaved: (value) =>
                                                  _postalAddress.state = value,
                                            ),
                                            PosTextFormField(
                                              labelText: 'Area Code',
                                              onSaved: (value) => _postalAddress
                                                  .areaCode = value,
                                            ),
                                            PosTextFormField(
                                              labelText: 'Postal Code',
                                              onSaved: (value) => _postalAddress
                                                  .postalCode = value,
                                            ),
                                            PosTextFormField(
                                              labelText: 'Country',
                                              onSaved: (value) =>
                                                  _postalAddress.county = value,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '- Add customer comment -',
                                          style: TextStyle(
                                              color: Colors.grey.shade500),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: PosTextFormField(
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: PosButton(
                  width: 200.0,
                  onPressed: _saveCustomerDetails,
                  text: 'Save New Customer'),
            ),
          ],
        ),
      ),
    );
  }
}
