import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../data/models/item_model.dart';
import '../constants/heirs_constants.dart';
import '../../constants/app_text_styles.dart';
import '../states/management_items_state.dart';
import '../cubits/management_items_cubit.dart';
import '../screens/display_screen/display_screen.dart';
import '../../constants/numbers/calculation_constants.dart';
import '../../constants/numbers/person_count_constants.dart';
import 'package:men/presentation/utils/navigation_utils.dart';
import 'package:men/presentation/cubits/distribution_shares_cubit.dart';


class SelectionLayout extends StatelessWidget {
  bool _isLoading = false;
  ManagementItemsState state;
  ManagementItemsCubit dataCubit;

  SelectionLayout({
    required this.state,
    required this.dataCubit,
    super.key
  });

  static const _axisSpacing = 8.0;
  static final _borderRadius = BorderRadius.circular(10.0);
  static const _paddingAll = EdgeInsets.all(_axisSpacing);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.darkGrey,
        appBar: _buildSelectionAppBar(),
        body: Column(
          children: [
            const SizedBox(height: 50.0),
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
        elevation: CalculationConstants.zero,
        scrolledUnderElevation: CalculationConstants.zero,
        backgroundColor: AppColors.darkGrey,
        title: const Text(
          "مواريث",
          style: AppTextStyles.textStyle,
        ),
      );


  Widget _headline() {
    return const Text(
      "مات وترك ؟",
      style: TextStyle(
        fontSize: 40.0,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
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
        menuMaxHeight: CalculationConstants.twoHundred,
        hint: const Text(
          'أختر',
          style: TextStyle(color: AppColors.white),
        ),
        value: state.selectedItem,
        dropdownColor: const Color(0xFF424242),
        borderRadius: _borderRadius,
        items: HeirsListsConstants.heirsList.map((String key) {
          return DropdownMenuItem<String>(
            value: key,
            child: Text(
              key,
              style: const TextStyle(color: AppColors.white),
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
                    color: element.backgroundColor ? AppColors.white : Colors
                        .black,
                  ),
                ),
              ),
            ),

            // Sum badge
            if (!element.isShowing)
              Positioned(
                bottom: 4.0,
                right: 4.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6.0, vertical: 2.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(
                        CalculationConstants.zeroPointSix),
                    borderRadius: _borderRadius,
                  ),
                  child: Text(
                    '${element.totalHeirs}',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
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
        padding: const EdgeInsets.symmetric(
            horizontal: CalculationConstants.ten),
        child: GridView.count(
          physics: const BouncingScrollPhysics(),
          crossAxisCount: PersonCountConstants.three,
          crossAxisSpacing: _axisSpacing,
          mainAxisSpacing: _axisSpacing,
          childAspectRatio: CalculationConstants.zeroPointNine,
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
      color: _isActive ? AppColors.amber : const Color(0xFF757575),
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
            child: CircularProgressIndicator(color: Colors.black),
          ),
        )
            : const Text(
          'أحسب',
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}