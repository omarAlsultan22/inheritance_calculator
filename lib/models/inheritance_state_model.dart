import 'dart:ui';
import 'data_model.dart';
import '../shared/constants/heir_type.dart';
import 'package:men/models/heir_processor_model.dart';


class InheritanceState {
  int? count;
  double? extra;
  String? heirName;
  HeirType? heirType;
  double? baseValue;
  bool? isHeirSingle;
  bool? isMotherPresent;
  Map<String, HeirProcessor>? heirsItems;

  InheritanceState({
    this.count,
    this.heirName,
    this.heirType,
    this.heirsItems,
    this.extra = 1.0,
    this.baseValue = 0.0,
    this.isHeirSingle,
    this.isMotherPresent = false,
  });


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
    heirsItems!.clear();
    heirsDetails.clear();
  }


  bool hasHeir(HeirType type) => heirsItems!.containsKey(type.heirName);

  bool hasBranch() {
    return hasHeir(HeirType.daughter) || hasHeir(HeirType.son);
  }

  void addHeir(String heirName, String discription, double share, int colorIndex, int? heirsCount) {
    if (!heirsDone.containsKey(heirName)) {
      addDetails(heirName, discription);

      var totalShare = extra;
      totalShare = totalShare! - share;
      extra = totalShare;

      if(heirsCount != null && heirsCount > 1){
        dataset.add(DataItems(share, '${heirsCount.toString()} من $heirName', Color(_pal[colorIndex])));
      }
      else{
        dataset.add(DataItems(share, heirName, Color(_pal[colorIndex])));
      }
      heirsDone[heirName] = true;
    }
  }

  void addDetails(String heirName, String discription) {
    heirsDetails[heirName] = discription;
  }

  int isCount(HeirType heirType) {
    final heirCount = heirsItems![heirType.heirName]!.count;
    return heirCount;
  }

  void markMotherPresent() =>
    isMotherPresent = true;


  void updateExtra() {
    baseValue = 0.16;
    extra = extra! - baseValue!;
  }
}