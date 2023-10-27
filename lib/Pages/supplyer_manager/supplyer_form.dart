import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:pos/database/supplyer_db_service.dart';
import 'package:pos/models/address.dart';
import 'package:pos/theme/t_colors.dart';
import 'package:pos/widgets/pos_button.dart';

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
  final Address deliveryAddress = Address();

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
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 40.0,
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
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Card(
                      elevation: 5.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '- Supplyer Details -',
                                  style: TextStyle(color: Colors.grey.shade500),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                PosTextFormField(
                                  initialValue: _supplyer.firstName,
                                  labelText: 'First Name',
                                  onSaved: (value) =>
                                      _supplyer.firstName = value!,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter first name';
                                    }
                                    return null;
                                  },
                                ),
                                PosTextFormField(
                                  initialValue: _supplyer.lastName,
                                  labelText: 'Last Name',
                                  onSaved: (value) =>
                                      _supplyer.lastName = value!,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter last name';
                                    }
                                    return null;
                                  },
                                ),
                                PosTextFormField(
                                  initialValue: _supplyer.mobileNumber,
                                  labelText: 'Mobile Number',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter mobile number';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) =>
                                      _supplyer.mobileNumber = value!,
                                ),
                                PosTextFormField(
                                  initialValue: _supplyer.email ?? '',
                                  labelText: 'Email',
                                  onSaved: (value) => _supplyer.email = value,
                                ),
                                PosTextFormField(
                                  initialValue: _supplyer.comment ?? '',
                                  height: 100.0,
                                  labelText: 'Commnet',
                                  onSaved: (value) => _supplyer.comment = value,
                                )
                                // Add more TextFormField widgets for other customer properties

                                // Add more TextFormField widgets for other customer properties
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '- Business Details -',
                                  style: TextStyle(color: Colors.grey.shade500),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                PosTextFormField(
                                  initialValue: _supplyer.fax ?? '',
                                  labelText: 'Fax',
                                  onSaved: (value) => _supplyer.fax = value,
                                ),
                                PosTextFormField(
                                  initialValue: _supplyer.web ?? '',
                                  labelText: 'Web',
                                  onSaved: (value) => _supplyer.web = value,
                                ),
                                PosTextFormField(
                                  initialValue: _supplyer.abn ?? '',
                                  labelText: 'ABN',
                                  onSaved: (value) => _supplyer.web = value,
                                ),
                                PosTextFormField(
                                  initialValue: _supplyer.acn ?? '',
                                  labelText: 'ACN',
                                  onSaved: (value) => _supplyer.web = value,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '- Billing Address -',
                                      style: TextStyle(
                                          color: Colors.grey.shade500),
                                    ),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    PosTextFormField(
                                      initialValue:
                                          _supplyer.address?.street ?? '',
                                      labelText: 'Street',
                                      onSaved: (value) =>
                                          deliveryAddress.street = value,
                                    ),
                                    PosTextFormField(
                                      initialValue:
                                          _supplyer.address?.city ?? '',
                                      labelText: 'City',
                                      onSaved: (value) =>
                                          deliveryAddress.city = value,
                                    ),
                                    PosTextFormField(
                                      initialValue:
                                          _supplyer.address?.state ?? '',
                                      labelText: 'State',
                                      onSaved: (value) =>
                                          deliveryAddress.state = value,
                                    ),
                                    PosTextFormField(
                                      initialValue:
                                          _supplyer.address?.areaCode ?? '',
                                      labelText: 'Area Code',
                                      onSaved: (value) =>
                                          deliveryAddress.areaCode = value,
                                    ),
                                    PosTextFormField(
                                      initialValue:
                                          _supplyer.address?.postalCode ?? '',
                                      labelText: 'Postal Code',
                                      onSaved: (value) =>
                                          deliveryAddress.postalCode = value,
                                    ),
                                    PosTextFormField(
                                      initialValue:
                                          _supplyer.address?.county ?? '',
                                      labelText: 'Country',
                                      onSaved: (value) =>
                                          deliveryAddress.county = value,
                                    ),
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
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
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
