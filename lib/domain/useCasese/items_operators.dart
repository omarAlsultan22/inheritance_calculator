import 'package:men/presentation/states/management_items_state.dart';

import 'check_key.dart';
import 'package:flutter/cupertino.dart';
import '../../presentation/utils/button_luck.dart';
import '../../data/models/item_model.dart';
import '../../core/constants/heirs_constants.dart';
import '../../core/services/inheritance_service.dart';


class ItemsOperators {

  ManagementItemsState? addItem(String value) {
    if (CheckKey.KeyIsValid(value))
      return null;


    final textValue = HeirModel(value, true, true);
    final List<HeirModel> targetList = _getTargetList(value);

    if (!_containsValue(targetList, value)) {
      targetList.add(textValue);
      var process = HeirsStats.heirsMap[value];
      if (process != null) {
        HeirsStats.inheritanceState.heirsItems![value] = process;
      }
    }
    final _isActive = ButtonLuck.buttonLuck;
    final _multiList = HeirsListsConstants.multiList;

    return ManagementItemsState(
        isActive: _isActive,
        selectedItem: value,
        selectedItems: _multiList
    );
  }


  List<HeirModel> _getTargetList(String value) {
    if (HeirsListsConstants.category1.contains(value))
      return HeirsListsConstants.firstList;
    if (HeirsListsConstants.category2.contains(value))
      return HeirsListsConstants.secondList;
    if (HeirsListsConstants.category3.contains(value))
      return HeirsListsConstants.thirdList;
    if (HeirsListsConstants.category4.contains(value))
      return HeirsListsConstants.fourthList;
    return HeirsListsConstants.fifthList;
  }

  bool _containsValue(List<HeirModel> list, String value) {
    for (final item in list) {
      if (item.heirName == value) return true;
    }
    return false;
  }


  ManagementItemsState removeItem(HeirModel e) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (HeirsListsConstants.firstList.contains(e)) {
        HeirsListsConstants.firstList.remove(e);
      } else if (HeirsListsConstants.secondList.contains(e)) {
        HeirsListsConstants.secondList.remove(e);
      } else if (HeirsListsConstants.thirdList.contains(e)) {
        HeirsListsConstants.thirdList.remove(e);
      } else if (HeirsListsConstants.fourthList.contains(e)) {
        HeirsListsConstants.fourthList.remove(e);
      } else {
        HeirsListsConstants.fifthList.remove(e);
      }

      HeirsStats.inheritanceState.heirsItems!.remove(e.heirName);
    });

    final _isActive = ButtonLuck.buttonLuck;
    final _multiList = HeirsListsConstants.multiList;

    return ManagementItemsState(
        isActive: _isActive,
        selectedItems: _multiList
    );
  }
}