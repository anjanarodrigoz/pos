import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:pos/widgets/pos_button.dart';
import 'package:window_manager/window_manager.dart';

import '../../database/item_db_service.dart';
import '../../models/item.dart';
import '../../theme/t_colors.dart';
import '../../widgets/pos_text_form_field.dart';

class ItemFormPage extends StatefulWidget {
  ItemFormPage({super.key});

  @override
  State<ItemFormPage> createState() => _ItemFormPageState();
}

class _ItemFormPageState extends State<ItemFormPage> {
  final _formKey = GlobalKey<FormState>();

  final dbService = ItemDB();

  final Item _item = Item(id: '', name: '', price: 0.0);

  @override
  Widget build(BuildContext context) {
    WindowOptions windowOptions = const WindowOptions(
        minimumSize: Size(1150, 800), size: Size(1150, 800), center: true);

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
    });
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'New Item',
            style: TStyle.titleBarStyle,
          ),
        ),
        body: Column(
          children: [
            Flexible(
                child: SingleChildScrollView(
                    child: Form(
                        key: _formKey,
                        child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(children: [
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
                                                  '- Item Details -',
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade500),
                                                ),
                                                const SizedBox(
                                                  height: 20.0,
                                                ),
                                                PosTextFormField(
                                                  labelText: 'Item Id',
                                                  onSaved: (value) =>
                                                      _item.id = value!,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter item id';
                                                    }

                                                    return null;
                                                  },
                                                ),
                                                PosTextFormField(
                                                  labelText: 'Item Name',
                                                  onSaved: (value) =>
                                                      _item.name = value!,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter item name';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                PosTextFormField(
                                                  labelText: 'Description',
                                                  onSaved: (value) =>
                                                      _item.description = value,
                                                ),
                                                PosTextFormField(
                                                  labelText: 'Comment',
                                                  onSaved: (value) =>
                                                      _item.comment = value,
                                                ),
                                                // Add more TextFormField widgets for other customer properties
                                                PosTextFormField(
                                                  labelText: 'Price',
                                                  validator: (value) =>
                                                      validatePrice(value),
                                                  onSaved: (value) => _item
                                                          .price =
                                                      value == null
                                                          ? 0.0
                                                          : double.parse(value),
                                                ),
                                                PosTextFormField(
                                                    labelText: 'Price Two',
                                                    onSaved: (value) =>
                                                        _item.priceTwo =
                                                            validateOtherPrice(
                                                                value)),
                                                PosTextFormField(
                                                    labelText: 'Price Three',
                                                    onSaved: (value) =>
                                                        _item.priceThree =
                                                            validateOtherPrice(
                                                                value)),
                                                PosTextFormField(
                                                    labelText: 'Price Four',
                                                    onSaved: (value) =>
                                                        _item.priceFour =
                                                            validateOtherPrice(
                                                                value)),
                                                PosTextFormField(
                                                    labelText: 'Price Five',
                                                    onSaved: (value) {
                                                      _item.priceFive =
                                                          validateOtherPrice(
                                                              value);
                                                    }),

                                                // Add more TextFormField widgets for other customer properties
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ])
                            ]))))),
            PosButton(text: 'Save Item', onPressed: _saveItemDetails)
          ],
        ));
  }

  Future<void> _saveItemDetails() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      bool isAvaliable = await dbService.isItemIdAvaliable(_item.id);
      if (isAvaliable) {
        await dbService.addItem(_item);
        await dbService.saveItemId(_item.id);
        Get.back();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Item details saved')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('This item Id is already exists')),
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
}
