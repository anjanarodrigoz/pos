import 'package:flutter/material.dart';

import '../theme/t_colors.dart';

class PosButton extends StatelessWidget {
  Function()? onPressed;
  String text;
  double width;
  double height;
  bool enable;
  Color? color;
  IconData? icon;
  Color? iconColor;
  double iconSize;

  PosButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.enable = true,
      this.color,
      this.icon,
      this.iconColor,
      this.iconSize = 25,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(
                icon,
                color: iconColor,
                size: iconSize,
              ),
            if (icon != null)
              const SizedBox(
                width: 10.0,
              ),
            Text(text),
          ],
        ),
      ),
    );
  }
}
