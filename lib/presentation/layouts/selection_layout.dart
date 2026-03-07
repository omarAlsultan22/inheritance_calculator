import 'package:flutter/material.dart';
import '../../data/models/item_model.dart';
import '../states/management_items_state.dart';
import '../cubits/management_items_cubit.dart';
import '../../core/constants/heirs_constants.dart';
import '../screens/display_screen/display_screen.dart';
import 'package:men/core/constants/fonts_constants.dart';
import 'package:men/core/constants/colors_constants.dart';
import 'package:men/presentation/utils/navigation_utils.dart';
import 'package:men/core/constants/numbers/decimal_numbers.dart';
import 'package:men/presentation/cubits/distribution_shares_cubit.dart';


class SelectionLayout extends StatelessWidget {
  ManagementItemsState _state;
  ManagementItemsCubit _dataCubit;
  bool _isLoading = false;

  SelectionLayout(this._state, this._dataCubit, {super.key});

  //numbers
  static const _zero = DecimalNumbersConstants.zero;

  //colors
  static const _black = Colors.black;
  static const _white = ColorsConstants.white;
  static const _grey900 = ColorsConstants.grey_900;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _grey900,
        appBar: _buildSelectionAppBar(),
        body: Column(
          children: [
            const SizedBox(height: 50),
            _headline(),
            _itemsMenu(_dataCubit, _state),
            _selectedItems(),
            _calculateButton(context),
          ],
        ),
      ),
    );
  }


  AppBar _buildSelectionAppBar() =>
      AppBar(
        elevation: _zero,
        scrolledUnderElevation: _zero,
        backgroundColor: _grey900,
        title: const Text(
          "مواريث",
          style: TextStyle(
            fontSize: FontsConstants.fontSize,
            fontWeight: FontWeight.bold,
            color: _white,
          ),
        ),
      );


  Widget _headline() {
    return const Text(
      "مات وترك ؟",
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: _white,
      ),
      textAlign: TextAlign.center,
    );
  }


  Widget _itemsMenu(ManagementItemsCubit dataCubit,
      ManagementItemsState state) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButton<String>(
        menuMaxHeight: 200,
        hint: const Text(
          'أختر',
          style: TextStyle(color: _white),
        ),
        value: state.selectedItem,
        dropdownColor: const Color(0xFF424242),
        borderRadius: BorderRadius.circular(10),
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
      onTap: () => _dataCubit.updateHeir(element),
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
                  onPressed: () => _dataCubit.removeHeir(element),
                ),
              ),

            // Main text
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  element.heirName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: element.backgroundColor ? _white : _black,
                  ),
                ),
              ),
            ),

            // Sum badge
            if (!element.isShowing)
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${element.totalHeirs}',
                    style: const TextStyle(
                      color: _white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
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
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: GridView.count(
          physics: const BouncingScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.9,
          children: HeirsListsConstants.multiList
              .expand((list) => list)
              .map((element) => _buildGridItem(element))
              .toList(),
        ),
      ),
    );
  }

  Widget _calculateButton(BuildContext context) {
    final _isActive = _state.isActive!;
    return Container(
      width: double.infinity,
      color: _isActive ? ColorsConstants.amber : const Color(0xFF757575),
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
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: CircularProgressIndicator(color: _black),
          ),
        )
            : const Text(
          'أحسب',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: _white,
          ),
        ),
      ),
    );
  }
}