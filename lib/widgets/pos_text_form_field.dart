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
  Function()? onTap;
  TextInputType? keyboardType;
  TextEditingController? controller;
  Widget? suffixIcon;
  Widget? prefixIcon;
  String? hintText;
  String? errorText;

  PosTextFormField(
      {super.key,
      this.labelText,
      this.onTap,
      this.onSaved,
      this.height = 50,
      this.inputFormatters,
      this.validator,
      this.maxLines = 1,
      this.onChanged,
      this.keyboardType,
      this.controller,
      this.suffixIcon,
      this.initialValue,
      this.hintText,
      this.prefixIcon,
      this.errorText,
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
          onTap: onTap ??
              (controller != null
                  ? () => controller?.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: controller!.value.text.length)
                  : null),
          keyboardType: keyboardType,
          onChanged: onChanged,
          enabled: enable,
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          initialValue: initialValue,
          controller: controller,
          decoration: InputDecoration(
              prefixIcon: prefixIcon,
              hintText: hintText,
              suffixIcon: suffixIcon,
              labelText: labelText,
              errorText: errorText,
              border: const OutlineInputBorder()),
          onSaved: onSaved,
          validator: validator,
        ),
      ),
    );
  }
}
