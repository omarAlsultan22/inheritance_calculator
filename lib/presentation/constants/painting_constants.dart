import 'package:flutter/material.dart';


abstract class PaintingConstants {
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
    fontSize: 30.0,
  );

  static const TextStyle labelStyle = TextStyle(
    color: Colors.white,
    fontSize: 12.0,
  );
}