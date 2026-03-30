import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../data/models/data_model.dart';
import 'package:men/core/constants/numbers/decimal_numbers.dart';
import 'package:men/presentation/constants/painting_constants.dart';
import 'package:men/core/constants/numbers/natural_numbers_constants.dart';


// Donut Chart Painter
class DonutChartPainter extends CustomPainter {
  final double fullAngle;
  final List<ItemModel> dataset;

  DonutChartPainter({
    required this.dataset,
    required this.fullAngle
  });

  static const _value = 2.0;
  static const _halfAngle = 180.0;
  static const zero = DecimalNumbersConstants.zero;
  static const fontSize = DecimalNumbersConstants.thirty;

  //paints
  static final _midPaint = PaintingConstants.midPaint;
  static final _linePaint = PaintingConstants.linePaint;

  //radius
  static const _midRadius = DecimalNumbersConstants.zeroPointNine;
  static const _smallRadius = DecimalNumbersConstants.zeroPointSix;

  @override
  void paint(Canvas canvas, Size size) {


    final c = Offset(size.width / _value, size.height / _value);
    final radius = size.width * _midRadius;
    final rect = Rect.fromCenter(center: c, width: radius, height: radius);
    double startAngle = zero;

    // Draw background circle
    canvas.drawArc(
        rect, startAngle, fullAngle * pi / _halfAngle, false, _linePaint);

    // Draw sectors
    for (var di in dataset) {
      double sweepAngle = di.amount * fullAngle * pi / _halfAngle;
      _drawSectors(canvas, di, rect, startAngle, sweepAngle);
      startAngle += sweepAngle;
    }

    // Draw lines and labels
    startAngle = zero;
    for (var di in dataset) {
      double sweepAngle = di.amount * fullAngle * pi / _halfAngle;
      _drawLine(canvas, c, radius, startAngle);
      _drawLabel(canvas, c, radius, startAngle, sweepAngle, di);
      startAngle += sweepAngle;
    }

    // Draw center circle
    canvas.drawCircle(c, radius * 0.3, _midPaint);

    // Draw center text
    _drawTextCentered(
        canvas,
        c,
        "تقسيم التركة",
        PaintingConstants.textFieldTextBigStyle,
        radius * _smallRadius,
            (Size size) {}
    );
  }

  void _drawLabel(Canvas canvas, Offset c, double radius, double startAngle,
      double sweepAngle, ItemModel di) {
    const five = NaturalNumbersConstants.five;

    final r = radius * 0.4;
    final dx = r * cos(startAngle + sweepAngle / _value);
    final dy = r * sin(startAngle + sweepAngle / _value);
    final position = c + Offset(dx, dy);

    _drawTextCentered(
        canvas,
        position,
        di.title,
        PaintingConstants.labelStyle,
        DecimalNumbersConstants.oneHundred,
            (Size sz) {
          final rect = Rect.fromCenter(
              center: position,
              width: sz.width + five,
              height: sz.height + five
          );
          final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(5));
          canvas.drawRRect(rrect, _midPaint);
        }
    );
  }

  void _drawLine(Canvas canvas, Offset c, double radius, double startAngle) {
    final dx = radius / _value * cos(startAngle);
    final dy = radius / _value * sin(startAngle);
    final p2 = c + Offset(dx, dy);
    canvas.drawLine(c, p2, PaintingConstants.linePaint);
  }

  void _drawSectors(Canvas canvas, ItemModel di, Rect rect, double startAngle,
      double sweepAngle) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = di.color;
    canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
  }

  TextPainter _measureText(String s, TextStyle style, double maxWidth,
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

  Size _drawTextCentered(Canvas canvas, Offset position, String text,
      TextStyle style, double maxWidth, Function(Size sz) bgCb) {
    final tp = _measureText(text, style, maxWidth, TextAlign.center);
    final pos = position + Offset(-tp.width / _value, -tp.height / _value);
    //bgCb(tp.size);
    tp.paint(canvas, pos);
    return tp.size;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
