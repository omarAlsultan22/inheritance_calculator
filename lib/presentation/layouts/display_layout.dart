import 'dart:core';
import 'package:flutter/material.dart';
import '../utils/navigation_utils.dart';
import '../screens/details_screen.dart';
import '../../data/models/data_model.dart';
import 'package:men/core/constants/fonts_constants.dart';
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

  //colors
  static const _white = ColorsConstants.white;
  static const _grey900 = ColorsConstants.grey_900;

  //fonts
  static const _fontSize = FontsConstants.fontSize;

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
    const threeHundred = 300.0;
    return Column(
      children: [
        Center(
          child: Container(
            width: threeHundred,
            height: threeHundred,
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
            height: 50.0,
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
            color: ColorsConstants.amber,
          ),
        ),
      ],
    );
  }
}