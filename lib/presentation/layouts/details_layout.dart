import 'package:flutter/material.dart';
import 'package:men/core/constants/fonts_constants.dart';
import 'package:men/core/constants/colors_constants.dart';
import 'package:men/core/constants/numbers/decimal_numbers.dart';


class DetailsLayout extends StatelessWidget {
  final Map<String, String> _heirsDetails;

  const DetailsLayout(this._heirsDetails, {super.key});

  static const _white = ColorsConstants.white;
  static const _grey900 = ColorsConstants.grey_900;

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
          fontSize: FontsConstants.fontSize,
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
      padding: const EdgeInsets.all(10.0),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: detailsItems.length,
        separatorBuilder: (context, index) =>
        const Divider(
          height: 1,
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
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              key,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ColorsConstants.amber,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
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