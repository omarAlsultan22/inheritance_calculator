import '../../core/constants/heirs_constants.dart';


class CheckKey {
  static bool KeyIsValid(String? key) {
    if (keyNotEmpty(key)) {
      if (!checkCouple(key!)) {
        return true;
      };
    }
    return false;
  }

  static bool keyNotEmpty(String? key) {
    return key != null && key.isNotEmpty;
  }

  static bool checkCouple(String key) {
    if (key == 'الزوج' || key == 'الزوجة') {
      return HeirsListsConstants.firstList.any((item) =>
      item.heirName == 'الزوج' || item.heirName == 'الزوجة');
    }
    return false;
  }
}