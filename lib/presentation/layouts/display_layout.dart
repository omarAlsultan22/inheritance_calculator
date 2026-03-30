import 'dart:core';
import 'package:flutter/material.dart';
import '../utils/navigation_utils.dart';
import '../screens/details_screen.dart';
import '../../data/models/data_model.dart';
import 'package:men/core/constants/colors_constants.dart';
import '../screens/display_screen/widgets/chart_widgets.dart';
import '../screens/display_screen/painters/line_painter.dart';
import 'package:men/core/constants/numbers/decimal_numbers.dart';
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

  //spacing
  static const _spacing50 = 50.0;
  static const _spacing300 = 300.0;

  //colors
  static const _white = AppConstants.white;
  static const _grey900 = AppConstants.grey_900;

  static const _fontSize = AppConstants.fontSize;
  static const _padding = DecimalNumbersConstants.twenty;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _grey900,
        appBar: _buildDisplayAppBar(context),
        body: _buildDisplayBody(_dataHeirs, context, _animationManager),
      ),
    );;
  }


  AppBar _buildDisplayAppBar(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: DecimalNumbersConstants.zero,
      title: const Text(
        'النتيجة',
        style: TextStyle(
          fontSize: _fontSize,
          fontWeight: FontWeight.bold,
          color: _white,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: _white),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      backgroundColor: _grey900,
    );
  }


  Widget _buildDisplayBody(List<ItemModel> dataHeirs,
      BuildContext context,
      DisplayAnimationManager animationManager) {
    return Column(
      children: [
        Center(
          child: Container(
            width: _spacing300,
            height: _spacing300,
            child: CustomPaint(
              painter: DonutChartPainter(
                  dataset: dataHeirs,
                  fullAngle: animationManager.fullAngle
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(top: _padding, bottom: _padding),
              itemCount: dataHeirs.length,
              itemBuilder: (context, index) {
                return ChartLabelWidget(
                  label: dataHeirs[index].title,
                  anime: animationManager.animation.value,
                  value: animationManager.degrees[index],
                  isActive: animationManager.showLines[index],
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
            height: _spacing50,
            onPressed: () {
              NavigationUtils.navigator(context, DetailsScreen());
            },
            child: const Text(
              "التفاصيل",
              style: TextStyle(
                fontSize: _fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            color: AppConstants.amber,
          ),
        ),
      ],
    );
  }
}