import 'package:flutter/cupertino.dart';
import 'package:men/core/constants/numbers/decimal_numbers.dart';
import 'package:men/core/constants/numbers/natural_numbers_constants.dart';


// Line Painter for percentage indicators
class LinePainter extends CustomPainter {
  final Animation<double> _animation;
  final Color _lineColor;
  final bool _showLine;

  LinePainter(this._animation, this._lineColor, this._showLine);

  @override
  void paint(Canvas canvas, Size size) {
    const five = NaturalNumbersConstants.five;
    if (_showLine) {
      final paint = Paint()
        ..color = _lineColor
        ..strokeWidth = 10;

      final c = Offset(DecimalNumbersConstants.zero, size.height + five);
      canvas.drawLine(c, Offset(-_animation.value, size.height + five), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}