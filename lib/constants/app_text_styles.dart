import 'app_colors.dart';
import 'package:flutter/material.dart';
import 'package:men/constants/app_sizes.dart';


abstract class AppTextStyles {
  static const textStyle = TextStyle(
      fontSize: AppSizes.fontSize25,
      fontWeight: FontWeight.bold,
      color: AppColors.white
  );
}