import '../painters/line_painter.dart';
import 'package:flutter/material.dart';
import '../../../../constants/app_text_styles.dart';
import 'package:men/constants/numbers/calculation_constants.dart';


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

  static const _padding = 8.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: _padding,
          right: _padding,
          left: _padding,
          bottom: CalculationConstants.twenty),
      child: Row(
        children: <Widget>[
          Container(
            child: Transform.translate(
              offset: Offset(anime, CalculationConstants.zero),
              child: Text(label,
                  style: AppTextStyles.textStyle
              ),
            ),
          ),
          const SizedBox(width: 40.0),
          Container(child: CustomPaint(painter: linePainter)),
          Transform.translate(
              offset: Offset(-animation.value + -CalculationConstants.ten,
                  CalculationConstants.five),
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
