import 'package:flutter/cupertino.dart';
import 'package:men/core/constants/numbers/calculation_constants.dart';
import 'package:men/core/constants/numbers/person_count_constants.dart';


// Line Painter for percentage indicators
class LinePainter extends CustomPainter {
  final Animation<double> _animation;
  final Color _lineColor;
  final bool _showLine;

  LinePainter(this._animation, this._lineColor, this._showLine);

  @override
  void paint(Canvas canvas, Size size) {
    if (_showLine) {
      final paint = Paint()
        ..color = _lineColor
        ..strokeWidth = CalculationConstants.ten;

      final c = Offset(CalculationConstants.zero, size.height + PersonCountConstants.five);
      canvas.drawLine(c, Offset(-_animation.value, size.height + PersonCountConstants.five), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}