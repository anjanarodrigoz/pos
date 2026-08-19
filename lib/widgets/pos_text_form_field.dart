import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PosTextFormField extends StatelessWidget {
  final String? labelText;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final double width;
  final double height;
  final bool enable;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;
  final Function(String)? onChanged;
  final Function()? onTap;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? hintText;
  final String? errorText;
  final bool obscureText;

  const PosTextFormField({
    super.key,
    this.labelText,
    this.onTap,
    this.onSaved,
    this.obscureText = false,
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
    this.width = 300,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: SizedBox(
        width: width,
        height: height,
        child: TextFormField(
          obscureText: obscureText,
          onTap: onTap,
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
