import 'package:flutter/material.dart';
import 'package:men/core/constants/app_sizes.dart';
import 'package:men/core/constants/app_colors.dart';


abstract class AppTextStyles {
  static const textStyle = TextStyle(
      fontSize: AppSizes.fontSize25,
      fontWeight: FontWeight.bold,
      color: AppColors.white
  );
}