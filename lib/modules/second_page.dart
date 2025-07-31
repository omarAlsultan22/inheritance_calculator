import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:men/modules/third_page.dart';
import '../models/data_model.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';

class SecondPage extends StatefulWidget {
  SecondPage({Key? key}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> with TickerProviderStateMixin {
  late Timer timer;
  late AnimationController controller, _controller;
  late Animation<double> animation;
  double fullAngle = 0.0;
  final double secondsToComplete = 5.0;
  List<int> degrees = [];
  List<bool> showLines = [];
  List<Animation<double>> animations = [];
  late DataCubit cubitData;

  @override
  void initState() {
    super.initState();
    cubitData = DataCubit.get(context);
    // Initialize degrees and showLines lists
    for (var i = 0; i < cubitData.dataItems.length; i++) {
      degrees.add(0);
      showLines.add(false);
    }

    // Animation for text entry
    controller = AnimationController(
        duration: const Duration(seconds: 1),
        vsync: this
    );
    animation = Tween(begin: 200.0, end: -20.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });

    // Animation for donut chart
    timer = Timer.periodic(const Duration(milliseconds: 1000 ~/ 60), (timer) {
      setState(() {
        fullAngle += 360.0 / (secondsToComplete * 1000 ~/ 60);
        if (fullAngle >= 360.0) {
          fullAngle = 360.0;
          timer.cancel();
          // Start showing lines after chart completes
        }
        for (int i = 0; i < cubitData.dataItems.length; i++) {
          startLineTimer(i);
        }
      });
    });

    // Animation for line growth
    _controller = AnimationController(
        duration: const Duration(seconds: 3),
        vsync: this
    );

    // Initialize line animations
    for (var item in cubitData.dataItems) {
      animations.add(
          Tween<double>(begin: 0, end: item.value * 200).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Interval(
                0.3, // يبدأ بعد 2 ثانية (40% من 5 ثوانٍ)
                1.0,
                curve: Curves.easeIn,
              ),
            ),
          )
      );
    }

    controller.forward();
    _controller.forward();
  }

  void startLineTimer(int index) {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (degrees[index] < (cubitData.dataItems[index].value * 100).toInt()) {
            degrees[index]++;
          } else {
            timer.cancel();
          }
          if (!showLines[index]) {
            showLines[index] = true;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    controller.dispose();
    _controller.dispose();
    super.dispose();
  }

  Widget buildLabel(String label, double anime, int degree, bool toggle,
      Animation animation, Color color, LinePainter linePainter) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 8.0, right: 8.0, left: 8.0, bottom: 20.0),
      child: Row(
        children: <Widget>[
          Container(
            child: Transform.translate(
              offset: Offset(anime, 0.0),
              child: Text(label,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                  )
              ),
            ),
          ),
          SizedBox(width: 40.0),
          Container(child: CustomPaint(painter: linePainter)),
          Transform.translate(
              offset: Offset(-animation.value + -10.0, 5.0),
              child: Text("${degree.toString()}%",
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataCubit, DataStates>(builder: (context, state) {
      final dataItems = cubitData.dataItems;
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.grey[900],
          appBar: AppBar(
            scrolledUnderElevation: 0.0,
            title: const Text(
              'النتيجة',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                }
            ),
            backgroundColor: Colors.grey[900],
          ),
          body: Column(
            children: [
              Center(
                child: Container(
                  width: 300.0,
                  height: 300.0,
                  child: CustomPaint(
                    painter: DonutChartPainter(
                        dataItems, fullAngle, context),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    // هامش سفلي
                    itemCount: cubitData.dataItems.length,
                    itemBuilder: (context, index) {
                      return buildLabel(
                          cubitData.dataItems[index].label,
                          animation.value,
                          degrees[index],
                          showLines[index],
                          animations[index],
                          cubitData.dataItems[index].color,
                          LinePainter(
                              animations[index],
                              cubitData.dataItems[index].value,
                              cubitData.dataItems[index].color,
                              showLines[index]
                          )
                      );
                    },
                  ),
                ),
              ),

              // الجزء السفلي الثابت (زر التفاصيل)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: MaterialButton(
                  height: 50,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>
                            ThirdPage()));
                  },
                  child: const Text(
                    "التفاصيل",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  color: Colors.amber,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

// Donut Chart Painter
class DonutChartPainter extends CustomPainter {
  final List<DataItems> dataset;
  final double fullAngle;
  final BuildContext context;

  DonutChartPainter(this.dataset, this.fullAngle, this.context);

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2.0, size.height / 2.0);
    final radius = size.width * 0.9;
    final rect = Rect.fromCenter(center: c, width: radius, height: radius);
    double startAngle = 0.0;

    // Draw background circle
    canvas.drawArc(rect, startAngle, fullAngle * pi / 180.0, false, linePaint);

    // Draw sectors
    for (var di in dataset) {
      double sweepAngle = di.value * fullAngle * pi / 180.0;
      drawSectors(canvas, di, rect, startAngle, sweepAngle);
      startAngle += sweepAngle;
    }

    // Draw lines and labels
    startAngle = 0.0;
    for (var di in dataset) {
      double sweepAngle = di.value * fullAngle * pi / 180.0;
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
      double sweepAngle, DataItems di) {
    final r = radius * 0.4;
    final dx = r * cos(startAngle + sweepAngle / 2.0);
    final dy = r * sin(startAngle + sweepAngle / 2.0);
    final position = c + Offset(dx, dy);

    drawTextCentered(
        canvas,
        position,
        di.label,
        labelStyle,
        100.0,
            (Size sz) {
          final rect = Rect.fromCenter(
              center: position,
              width: sz.width + 5,
              height: sz.height + 5
          );
          final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(5));
          canvas.drawRRect(rrect, midPaint);
        }
    );
  }

  void drawLine(Canvas canvas, Offset c, double radius, double startAngle) {
    final dx = radius / 2.0 * cos(startAngle);
    final dy = radius / 2.0 * sin(startAngle);
    final p2 = c + Offset(dx, dy);
    canvas.drawLine(c, p2, linePaint);
  }

  void drawSectors(Canvas canvas, DataItems di, Rect rect, double startAngle,
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
    final pos = position + Offset(-tp.width / 2.0, -tp.height / 2.0);
    //bgCb(tp.size);
    tp.paint(canvas, pos);
    return tp.size;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// Line Painter for percentage indicators
class LinePainter extends CustomPainter {
  final Animation<double> animation;
  final double linePosition;
  final Color lineColor;
  final bool showLine;

  LinePainter(this.animation, this.linePosition, this.lineColor, this.showLine);

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