import 'package:flutter/cupertino.dart';
import 'package:men/core/constants/numbers/decimal_numbers.dart';
import 'package:men/core/constants/numbers/natural_numbers_constants.dart';


// Line Painter for percentage indicators
class LinePainter extends CustomPainter {
  final Animation<double> animation;
  final Color lineColor;
  final bool showLine;

  LinePainter(this.animation, this.lineColor, this.showLine);

  @override
  void paint(Canvas canvas, Size size) {
    const five = NaturalNumbersConstants.five;
    if (showLine) {
      final paint = Paint()
        ..color = lineColor
        ..strokeWidth = 10;

      final c = Offset(DecimalNumbersConstants.zero, size.height + five);
      canvas.drawLine(c, Offset(-animation.value, size.height + five), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}