import 'package:flutter/material.dart';
import 'package:men/core/constants/app_colors.dart';
import 'package:men/core/constants/app_text_styles.dart';
import 'package:men/core/constants/numbers/calculation_constants.dart';


class DetailsLayout extends StatelessWidget {
  final Map<String, String> _heirsDetails;

  const DetailsLayout(this._heirsDetails, {super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: _buildDetailsAppBar(context),
        backgroundColor: AppColors.darkGrey,
        body: _buildDetailsBody(_heirsDetails),
      ),
    );
  }


  AppBar _buildDetailsAppBar(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: CalculationConstants.zero,
      title: const Text(
          'الشرح',
          style: AppTextStyles.textStyle
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.white),
        onPressed: () => Navigator.pop(context),
      ),
      backgroundColor: AppColors.darkGrey,
    );
  }


  Widget _buildDetailsBody(Map<String, String> detailsItems) {
    return Padding(
      padding: const EdgeInsets.all(CalculationConstants.twenty),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: detailsItems.length,
        separatorBuilder: (context, index) =>
        const Divider(
          height: 1.0,
          color: AppColors.white,
          thickness: 0.1,
        ),
        itemBuilder: (context, index) {
          final key = detailsItems.keys.elementAt(index);
          final value = detailsItems[key]!;
          return _buildDetailRow(key, value);
        },
      ),
    );
  }


  Widget _buildDetailRow(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              key,
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: AppColors.amber,
              ),
            ),
          ),
          const SizedBox(width: CalculationConstants.ten),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: CalculationConstants.twenty,
                fontWeight: FontWeight.normal,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}