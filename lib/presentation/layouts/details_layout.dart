import 'package:flutter/material.dart';
import 'package:men/core/constants/colors_constants.dart';
import 'package:men/core/constants/numbers/decimal_numbers.dart';


class DetailsLayout extends StatelessWidget {
  final Map<String, String> _heirsDetails;

  const DetailsLayout(this._heirsDetails, {super.key});

  //colors
  static const _white = AppConstants.white;
  static const _grey900 = AppConstants.grey_900;

  //paddings
  static const _paddingAll = DecimalNumbersConstants.twenty;
  static const _smallFont = _paddingAll;

  //fonts
  static const _midFont = 15.0;
  static const _paddingSymmetric = _midFont;

  //spacing
  static const _spacing = DecimalNumbersConstants.ten;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: _buildDetailsAppBar(context),
        backgroundColor: _grey900,
        body: _buildDetailsBody(_heirsDetails),
      ),
    );
  }


  AppBar _buildDetailsAppBar(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: DecimalNumbersConstants.zero,
      title: const Text(
        'الشرح',
        style: TextStyle(
          fontSize: AppConstants.fontSize,
          fontWeight: FontWeight.bold,
          color: _white,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: _white),
        onPressed: () => Navigator.pop(context),
      ),
      backgroundColor: _grey900,
    );
  }


  Widget _buildDetailsBody(Map<String, String> detailsItems) {
    return Padding(
      padding: const EdgeInsets.all(_paddingAll),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: detailsItems.length,
        separatorBuilder: (context, index) =>
        const Divider(
          height: 1.0,
          color: _white,
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
      padding: const EdgeInsets.symmetric(vertical: _paddingSymmetric),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              key,
              style: const TextStyle(
                fontSize: _midFont,
                fontWeight: FontWeight.bold,
                color: AppConstants.amber,
              ),
            ),
          ),
          const SizedBox(width: _spacing),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: _smallFont,
                fontWeight: FontWeight.normal,
                color: _white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}