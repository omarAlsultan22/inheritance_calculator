import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../data/models/data_model.dart';
import 'package:men/core/constants/numbers/decimal_numbers.dart';
import 'package:men/core/constants/numbers/natural_numbers_constants.dart';


// Donut Chart Painter
class DonutChartPainter extends CustomPainter {
  final List<ItemModel> dataset;
  final double fullAngle;

  DonutChartPainter(this.dataset, this.fullAngle);

  static const tow = 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    const zero = DecimalNumbersConstants.zero;
    const oneHundredEighty = 180.0;

    final c = Offset(size.width / tow, size.height / tow);
    final radius = size.width * 0.9;
    final rect = Rect.fromCenter(center: c, width: radius, height: radius);
    double startAngle = zero;

    // Draw background circle
    canvas.drawArc(
        rect, startAngle, fullAngle * pi / oneHundredEighty, false, linePaint);

    // Draw sectors
    for (var di in dataset) {
      double sweepAngle = di.amount * fullAngle * pi / oneHundredEighty;
      drawSectors(canvas, di, rect, startAngle, sweepAngle);
      startAngle += sweepAngle;
    }

    // Draw lines and labels
    startAngle = zero;
    for (var di in dataset) {
      double sweepAngle = di.amount * fullAngle * pi / oneHundredEighty;
      drawLine(canvas, c, radius, startAngle);
      drawLabel(canvas, c, radius, startAngle, sweepAngle, di);
      startAngle += sweepAngle;
    }

    // Draw center circle
    canvas.drawCircle(c, radius * 0.3, midPaint);

    // Draw center text
    drawTextCentered(
        canvas,
        c,
        "تقسيم التركة",
        textFieldTextBigStyle,
        radius * 0.6,
            (Size size) {}
    );
  }

  void drawLabel(Canvas canvas, Offset c, double radius, double startAngle,
      double sweepAngle, ItemModel di) {
    const five = NaturalNumbersConstants.five;
    const oneHundred = DecimalNumbersConstants.oneHundred;

    final r = radius * 0.4;
    final dx = r * cos(startAngle + sweepAngle / tow);
    final dy = r * sin(startAngle + sweepAngle / tow);
    final position = c + Offset(dx, dy);

    drawTextCentered(
        canvas,
        position,
        di.title,
        labelStyle,
        oneHundred,
            (Size sz) {
          final rect = Rect.fromCenter(
              center: position,
              width: sz.width + five,
              height: sz.height + five
          );
          final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(5));
          canvas.drawRRect(rrect, midPaint);
        }
    );
  }

  void drawLine(Canvas canvas, Offset c, double radius, double startAngle) {
    final dx = radius / tow * cos(startAngle);
    final dy = radius / tow * sin(startAngle);
    final p2 = c + Offset(dx, dy);
    canvas.drawLine(c, p2, linePaint);
  }

  void drawSectors(Canvas canvas, ItemModel di, Rect rect, double startAngle,
      double sweepAngle) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = di.color;
    canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
  }

  TextPainter measureText(String s, TextStyle style, double maxWidth,
      TextAlign align) {
    final span = TextSpan(text: s, style: style);
    final tp = TextPainter(
        text: span,
        textAlign: align,
        textDirection: TextDirection.ltr
    );
    tp.layout(maxWidth: maxWidth);
    return tp;
  }

  Size drawTextCentered(Canvas canvas, Offset position, String text,
      TextStyle style, double maxWidth, Function(Size sz) bgCb) {
    final tp = measureText(text, style, maxWidth, TextAlign.center);
    final pos = position + Offset(-tp.width / tow, -tp.height / tow);
    //bgCb(tp.size);
    tp.paint(canvas, pos);
    return tp.size;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// Painting constants
final linePaint = Paint()
  ..color = Colors.white
  ..strokeWidth = 2.0
  ..style = PaintingStyle.stroke;

final midPaint = Paint()
  ..color = Colors.white
  ..style = PaintingStyle.fill;

const textFieldTextBigStyle = TextStyle(
  color: Colors.black38,
  fontWeight: FontWeight.bold,
  fontSize: 30.0,
);

const labelStyle = TextStyle(
  color: Colors.white,
  fontSize: 12.0,
);