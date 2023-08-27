import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:pos/database/customer_db_service.dart';
import 'package:pos/theme/t_colors.dart';
import 'package:window_manager/window_manager.dart';

import '../../models/address.dart';
import '../../models/customer.dart';
import '../../widgets/pos_button.dart';
import '../../widgets/pos_text_form_field.dart';

class CustomerViewPage extends StatefulWidget {
  String cusId;
  CustomerViewPage({super.key, required this.cusId});

  @override
  State<CustomerViewPage> createState() => _CustomerViewPageState();
}

class _CustomerViewPageState extends State<CustomerViewPage> {
  late Customer _customer;
  final _formKey = GlobalKey<FormState>();
  final Address deliveryAddress = Address();
  final Address postalAddress = Address();
  final dbService = CustomerDB();
  bool isEditMode = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _customer = dbService.getCustomer(widget.cusId);
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
        backgroundColor: TColors.blue,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_outlined)),
        title: Text(
          '${_customer.firstName} ${_customer.lastName} - #${_customer.id}',
          style: TStyle.titleBarStyle,
        ),
      ),
      body: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.0,
              ),
              PosButton(
                  width: 180.0,
                  height: 45.0,
                  enable: !isEditMode,
                  onPressed: () {
                    setState(() {
                      isEditMode = true;
                    });
                  },
                  text: 'Edit'),
              SizedBox(
                height: 8.0,
              ),
              PosButton(
                  enable: isEditMode,
                  width: 180.0,
                  height: 45.0,
                  onPressed: _updateCustomerDetails,
                  text: 'Update'),
              SizedBox(
                height: 50.0,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: PosButton(
                    width: 180.0,
                    height: 45.0,
                    color: Colors.red.shade900,
                    onPressed: _deleteCustomer,
                    text: 'Delete'),
              ),
            ],
          ),
          Container(
            color: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '- Customer Details -',
                                              style: TextStyle(
                                                  color: Colors.grey.shade500),
                                            ),
                                            const SizedBox(
                                              height: 20.0,
                                            ),
                                            PosTextFormField(
                                              enable: isEditMode,
                                              initialValue: _customer.firstName,
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
                                              enable: isEditMode,
                                              initialValue: _customer.lastName,
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
                                              enable: isEditMode,
                                              initialValue:
                                                  _customer.mobileNumber,
                                              labelText: 'Mobile Number',
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter mobile number';
                                                }
                                                return null;
                                              },
                                              onSaved: (value) => _customer
                                                  .mobileNumber = value!,
                                            ),
                                            // Add more TextFormField widgets for other customer properties
                                            PosTextFormField(
                                              enable: isEditMode,
                                              initialValue: _customer.fax ?? '',
                                              labelText: 'Fax',
                                              onSaved: (value) =>
                                                  _customer.fax = value,
                                            ),
                                            PosTextFormField(
                                              enable: isEditMode,
                                              initialValue: _customer.web ?? '',
                                              labelText: 'Web',
                                              onSaved: (value) =>
                                                  _customer.web = value,
                                            ),
                                            PosTextFormField(
                                              enable: isEditMode,
                                              initialValue:
                                                  _customer.email ?? '',
                                              labelText: 'Email',
                                              onSaved: (value) =>
                                                  _customer.email = value,
                                            ),
                                            PosTextFormField(
                                              enable: isEditMode,
                                              initialValue: _customer.abn ?? '',
                                              labelText: 'ABN',
                                              onSaved: (value) =>
                                                  _customer.web = value,
                                            ),
                                            PosTextFormField(
                                              enable: isEditMode,
                                              initialValue: _customer.acn ?? '',
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
                                                      color:
                                                          Colors.grey.shade500),
                                                ),
                                                const SizedBox(
                                                  height: 20.0,
                                                ),
                                                PosTextFormField(
                                                  enable: isEditMode,
                                                  initialValue: _customer
                                                          .deliveryAddress
                                                          ?.street ??
                                                      '',
                                                  labelText: 'Street',
                                                  onSaved: (value) =>
                                                      deliveryAddress.street =
                                                          value,
                                                ),
                                                PosTextFormField(
                                                  enable: isEditMode,
                                                  initialValue: _customer
                                                          .deliveryAddress
                                                          ?.city ??
                                                      '',
                                                  labelText: 'City',
                                                  onSaved: (value) =>
                                                      deliveryAddress.city =
                                                          value,
                                                ),
                                                PosTextFormField(
                                                  enable: isEditMode,
                                                  initialValue: _customer
                                                          .deliveryAddress
                                                          ?.state ??
                                                      '',
                                                  labelText: 'State',
                                                  onSaved: (value) =>
                                                      deliveryAddress.state =
                                                          value,
                                                ),
                                                PosTextFormField(
                                                  enable: isEditMode,
                                                  initialValue: _customer
                                                          .deliveryAddress
                                                          ?.areaCode ??
                                                      '',
                                                  labelText: 'Area Code',
                                                  onSaved: (value) =>
                                                      deliveryAddress.areaCode =
                                                          value,
                                                ),
                                                PosTextFormField(
                                                  enable: isEditMode,
                                                  initialValue: _customer
                                                          .deliveryAddress
                                                          ?.postalCode ??
                                                      '',
                                                  labelText: 'Postal Code',
                                                  onSaved: (value) =>
                                                      deliveryAddress
                                                          .postalCode = value,
                                                ),
                                                PosTextFormField(
                                                  enable: isEditMode,
                                                  initialValue: _customer
                                                          .deliveryAddress
                                                          ?.county ??
                                                      '',
                                                  labelText: 'Country',
                                                  onSaved: (value) =>
                                                      deliveryAddress.county =
                                                          value,
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
                                                      color:
                                                          Colors.grey.shade500),
                                                ),
                                                const SizedBox(
                                                  height: 20.0,
                                                ),
                                                PosTextFormField(
                                                  enable: isEditMode,
                                                  initialValue: _customer
                                                          .postalAddress
                                                          ?.street ??
                                                      '',
                                                  labelText: 'Street',
                                                  onSaved: (value) =>
                                                      postalAddress.street =
                                                          value,
                                                ),
                                                PosTextFormField(
                                                  enable: isEditMode,
                                                  initialValue: _customer
                                                          .postalAddress
                                                          ?.city ??
                                                      '',
                                                  labelText: 'City',
                                                  onSaved: (value) =>
                                                      postalAddress.city =
                                                          value,
                                                ),
                                                PosTextFormField(
                                                  enable: isEditMode,
                                                  initialValue: _customer
                                                          .postalAddress
                                                          ?.state ??
                                                      '',
                                                  labelText: 'State',
                                                  onSaved: (value) =>
                                                      postalAddress.state =
                                                          value,
                                                ),
                                                PosTextFormField(
                                                  enable: isEditMode,
                                                  initialValue: _customer
                                                          .postalAddress
                                                          ?.areaCode ??
                                                      '',
                                                  labelText: 'Area Code',
                                                  onSaved: (value) =>
                                                      postalAddress.areaCode =
                                                          value,
                                                ),
                                                PosTextFormField(
                                                  enable: isEditMode,
                                                  initialValue: _customer
                                                          .postalAddress
                                                          ?.postalCode ??
                                                      '',
                                                  labelText: 'Postal Code',
                                                  onSaved: (value) =>
                                                      postalAddress.postalCode =
                                                          value,
                                                ),
                                                PosTextFormField(
                                                  enable: isEditMode,
                                                  initialValue: _customer
                                                          .postalAddress
                                                          ?.county ??
                                                      '',
                                                  labelText: 'Country',
                                                  onSaved: (value) =>
                                                      postalAddress.county =
                                                          value,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '- Add customer comment -',
                                              style: TextStyle(
                                                  color: Colors.grey.shade500),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: PosTextFormField(
                                                enable: isEditMode,
                                                initialValue:
                                                    _customer.comment ?? '',
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateCustomerDetails() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      _customer.deliveryAddress = deliveryAddress;
      _customer.postalAddress = postalAddress;
      await dbService.updateCustomer(_customer);
      isEditMode = false;

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Customer details updated')),
      );
    }
  }

  Future<void> _deleteCustomer() async {
    await dbService.deleteCustomer(_customer.id);
    Get.back();
  }
}
