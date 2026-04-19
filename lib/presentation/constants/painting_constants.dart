import 'package:flutter/material.dart';
import 'package:men/core/constants/numbers/decimal_numbers.dart';


mixin PaintingConstants {
  // Paints
  static const _fontSize12 = DecimalNumbersConstants.twelve;
  static const _fontSize30 = DecimalNumbersConstants.thirty;

  static final Paint linePaint = Paint()
    ..color = Colors.white
    ..strokeWidth = 2.0
    ..style = PaintingStyle.stroke;

  static final Paint midPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill;

  // Text Styles
  static const TextStyle textFieldTextBigStyle = TextStyle(
    color: Colors.black38,
    fontWeight: FontWeight.bold,
    fontSize: _fontSize30,
  );

  static const TextStyle labelStyle = TextStyle(
    color: Colors.white,
    fontSize: _fontSize12,
  );
}