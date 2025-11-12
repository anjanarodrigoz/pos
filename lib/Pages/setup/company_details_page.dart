import 'package:flutter/material.dart';
import 'package:pos/database/store_db.dart';
import 'package:pos/models/store.dart';
import 'package:pos/utils/alert_message.dart';
import 'package:pos/widgets/rounded_icon_button.dart';

import '../../widgets/pos_text_form_field.dart';

class CompanyDetailsPage extends StatefulWidget {
  const CompanyDetailsPage({super.key});

  @override
  State<CompanyDetailsPage> createState() => _CompanyDetailsPageState();
}

class _CompanyDetailsPageState extends State<CompanyDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  Store store = Store(
      companyName: '',
      abn: '',
      street: '',
      city: '',
      state: '',
      postalcode: '',
      mobileNumber1: '',
      email: '',
      email2: '',
      smtpServer: '');

  @override
  void initState() {
    super.initState();
    store = StoreDB().getStore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: RoundedIconButton(
          backgroundColor: Colors.green,
          icon: Icons.save,
          onPressed: () => saveData()),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(children: [
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Text('Details'),
                              const SizedBox(
                                height: 10.0,
                              ),
                              PosTextFormField(
                                initialValue: store.companyName,
                                onSaved: (value) => store.companyName = value!,
                                labelText: 'Company Name',
                              ),
                              PosTextFormField(
                                initialValue: store.slogan,
                                onSaved: (value) => store.slogan = value!,
                                labelText: 'Slogan',
                              ),
                              PosTextFormField(
                                initialValue: store.abn,
                                onSaved: (value) => store.abn = value!,
                                labelText: 'ABN',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Text('Contacts'),
                              const SizedBox(
                                height: 10.0,
                              ),
                              PosTextFormField(
                                onSaved: (value) =>
                                    store.mobileNumber1 = value!,
                                labelText: 'Mobile number',
                                initialValue: store.mobileNumber1,
                              ),
                              PosTextFormField(
                                onSaved: (value) => store.email = value!,
                                labelText: 'Email',
                                initialValue: store.email,
                              ),
                              // PosTextFormField(
                              //   onSaved: (value) => store.fax = value!,
                              //   labelText: 'Fax',
                              //   initialValue: store.fax,
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Text('Address'),
                            const SizedBox(
                              height: 10.0,
                            ),
                            PosTextFormField(
                              initialValue: store.street,
                              onSaved: (value) => store.street = value!,
                              labelText: 'Street',
                            ),
                            PosTextFormField(
                              onSaved: (value) => store.city = value!,
                              labelText: 'City',
                              initialValue: store.city,
                            ),
                            PosTextFormField(
                              onSaved: (value) => store.state = value!,
                              labelText: 'State',
                              initialValue: store.state,
                            ),
                            PosTextFormField(
                              onSaved: (value) => store.postalcode = value!,
                              labelText: 'Postal Code',
                              initialValue: store.postalcode,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveData() async {
    _formKey.currentState!.save();

    await StoreDB().addStore(store);

    if (context.mounted) AlertMessage.snakMessage('details saved', context);
  }
}
