import 'dart:ui';
import 'data_model.dart';
import 'package:men/models/heir_processor_model.dart';


enum HeirType {
  husband('الزوج'),
  wife('الزوجة'),
  father('الأب'),
  mother('الأم'),
  son('الابن'),
  daughter('البنت'),
  sonsSon('ابن الابن'),
  sonsDaughter('بنت الابن'),
  grandfather('الجد'),
  paternalGrandMother('الجدة لأب'),
  maternalGrandmother('الجدة لأم'),
  fullSister('الأخت الشقيقة'),
  paternalSister('الأخت لأب'),
  fullBrother('الأخ الشقيق'),
  paternalBrother('الأخ لأب'),
  maternalSiblings('الأخ لأم'),
  fullUncle('العم الشقيق'),
  paternalUncle('العم لأب'),
  fullBrothersSon('ابن الأخ الشقيق'),
  paternalBrothersSon('ابن الأخ لأب'),
  fullCousin('ابن العم الشقيق'),
  paternalCousin('ابن العم لأب'),
  ;

  const HeirType(this.heirName);

  final String heirName;

  String getPluralName(int count) {
    if (count == 1) return heirName;

    final pluralMap = {
      HeirType.wife: 'الزوجات',
      HeirType.daughter: 'البنات',
      HeirType.son: 'الابناء',
      HeirType.sonsSon: 'ابناء الابن',
      HeirType.sonsDaughter: 'بنات الابن',
      HeirType.fullSister: 'الأخوات الشقيقات',
      HeirType.paternalSister: 'الأخوات لأب',
      HeirType.maternalSiblings: 'الأخوة لأم',
      HeirType.fullBrother: 'الأخوة الأشقاء',
      HeirType.paternalBrother:'الأخوة لأب',
      HeirType.fullBrothersSon:'ابناء الأخوة الأشقاء',
      HeirType.paternalBrothersSon:'ابناء الأخوة لأب',
      HeirType.fullUncle:'الأعمام الأشقاء',
      HeirType.paternalUncle:'الأعمام لأب',
      HeirType.fullCousin:'أبناء العم الشقيق',
      HeirType.paternalCousin:'أبناء العم لأب',
    };

    return pluralMap[this] ?? '$heirName (متعدد)';
  }
}


class InheritanceState {
  int? count;
  double? extra;
  String? heirName;
  HeirType? heirType;
  double? baseValue;
  bool? isHeirSingle;
  bool? isMotherPresent;

  InheritanceState({
    this.count,
    this.heirName,
    this.heirType,
    this.extra = 1.0,
    this.baseValue = 0.0,
    this.isHeirSingle,
    this.isMotherPresent = false,
  });


  final Map<String, HeirProcessor> heirsItems = {};
  final Map<String, String> heirsDetails = {};
  final Map<String, bool> heirsDone = {};
  final List<DataItems> dataset = [];

  static const List<int> _pal = [
    0xFFF2387C, // Light Pink
    0xFF05C7F2, // Sky Blue
    0xFF04D9C4, // Teal
    0xFFF2B705, // Yellow
    0xFFF26241, // Dark Red
    0xFFF25241 // Red
  ];

  void reset() {
    isMotherPresent = false;
    extra = 1.0;
    baseValue = 0.0;
    dataset.clear();
    heirsDone.clear();
    heirsItems.clear();
    heirsDetails.clear();
  }


  bool hasHeir(HeirType type) => heirsItems.containsKey(type.heirName);

  bool hasBranch() {
    return hasHeir(HeirType.daughter) || hasHeir(HeirType.son);
  }

  void addHeir(String heirName, String discription, double share, int colorIndex, int count) {
    if (!heirsDone.containsKey(heirName)) {
      addDetails(heirName, discription);
      extra = extra! - share;
      dataset.add(DataItems(share, '${count.toString()} من $heirName', Color(_pal[colorIndex])));
      heirsDone[heirName] = true;
    }
  }

  void addDetails(String heirName, String discription) {
    heirsDetails[heirName] = discription;
  }

  int isCount(HeirType heirType) {
    final heirCount = heirsItems[heirType.heirName]!.count;
    return heirCount;
  }

  void markMotherPresent() =>
    isMotherPresent = true;


  void updateExtra() {
    baseValue = 0.16;
    extra = extra! - baseValue!;
  }
}