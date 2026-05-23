import 'package:flutter/material.dart';


abstract class AppColors {
  static const Color amber = Colors.amber;
  static const Color white = Colors.white;
  static const Color darkGrey = Color(0xFF212121);

  static const List<Color> palette = [
    Color(0xFFF2387C),
    Color(0xFF05C7F2),
    Color(0xFF04D9C4),
    Color(0xFFF2B705),
    Color(0xFFF26241),
    Color(0xFFF25241),
  ];

  static Color getColor(int index) {
    assert(index >= 0 && index < palette.length);
    return palette[index];
  }
}