import 'package:flutter/material.dart';

import '../theme/t_colors.dart';

class PosButton extends StatelessWidget {
  Function()? onPressed;
  String text;
  double width;
  double height;
  bool enable;
  Color? color;

  PosButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.enable = true,
      this.color,
      this.width = 180.0,
      this.height = 50.0});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ElevatedButton(
        onPressed: enable ? onPressed : null,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(width, height),
          backgroundColor: color ?? TColors.blue,
        ),
        child: Text(text),
      ),
    );
  }
}
