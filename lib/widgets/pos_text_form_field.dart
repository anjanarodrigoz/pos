import 'package:flutter/material.dart';

class PosTextFormField extends StatelessWidget {
  String? labelText;
  Function(String?)? onSaved;
  String? Function(String?)? validator;
  double width;

  PosTextFormField(
      {super.key,
      this.labelText,
      this.onSaved,
      this.validator,
      this.width = 300});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: SizedBox(
        width: width,
        child: TextFormField(
          decoration: InputDecoration(
              labelText: labelText, border: OutlineInputBorder()),
          onSaved: onSaved,
          validator: validator,
        ),
      ),
    );
  }
}
