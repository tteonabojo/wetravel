import 'package:flutter/material.dart';

class AppShadow {
  static const Color shadowColor = Color(0xFFBBBFC3);

  // General Shadow
  static List<BoxShadow> generalShadow = [
    BoxShadow(
      color: shadowColor.withOpacity(0.12),
      blurRadius: 4.0,
      spreadRadius: 0,
      offset: Offset(0, 0),
    ),
    BoxShadow(
      color: shadowColor.withOpacity(0.15),
      blurRadius: 20.0,
      spreadRadius: 0,
      offset: Offset(4, 4),
    ),
  ];

  // Time Picker Shadow
  static List<BoxShadow> timePickerShadow = [
    BoxShadow(
      color: shadowColor.withOpacity(0.2),
      blurRadius: 4.0,
      spreadRadius: 0,
      offset: Offset(0, 0),
    ),
    BoxShadow(
      color: shadowColor.withOpacity(0.3),
      blurRadius: 50.0,
      spreadRadius: 0,
      offset: Offset(4, 4),
    ),
  ];
}
