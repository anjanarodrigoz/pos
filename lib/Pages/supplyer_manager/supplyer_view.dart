import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:pos/database/customer_db_service.dart';
import 'package:pos/theme/t_colors.dart';
import 'package:pos/widgets/verify_dialog.dart';

import '../../database/supplyer_db_service.dart';
import '../../models/address.dart';
import '../../models/customer.dart';
import '../../models/supplyer.dart';
import '../../widgets/pos_button.dart';
import '../../widgets/pos_text_form_field.dart';

class SupplyerViewPage extends StatefulWidget {
  final String supplyId;
  SupplyerViewPage({super.key, required this.supplyId});

  @override
  State<SupplyerViewPage> createState() => _SupplyerViewPageState();
}

class _SupplyerViewPageState extends State<SupplyerViewPage> {
  late Supplyer _supplyer;
  final _formKey = GlobalKey<FormState>();
  final Address deliveryAddress = Address();
  final Address postalAddress = Address();
  final dbService = SupplyerDB();
  bool isEditMode = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _supplyer = dbService.getSupplyer(widget.supplyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40.0,
        backgroundColor: TColors.blue,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_outlined)),
        title: Text(
          '${_supplyer.firstName} ${_supplyer.lastName} - #${_supplyer.id}',
          style: TStyle.titleBarStyle,
        ),
      ),
      body: Column(
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
                                enable: isEditMode,
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
                                enable: isEditMode,
                                initialValue: _supplyer.lastName,
                                labelText: 'Last Name',
                                onSaved: (value) => _supplyer.lastName = value!,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter last name';
                                  }
                                  return null;
                                },
                              ),
                              PosTextFormField(
                                enable: isEditMode,
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
                                enable: isEditMode,
                                initialValue: _supplyer.email ?? '',
                                labelText: 'Email',
                                onSaved: (value) => _supplyer.email = value,
                              ),
                              PosTextFormField(
                                enable: isEditMode,
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
                                enable: isEditMode,
                                initialValue: _supplyer.fax ?? '',
                                labelText: 'Fax',
                                onSaved: (value) => _supplyer.fax = value,
                              ),
                              PosTextFormField(
                                enable: isEditMode,
                                initialValue: _supplyer.web ?? '',
                                labelText: 'Web',
                                onSaved: (value) => _supplyer.web = value,
                              ),
                              PosTextFormField(
                                enable: isEditMode,
                                initialValue: _supplyer.abn ?? '',
                                labelText: 'ABN',
                                onSaved: (value) => _supplyer.web = value,
                              ),
                              PosTextFormField(
                                enable: isEditMode,
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
                                    style:
                                        TextStyle(color: Colors.grey.shade500),
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  PosTextFormField(
                                    enable: isEditMode,
                                    initialValue:
                                        _supplyer.address?.street ?? '',
                                    labelText: 'Street',
                                    onSaved: (value) =>
                                        deliveryAddress.street = value,
                                  ),
                                  PosTextFormField(
                                    enable: isEditMode,
                                    initialValue: _supplyer.address?.city ?? '',
                                    labelText: 'City',
                                    onSaved: (value) =>
                                        deliveryAddress.city = value,
                                  ),
                                  PosTextFormField(
                                    enable: isEditMode,
                                    initialValue:
                                        _supplyer.address?.state ?? '',
                                    labelText: 'State',
                                    onSaved: (value) =>
                                        deliveryAddress.state = value,
                                  ),
                                  PosTextFormField(
                                    enable: isEditMode,
                                    initialValue:
                                        _supplyer.address?.areaCode ?? '',
                                    labelText: 'Area Code',
                                    onSaved: (value) =>
                                        deliveryAddress.areaCode = value,
                                  ),
                                  PosTextFormField(
                                    enable: isEditMode,
                                    initialValue:
                                        _supplyer.address?.postalCode ?? '',
                                    labelText: 'Postal Code',
                                    onSaved: (value) =>
                                        deliveryAddress.postalCode = value,
                                  ),
                                  PosTextFormField(
                                    enable: isEditMode,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PosButton(
                    enable: !isEditMode,
                    onPressed: () {
                      setState(() {
                        isEditMode = true;
                      });
                    },
                    text: 'Edit'),
                PosButton(
                    enable: isEditMode,
                    onPressed: _updateSupplyerDetails,
                    text: 'Update'),
                PosButton(
                    color: Colors.red.shade900,
                    onPressed: _deleteSupplyer,
                    text: 'Delete'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateSupplyerDetails() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      _supplyer.address = deliveryAddress;
      await dbService.updateSupplyer(_supplyer);
      isEditMode = false;

      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Supplyer details updated')),
      );
    }
  }

  Future<void> _deleteSupplyer() async {
    showDialog(
        context: context,
        builder: (context) => POSVerifyDialog(
            title: 'Delete Supplyer',
            content: 'Do you want to delete this supplyer',
            onContinue: () async {
              await dbService.deleteSupplyer(_supplyer.id);
              Get.back();
            },
            verifyText: _supplyer.id,
            continueText: 'delete'));
  }
}
