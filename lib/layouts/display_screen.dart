import 'package:flutter/material.dart';
import '../screens/details_screen.dart';
import 'package:men/shared/cubit/cubit.dart';
import '../screens/display_screen/widgets/chart_widgets.dart';
import '../screens/display_screen/painters/line_painter.dart';
import '../screens/display_screen/widgets/animation_managers.dart';
import '../screens/display_screen/painters/donut_chart_painter.dart';


AppBar buildDisplayAppBar(BuildContext context) {
  return AppBar(
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
      },
    ),
    backgroundColor: Colors.grey[900],
  );
}


Widget buildDisplayBody(
    DataCubit dataCubit,
    BuildContext context,
    DisplayAnimationManager animationManager) {
  return Column(
    children: [
      Center(
        child: Container(
          width: 300.0,
          height: 300.0,
          child: CustomPaint(
            painter: DonutChartPainter(
                dataCubit.dataItems,
                animationManager.fullAngle
            ),
          ),
        ),
      ),
      Expanded(
        child: Container(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            itemCount: dataCubit.dataItems.length,
            itemBuilder: (context, index) {
              return ChartLabelWidget(
                label: dataCubit.dataItems[index].label,
                anime: animationManager.animation.value,
                value: animationManager.degrees[index],
                toggle: animationManager.showLines[index],
                color: dataCubit.dataItems[index].color,
                linePainter: LinePainter(
                    animationManager.animations[index],
                    dataCubit.dataItems[index].color,
                    animationManager.showLines[index]
                ),
                animation: animationManager.animations[index],
              );
            },
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: MaterialButton(
          height: 50,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DetailsScreen())
            );
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
  );
}