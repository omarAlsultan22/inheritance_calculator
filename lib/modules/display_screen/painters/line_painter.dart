import 'package:flutter/cupertino.dart';


// Line Painter for percentage indicators
class LinePainter extends CustomPainter {
  final Animation<double> animation;
  final Color lineColor;
  final bool showLine;

  LinePainter(this.animation, this.lineColor, this.showLine);

  @override
  void paint(Canvas canvas, Size size) {
    if (showLine) {
      final paint = Paint()
        ..color = lineColor
        ..strokeWidth = 10;

      final c = Offset(0.0, size.height + 5.0);
      canvas.drawLine(c, Offset(-animation.value, size.height + 5.0), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}