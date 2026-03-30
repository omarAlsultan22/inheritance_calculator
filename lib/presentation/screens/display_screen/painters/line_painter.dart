import 'package:flutter/cupertino.dart';
import 'package:men/core/constants/numbers/decimal_numbers.dart';
import 'package:men/core/constants/numbers/natural_numbers_constants.dart';


// Line Painter for percentage indicators
class LinePainter extends CustomPainter {
  final Animation<double> _animation;
  final Color _lineColor;
  final bool _showLine;

  LinePainter(this._animation, this._lineColor, this._showLine);

  static const _dx = DecimalNumbersConstants.zero;
  static const _dy = NaturalNumbersConstants.five;
  static const _value = DecimalNumbersConstants.ten;

  @override
  void paint(Canvas canvas, Size size) {
    if (_showLine) {
      final paint = Paint()
        ..color = _lineColor
        ..strokeWidth = _value;

      final c = Offset(_dx, size.height + _dy);
      canvas.drawLine(c, Offset(-_animation.value, size.height + _dy), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}