import 'package:flutter/cupertino.dart';
import '../../core/constants/heirs_constants.dart';


class ButtonLuck {
  static bool get buttonLuck {
    final _hasItems = HeirsListsConstants.firstList.isNotEmpty ||
        HeirsListsConstants.secondList.isNotEmpty ||
        HeirsListsConstants.thirdList.isNotEmpty ||
        HeirsListsConstants.fourthList.isNotEmpty ||
        HeirsListsConstants.fifthList.isNotEmpty;
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    return _hasItems;
  }
}