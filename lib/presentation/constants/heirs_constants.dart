import '../../data/models/item_model.dart';


class HeirsListsConstants {

  static const List<String> heirsList = [
    'الزوج', 'الزوجة', 'الأب', 'الأم',
    'الجد', 'الجدة لأب', 'الجدة لأم',
    'البنت', 'بنت الابن', 'الابن',
    'ابن الابن', 'الأخت الشقيقة',
    'الأخت لأب', 'الأخوة لأم', 'الأخ الشقيق',
    'الأخ لأب', 'ابن الأخ الشقيق',
    'ابن الأخ لأب', 'العم الشقيق', 'العم لأب',
    'ابن العم الشقيق', 'ابن العم لأب'
  ];

  static const List<String> category1 = ["الزوج", "الزوجة"];
  static const List<String> category2 = ["الأب", "الجد"];
  static const List<String> category3 = ["الأم", "الجدة لأب", "الجدة لأم"];
  static const List<String> category4 = [
    "البنت",
    "بنت الابن",
    "الأخت الشقيقة",
    "الأخت لأب",
    "الأخوة لأم"
  ];

  static final List<List<HeirModel>> multiList = [
    firstList,
    secondList,
    thirdList,
    fourthList,
    fifthList,
  ];

  static List<HeirModel> firstList = [];
  static List<HeirModel> secondList = [];
  static List<HeirModel> thirdList = [];
  static List<HeirModel> fourthList = [];
  static List<HeirModel> fifthList = [];
}