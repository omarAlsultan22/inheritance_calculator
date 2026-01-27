import 'heir_processor_model.dart';
import '../../core/enums/heir_type.dart';
import '../../data/models/data_model.dart';
import 'package:men/core/constants/colors_constants.dart';


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
  final List<ItemModel> heirsData = [];


  void reset() {
    isMotherPresent = false;
    extra = 1.0;
    baseValue = 0.0;
    heirsData.clear();
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

      _updateExtra(share);

      if (heirsCount != null && heirsCount > 1) {
        heirsData.add(ItemModel(amount: share,
            title: '${heirsCount.toString()} من $heirName',
            color: ColorsConstants.getColor(colorIndex)));
      }
      else {
        heirsData.add(ItemModel(
            amount: share,
            title: heirName,
            color: ColorsConstants.getColor(colorIndex)));
      }
      heirsDone[heirName] = true;
    }
  }


  void _updateExtra(double share){
    var totalShare = extra;
    totalShare = totalShare! - share;
    extra = totalShare;
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