import 'package:flutter/material.dart';
import '../../data/models/item_model.dart';
import '../constants/heirs_constants.dart';
import '../states/management_items_state.dart';
import '../cubits/management_items_cubit.dart';
import '../screens/display_screen/display_screen.dart';
import 'package:men/core/constants/colors_constants.dart';
import 'package:men/presentation/utils/navigation_utils.dart';
import 'package:men/core/constants/numbers/decimal_numbers.dart';
import 'package:men/presentation/cubits/distribution_shares_cubit.dart';
import 'package:men/core/constants/numbers/natural_numbers_constants.dart';


class SelectionLayout extends StatelessWidget {
  bool _isLoading = false;
  ManagementItemsState state;
  ManagementItemsCubit dataCubit;

  SelectionLayout({
    required this.state,
    required this.dataCubit,
    super.key
  });

  //sizes
  static const _radius = _paddingHorizontal;

  //colors
  static const _black = Colors.black;
  static const _white = AppConstants.white;
  static const _grey900 = AppConstants.grey_900;

  //fonts
  static const _fontSize40 = DecimalNumbersConstants.forty;
  static const _fontSize30 = DecimalNumbersConstants.thirty;
  static const _fontSize12 = DecimalNumbersConstants.twelve;

  //spacing
  static const _spacing50 = DecimalNumbersConstants.fifty;
  static const _axisSpacing = DecimalNumbersConstants.eight;
  static const _menuMaxHeight = DecimalNumbersConstants.towHundred;
  static const _childAspectRatio = DecimalNumbersConstants.zeroPointNine;

  //paddings
  static const _paddingAll = EdgeInsets.all(_axisSpacing);
  static const _paddingVertical = DecimalNumbersConstants.tow;
  static const _paddingHorizontal = DecimalNumbersConstants.ten;

  //values
  static const _positionValue = 4.0;
  static const _numberValue = DecimalNumbersConstants.zero;
  static const _opacityValue = DecimalNumbersConstants.zeroPointSix;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _grey900,
        appBar: _buildSelectionAppBar(),
        body: Column(
            children: [
            const SizedBox(height: _spacing50),
        _headline(),
        _itemsMenu(
            state: this.state,
            dataCubit: this.dataCubit
        ),
        _selectedItems(),
        _calculateButton(context),
        ],
      ),
    ),);
  }


  AppBar _buildSelectionAppBar() =>
      AppBar(
        elevation: _numberValue,
        scrolledUnderElevation: _numberValue,
        backgroundColor: _grey900,
        title: const Text(
          "مواريث",
          style: TextStyle(
            fontSize: AppConstants.fontSize,
            fontWeight: FontWeight.bold,
            color: _white,
          ),
        ),
      );


  Widget _headline() {
    return const Text(
      "مات وترك ؟",
      style: TextStyle(
        fontSize: _fontSize40,
        fontWeight: FontWeight.bold,
        color: _white,
      ),
      textAlign: TextAlign.center,
    );
  }


  Widget _itemsMenu({
    required ManagementItemsState state,
    required ManagementItemsCubit dataCubit
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButton<String>(
        menuMaxHeight: _menuMaxHeight,
        hint: const Text(
          'أختر',
          style: TextStyle(color: _white),
        ),
        value: state.selectedItem,
        dropdownColor: const Color(0xFF424242),
        borderRadius: BorderRadius.circular(_radius),
        items: HeirsListsConstants.heirsList.map((String key) {
          return DropdownMenuItem<String>(
            value: key,
            child: Text(
              key,
              style: const TextStyle(color: _white),
            ),
          );
        }).toList(),
        onChanged: (String? key) {
          if (key!.isNotEmpty) {
            dataCubit.addHeir(key);
          }
        },
      ),
    );
  }


  Widget _buildGridItem(HeirModel element) {
    return GestureDetector(
      onTap: () => dataCubit.updateHeir(element),
      child: Card(
        color: const Color(0xFF616161),
        child: Stack(
          children: [
            // Remove button
            if (element.removeIcon)
              Align(
                alignment: AlignmentDirectional.topStart,
                child: IconButton(
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.highlight_remove_outlined,
                    color: Colors.white70,
                  ),
                  onPressed: () => dataCubit.removeHeir(element),
                ),
              ),

            // Main text
            Center(
              child: Padding(
                padding: _paddingAll,
                child: Text(
                  element.heirName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                    color: element.backgroundColor ? _white : _black,
                  ),
                ),
              ),
            ),

            // Sum badge
            if (!element.isShowing)
              Positioned(
                bottom: _positionValue,
                right: _positionValue,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6.0, vertical: _paddingVertical),
                  decoration: BoxDecoration(
                    color: _black.withOpacity(_opacityValue),
                    borderRadius: BorderRadius.circular(_radius),
                  ),
                  child: Text(
                    '${element.totalHeirs}',
                    style: const TextStyle(
                      color: _white,
                      fontWeight: FontWeight.bold,
                      fontSize: _fontSize12,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }


  Widget _selectedItems() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: _paddingHorizontal),
        child: GridView.count(
          physics: const BouncingScrollPhysics(),
          crossAxisCount: NaturalNumbersConstants.there,
          crossAxisSpacing: _axisSpacing,
          mainAxisSpacing: _axisSpacing,
          childAspectRatio: _childAspectRatio,
          children: HeirsListsConstants.multiList
              .expand((list) => list)
              .map((element) => _buildGridItem(element))
              .toList(),
        ),
      ),
    );
  }

  Widget _calculateButton(BuildContext context) {
    final _isActive = state.isActive!;
    return Container(
      width: double.infinity,
      color: _isActive ? AppConstants.amber : const Color(0xFF757575),
      child: MaterialButton(
        onPressed: () {
          _isLoading = true;
          _isActive ? DistributionSharesCubit.get(context)
              .executeDistribution()
              .then((_) {
            NavigationUtils.navigator(context, DisplayScreen());
            _isLoading = false;
          }) : null;
        },
        child: _isLoading
            ? const Padding(
          padding: _paddingAll,
          child: Center(
            child: CircularProgressIndicator(color: _black),
          ),
        )
            : const Text(
          'أحسب',
          style: TextStyle(
            fontSize: _fontSize30,
            fontWeight: FontWeight.bold,
            color: _white,
          ),
        ),
      ),
    );
  }
}