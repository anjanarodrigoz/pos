import 'package:flutter/material.dart';
import 'package:pos/theme/t_colors.dart';

class RoundedIconButton extends StatelessWidget {
  final IconData icon;
  final Function onPressed;
  final Color iconColor;
  final Color backgroundColor;

  const RoundedIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor = TColors.blue,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.0),
        ),
        elevation: 4.0,
        child: InkWell(
          borderRadius: BorderRadius.circular(100.0),
          onTap: () {
            onPressed();
          },
          child: Container(
            padding: EdgeInsets.all(12.0),
            child: Icon(
              icon,
              size: 15.0,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
