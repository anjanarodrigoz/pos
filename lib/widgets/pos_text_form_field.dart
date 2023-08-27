import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PosTextFormField extends StatelessWidget {
  String? labelText;
  Function(String?)? onSaved;
  String? Function(String?)? validator;
  double width;
  double height;
  bool enable;
  int maxLines;
  List<TextInputFormatter>? inputFormatters;
  String? initialValue;
  Function(String)? onChanged;
  TextInputType? keyboardType;
  TextEditingController? controller;

  PosTextFormField(
      {super.key,
      this.labelText,
      this.onSaved,
      this.height = 50,
      this.inputFormatters,
      this.validator,
      this.maxLines = 1,
      this.onChanged,
      this.keyboardType,
      this.controller,
      this.initialValue,
      this.enable = true,
      this.width = 300});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: SizedBox(
        width: width,
        height: height,
        child: TextFormField(
          keyboardType: keyboardType,
          onChanged: onChanged,
          enabled: enable,
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          initialValue: initialValue,
          controller: controller,
          decoration: InputDecoration(
              labelText: labelText, border: const OutlineInputBorder()),
          onSaved: onSaved,
          validator: validator,
        ),
      ),
    );
  }
}
