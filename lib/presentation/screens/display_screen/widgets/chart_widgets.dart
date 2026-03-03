import 'package:men/core/constants/numbers/decimal_numbers.dart';
import '../../../../data/models/data_model.dart';
import '../painters/donut_chart_painter.dart';
import 'package:flutter/material.dart';
import '../painters/line_painter.dart';


class ChartLabelWidget extends StatelessWidget {
  final String label;
  final double anime;
  final int value;
  final bool toggle;
  final Animation animation;
  final Color color;
  final LinePainter linePainter;

  const ChartLabelWidget({
    Key? key,
    required this.label,
    required this.anime,
    required this.value,
    required this.toggle,
    required this.animation,
    required this.color,
    required this.linePainter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 8.0, right: 8.0, left: 8.0, bottom: 20.0),
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
          const SizedBox(width: 40.0),
          Container(child: CustomPaint(painter: linePainter)),
          Transform.translate(
              offset: Offset(-animation.value + -10.0, DecimalNumbersConstants.five),
              child: Text("${value.toString()}%",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: toggle ? color : Colors.transparent
                  )
              )
          )
        ],
      ),
    );
  }
}

class DonutChartWidget extends StatelessWidget {
  final List<ItemModel> dataItems;
  final double fullAngle;

  const DonutChartWidget({
    Key? key,
    required this.dataItems,
    required this.fullAngle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const threeHundred = 300.0;
    return Container(
      width: threeHundred,
      height: threeHundred,
      child: CustomPaint(
        painter: DonutChartPainter(dataItems, fullAngle),
      ),
    );
  }
}