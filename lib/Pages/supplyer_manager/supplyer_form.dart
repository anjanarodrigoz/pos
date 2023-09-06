import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:pos/database/supplyer_db_service.dart';
import 'package:pos/models/address.dart';
import 'package:pos/theme/t_colors.dart';
import 'package:pos/widgets/pos_button.dart';
import 'package:window_manager/window_manager.dart';

import '../../database/supplyer_db_service.dart';
import '../../models/supplyer.dart';
import '../../models/supplyer.dart';
import '../../widgets/pos_text_form_field.dart';

class SupplyerFormPage extends StatefulWidget {
  const SupplyerFormPage({super.key});

  @override
  _SupplyerFormPageState createState() => _SupplyerFormPageState();
}

class _SupplyerFormPageState extends State<SupplyerFormPage> {
  final _formKey = GlobalKey<FormState>();
  final supplyerDb = SupplyerDB();
  final Supplyer _supplyer = Supplyer(
      id: SupplyerDB.generateSupplyerId(),
      firstName: '',
      lastName: '',
      mobileNumber: '');
  final Address address = Address();
  final Address postalAddress = Address();

  Future<void> _saveSupplyerDetails() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      _supplyer.address = address;
      await supplyerDb.addSupplyer(_supplyer);
      await supplyerDb.saveLastId(_supplyer.id);
      Get.back();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Supplyer details saved')),
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
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_outlined),
          ),
          backgroundColor: TColors.blue,
          title: Text(
            'New Supplyer - # ${_supplyer.id}',
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
                                          '- Supplyer Details -',
                                          style: TextStyle(
                                              color: Colors.grey.shade500),
                                        ),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        PosTextFormField(
                                          labelText: 'First Name',
                                          onSaved: (value) =>
                                              _supplyer.firstName = value!,
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
                                              _supplyer.lastName = value!,
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
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter mobile number';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) =>
                                              _supplyer.mobileNumber = value!,
                                        ),
                                        // Add more TextFormField widgets for other supplyer properties
                                        PosTextFormField(
                                          labelText: 'Fax',
                                          onSaved: (value) =>
                                              _supplyer.fax = value,
                                        ),
                                        PosTextFormField(
                                          labelText: 'Web',
                                          onSaved: (value) =>
                                              _supplyer.web = value,
                                        ),
                                        PosTextFormField(
                                          labelText: 'Email',
                                          onSaved: (value) =>
                                              _supplyer.email = value,
                                        ),
                                        PosTextFormField(
                                          labelText: 'ABN',
                                          onSaved: (value) =>
                                              _supplyer.web = value,
                                        ),
                                        PosTextFormField(
                                          labelText: 'ACN',
                                          onSaved: (value) =>
                                              _supplyer.web = value,
                                        ),

                                        // Add more TextFormField widgets for other supplyer properties
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
                                              '- Address -',
                                              style: TextStyle(
                                                  color: Colors.grey.shade500),
                                            ),
                                            SizedBox(
                                              height: 20.0,
                                            ),
                                            PosTextFormField(
                                              labelText: 'Street',
                                              onSaved: (value) =>
                                                  address.street = value,
                                            ),
                                            PosTextFormField(
                                              labelText: 'City',
                                              onSaved: (value) =>
                                                  address.city = value,
                                            ),
                                            PosTextFormField(
                                              labelText: 'State',
                                              onSaved: (value) =>
                                                  address.state = value,
                                            ),
                                            PosTextFormField(
                                              labelText: 'Area Code',
                                              onSaved: (value) =>
                                                  address.areaCode = value,
                                            ),
                                            PosTextFormField(
                                              labelText: 'Postal Code',
                                              onSaved: (value) =>
                                                  address.postalCode = value,
                                            ),
                                            PosTextFormField(
                                              labelText: 'Country',
                                              onSaved: (value) =>
                                                  address.county = value,
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
                                          '- Add supplyer comment -',
                                          style: TextStyle(
                                              color: Colors.grey.shade500),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: PosTextFormField(
                                            width: 650.0,
                                            labelText: 'Commnet',
                                            onSaved: (value) =>
                                                _supplyer.comment = value,
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
                  onPressed: _saveSupplyerDetails,
                  text: 'Save New Supplyer'),
            ),
          ],
        ),
      ),
    );
  }
}
