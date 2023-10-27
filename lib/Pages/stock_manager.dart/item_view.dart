import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:pos/utils/my_format.dart';
import 'package:pos/widgets/pos_button.dart';
import 'package:pos/widgets/verify_dialog.dart';

import '../../database/item_db_service.dart';
import '../../models/item.dart';
import '../../theme/t_colors.dart';
import '../../widgets/pos_text_form_field.dart';

class ItemViewPage extends StatefulWidget {
  String itemId;
  ItemViewPage({super.key, required this.itemId});

  @override
  State<ItemViewPage> createState() => _ItemViewPageState();
}

class _ItemViewPageState extends State<ItemViewPage> {
  final _formKey = GlobalKey<FormState>();

  final dbService = ItemDB();

  late final Item _item;

  bool isEditMode = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _item = dbService.getItem(widget.itemId)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 40.0,
          title: Text(
            '${_item.name} - # ${_item.id}',
            style: TStyle.titleBarStyle,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Form(
                    key: _formKey,
                    child: Column(children: [
                      Card(
                        elevation: 5.0,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      PosTextFormField(
                                        enable: isEditMode,
                                        labelText: 'Item Name',
                                        initialValue: _item.name,
                                        onSaved: (value) => _item.name = value!,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter item name';
                                          }
                                          return null;
                                        },
                                      ),
                                      PosTextFormField(
                                        enable: isEditMode,
                                        initialValue: _item.description,
                                        labelText: 'Description',
                                        onSaved: (value) =>
                                            _item.description = value,
                                      ),
                                      PosTextFormField(
                                        enable: isEditMode,
                                        initialValue: _item.comment,
                                        labelText: 'Comment',
                                        onSaved: (value) =>
                                            _item.comment = value,
                                      ),
                                      // Add more TextFormField widgets for other customer properties

                                      // Add more TextFormField widgets for other customer properties
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      PosTextFormField(
                                        enable: isEditMode,
                                        initialValue:
                                            MyFormat.formatPrice(_item.price),
                                        labelText: 'Price',
                                        validator: (value) =>
                                            validatePrice(value),
                                        onSaved: (value) => _item.price =
                                            value == null
                                                ? 0.0
                                                : double.parse(value),
                                      ),
                                      PosTextFormField(
                                          enable: isEditMode,
                                          initialValue: MyFormat.formatPrice(
                                              _item.priceTwo),
                                          labelText: 'Price Two',
                                          onSaved: (value) => _item.priceTwo =
                                              validateOtherPrice(value)),
                                      PosTextFormField(
                                          enable: isEditMode,
                                          initialValue: MyFormat.formatPrice(
                                              _item.priceThree),
                                          labelText: 'Price Three',
                                          onSaved: (value) => _item.priceThree =
                                              validateOtherPrice(value)),
                                      PosTextFormField(
                                          enable: isEditMode,
                                          initialValue: MyFormat.formatPrice(
                                              _item.priceFour),
                                          labelText: 'Price Four',
                                          onSaved: (value) => _item.priceFour =
                                              validateOtherPrice(value)),
                                      PosTextFormField(
                                          enable: isEditMode,
                                          initialValue: MyFormat.formatPrice(
                                              _item.priceFive),
                                          labelText: 'Price Five',
                                          onSaved: (value) {
                                            _item.priceFive =
                                                validateOtherPrice(value);
                                          }),
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                      )
                    ])),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PosButton(
                      color: Colors.red.shade900,
                      text: 'Remove Item',
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => POSVerifyDialog(
                                title: 'Delete Item',
                                content: 'Do you want to delete this item?',
                                onContinue: () async {
                                  await dbService.deleteItem(_item.id);
                                  Get.back();
                                },
                                verifyText: _item.id,
                                continueText: 'delete'));
                      }),
                  PosButton(
                      enable: !isEditMode,
                      text: 'Edit Item',
                      onPressed: () {
                        setState(() {
                          isEditMode = true;
                        });
                      }),
                  PosButton(
                      enable: isEditMode,
                      text: 'Update Item',
                      onPressed: _saveItemDetails),
                ],
              ),
            ],
          ),
        ));
  }

  Future<void> _saveItemDetails() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await dbService.updateItem(_item);
      isEditMode = false;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Item details saved')),
      );
    }
  }
}

String? validatePrice(value) {
  if (value == null) {
    return 'invalid value';
  }
  final s = double.tryParse(value);
  if (value.isEmpty) {
    return 'enter value';
  }
  if (s == null) {
    return 'invalid value';
  }

  // You can add additional validation rules for name if needed
  return null;
}

double validateOtherPrice(String? value) {
  if (value != null) {
    if (value.isNotEmpty) {
      final price = double.tryParse(value);
      if (price != null) {
        return double.parse(value);
      }
    }
  }
  return 0.00;
}
