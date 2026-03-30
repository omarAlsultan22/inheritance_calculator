import 'package:flutter/material.dart';
import '../painters/line_painter.dart';
import 'package:men/core/constants/numbers/decimal_numbers.dart';


class ChartLabelWidget extends StatelessWidget {
  final String label;
  final double anime;
  final int value;
  final bool isActive;
  final Animation animation;
  final Color color;
  final LinePainter linePainter;

  const ChartLabelWidget({
    Key? key,
    required this.label,
    required this.anime,
    required this.value,
    required this.isActive,
    required this.animation,
    required this.color,
    required this.linePainter,
  }) : super(key: key);

  static const _spacing = DecimalNumbersConstants.forty;
  static const _dx = DecimalNumbersConstants.ten;

  //padding
  static const _paddingBottom = DecimalNumbersConstants.twenty;
  static const _padding = 8.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: _padding, right: _padding, left: _padding, bottom: _paddingBottom),
      child: Row(
        children: <Widget>[
          Container(
            child: Transform.translate(
              offset: Offset(anime, DecimalNumbersConstants.zero),
              child: Text(label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                  )
              ),
            ),
          ),
          const SizedBox(width: _spacing),
          Container(child: CustomPaint(painter: linePainter)),
          Transform.translate(
              offset: Offset(-animation.value + -_dx, DecimalNumbersConstants.five),
              child: Text("${value.toString()}%",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isActive ? color : Colors.transparent
                  )
              )
          )
        ],
      ),
    );
  }
}
