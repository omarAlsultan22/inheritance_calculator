import 'dart:core';
import 'package:flutter/material.dart';
import '../utils/navigation_utils.dart';
import '../screens/details_screen.dart';
import '../../data/models/data_model.dart';
import '../screens/display_screen/widgets/chart_widgets.dart';
import '../screens/display_screen/painters/line_painter.dart';
import '../screens/display_screen/widgets/animation_managers.dart';
import '../screens/display_screen/painters/donut_chart_painter.dart';


class DisplayLayout extends StatelessWidget {
  final List<ItemModel> _dataHeirs;
  final DisplayAnimationManager _animationManager;

  const DisplayLayout({
    required List<ItemModel> dataHeirs,
    required DisplayAnimationManager animationManager,
    super.key
  })
      : _animationManager = animationManager,
        _dataHeirs = dataHeirs;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: _buildDisplayAppBar(context),
        body: _buildDisplayBody(_dataHeirs, context, _animationManager),
      ),
    );;
  }


  AppBar _buildDisplayAppBar(BuildContext context) {
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


  Widget _buildDisplayBody(List<ItemModel> dataHeirs,
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
                  dataHeirs,
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
              itemCount: dataHeirs.length,
              itemBuilder: (context, index) {
                return ChartLabelWidget(
                  label: dataHeirs[index].title,
                  anime: animationManager.animation.value,
                  value: animationManager.degrees[index],
                  toggle: animationManager.showLines[index],
                  color: dataHeirs[index].color,
                  linePainter: LinePainter(
                      animationManager.animations[index],
                      dataHeirs[index].color,
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
              navigator(context, DetailsScreen());
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
}