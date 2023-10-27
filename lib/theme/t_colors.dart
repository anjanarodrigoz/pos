import 'dart:ui';

import 'package:flutter/material.dart';

class TColors {
  static const Color blue = const Color(0xff094E8C);
  static Color blue1 = const Color(0xff2B55EA);
  static Color blue2 = const Color(0xffB5C9FD);
  static Color green = const Color(0xff0E820C);

  static Color green2 = const Color(0xffC6FFCF);

  static Color grey = const Color(0xffB5B5B5);
}

class TStyle {
  static TextStyle style_01 =
      const TextStyle(fontSize: 13.0, color: Colors.black);
  static TextStyle style_02 = TextStyle(
      fontSize: 12.0, color: TColors.blue, fontWeight: FontWeight.w500);
  static TextStyle style_03 =
      TextStyle(fontSize: 12.0, color: Colors.red, fontWeight: FontWeight.w500);

  static TextStyle titleBarStyle = const TextStyle(
      fontSize: 17.0, color: Colors.white, fontWeight: FontWeight.w500);
}
