import 'states_subsidiary_heirs.dart';
import '../../../shared/constants/heir_type.dart';
import 'package:men/shared/constants/shares.dart';
import '../../../models/heir_processor_model.dart';
import '../../../models/rule_application_model.dart';
import '../../../models/inheritance_state_model.dart';
import '../rule_application_module/blocked_application.dart';
import '../rule_application_module/inheriting_application.dart';

class ColorsNumbers{
  static const int zero = 0;
  static const int one = 1;
  static const int tow = 2;
  static const int there = 3;
  static const int four = 4;
  static const int five = 5;
}

class HusbandProcessor extends HeirProcessor {
  HusbandProcessor({super.state, required super.heirType});

  @override
  RuleApplication getResult() {
    if (shouldBlock(state!)) {
      return InheritingApplication(
          description: "يرث الزوج الربع في حالة وجود فرع وارث ذكر أو أنثي",
          heirName: heirName,
          share: Shares.quarter,
          colorIndex: ColorsNumbers.zero
      );
    }
    return InheritingApplication(
        description: "يرث الزوج النصف في حالة عدم وجود فرع وارث ذكر أو أنثي",
        heirName: heirName,
        share: Shares.hafe,
        colorIndex: ColorsNumbers.zero
    );
  }

  @override
  String get heirName => heirType.heirName;

  @override
  bool shouldBlock(InheritanceState state) {
    return state.hasBranch();
  }
}


class WifeProcessor extends HeirProcessor {
  WifeProcessor({super.state, super.count, required super.heirType});

  @override
  RuleApplication getResult() {
    if (shouldBlock(state!)) {
      return InheritingApplication(
          count: count,
          description: "ترث $heirName الثمن في حالة وجود فرع وارث ذكر أو أنثي",
          heirName: heirName,
          share: Shares.eighth,
          colorIndex: ColorsNumbers.zero
      );
    }
    return InheritingApplication(
        count: count,
        description: "ترث $heirName الربع في حالة عدم وجود فرع وارث ذكر أو أنثي",
        heirName: heirName,
        share: Shares.quarter,
        colorIndex: ColorsNumbers.zero
    );
  }

  @override
  String get heirName =>
      isSingle ? heirType.heirName : heirType.getPluralName(count);

  @override
  bool shouldBlock(InheritanceState state) {
    return state.hasBranch();
  }
}


class FatherProcessor extends HeirProcessor {
  FatherProcessor({super.state, required super.heirType});

  @override
  RuleApplication getResult() {
    final calculator = FatherAndGrandfatherInheritanceCalculator(
        _createContext());
    final result = calculator.calculate();

    _applyUpdates(calculator.update);

    return InheritingApplication(
        description: result.description,
        heirName: heirName,
        share: result.share,
        colorIndex: ColorsNumbers.one
    );
  }


  InheritanceState _createContext() {
    return InheritanceState(
      extra: state!.extra,
      baseValue: state!.baseValue,
      heirsItems: state!.heirsItems,
      isMotherPresent: state!.isMotherPresent,
    );
  }

  void _applyUpdates(InheritanceUpdate update) {
    if (update.extraAdjustment != 0.0) {
      state!.updateExtra(); //
    }

    if (update.markMotherPresent) {
      state!.markMotherPresent();
    }
  }

  @override
  // TODO: implement heirName
  String get heirName => heirType.heirName;
}


class MotherProcessor extends HeirProcessor {
  MotherProcessor({super.state, required super.heirType});

  static const _blockingHeirs = [
    HeirType.son,
    HeirType.daughter,
    HeirType.fullSister,
    HeirType.sonsSon,
    HeirType.sonsDaughter,
    HeirType.fullBrother,
    HeirType.paternalSister
  ];

  @override
  RuleApplication getResult() {
    if (shouldBlock(state!)) {
      return InheritingApplication(
          description: "ترث $heirName السدس في وجود فرع وارث الابن أو ابن الابن أو البنت أو بنت الابن أو أخوة",
          heirName: heirName,
          share: Shares.sixth,
          colorIndex: ColorsNumbers.tow
      );
    }
    final calculator = MotherInheritanceCalculator(
        _createContext());
    final result = calculator.calculate();


    return InheritingApplication(
        description: result.description,
        heirName: heirName,
        share: result.share,
        colorIndex: ColorsNumbers.tow
    );
  }

  InheritanceState _createContext() {
    return InheritanceState(
      extra: state!.extra,
      baseValue: state!.baseValue,
      heirsItems: state!.heirsItems,
      isMotherPresent: state!.isMotherPresent,
    );
  }

  @override
  // TODO: implement heirName
  String get heirName => heirType.heirName;

  @override
  bool shouldBlock(InheritanceState state) {
    for (final heir in _blockingHeirs) {
      if (state.hasHeir(heir)) return true;
    }
    return false;
  }
}


class GrandfatherProcessor extends HeirProcessor {
  GrandfatherProcessor({super.state, required super.heirType});

  @override
  RuleApplication getResult() {
    if (shouldBlock(state!)) {
      return BlockedApplication(
          heirName: heirName,
          description: "يحجب $heirName بالأصل الوارث الذي يسبقه وهو الأب"
      );
    }

    final calculator = FatherAndGrandfatherInheritanceCalculator(
        _createContext());
    final result = calculator.calculate();

    _applyUpdates(calculator.update);

    return InheritingApplication(
        description: result.description,
        heirName: heirName,
        share: result.share,
        colorIndex: ColorsNumbers.one
    );
  }

  InheritanceState _createContext() {
    return InheritanceState(
      extra: state!.extra,
      baseValue: state!.baseValue,
      heirsItems: state!.heirsItems,
      isMotherPresent: state!.isMotherPresent,
    );
  }

  void _applyUpdates(InheritanceUpdate update) {
    if (update.extraAdjustment != 0.0) {
      state!.updateExtra(); //
    }

    if (update.markMotherPresent) {
      state!.markMotherPresent();
    }
  }

  @override
  // TODO: implement heirName
  String get heirName => heirType.heirName;

  @override
  bool shouldBlock(InheritanceState state) {
    if (state.hasHeir(HeirType.father)) return true;
    return false;
  }
}


class PaternalGrandmotherProcessor extends HeirProcessor {
  PaternalGrandmotherProcessor({super.state, required super.heirType});

  static const List<HeirType> _blockingHeirs = [
    HeirType.father, HeirType.mother
  ];

  @override
  RuleApplication getResult() {
    if (shouldBlock(state!)) {
      return BlockedApplication(
          heirName: heirName,
          description: "تحجب الجدة لأب في حضور الأم والأصل الوارث وهو الأب"
      );
    }

    final calculator = PaternalGrandmotherInheritanceCalculator(
        _createContext());
    final result = calculator.calculate();


    return InheritingApplication(
        description: result.description,
        heirName: heirName,
        share: result.share,
        colorIndex: ColorsNumbers.one
    );
  }

  InheritanceState _createContext() {
    return InheritanceState(
      extra: state!.extra,
      baseValue: state!.baseValue,
      heirsItems: state!.heirsItems,
      isMotherPresent: state!.isMotherPresent,
    );
  }


  @override
  // TODO: implement heirName
  String get heirName => heirType.heirName;

  @override
  bool shouldBlock(InheritanceState state) {
    for (final heir in _blockingHeirs) {
      if (state.hasHeir(heir)) return true;
    }
    return false;
  }
}


class MaternalGrandmotherProcessor extends HeirProcessor {
  MaternalGrandmotherProcessor({super.state, required super.heirType});

  static const List<HeirType> _blockingHeirs = [
    HeirType.father, HeirType.mother
  ];

  @override
  RuleApplication getResult() {
    if (shouldBlock(state!)) {
      return BlockedApplication(
          heirName: heirName,
          description: "تحجب الجدة لأم في حضور الأم والأصل الوارث وهو الأب"
      );
    }

    final calculator = MaternalGrandmotherInheritanceCalculator(
        _createContext());
    final result = calculator.calculate();


    return InheritingApplication(
        description: result.description,
        share: result.share,
        heirName: heirName,
        colorIndex: ColorsNumbers.tow
    );
  }

  InheritanceState _createContext() {
    return InheritanceState(
      extra: state!.extra,
      baseValue: state!.baseValue,
      heirsItems: state!.heirsItems,
      isMotherPresent: state!.isMotherPresent,
    );
  }

  @override
  // TODO: implement heirName
  String get heirName => heirType.heirName;

  @override
  bool shouldBlock(InheritanceState state) {
    for (final heir in _blockingHeirs) {
      if (state.hasHeir(heir)) return true;
    }
    return false;
  }
}


class DaughterProcessor extends HeirProcessor {
  DaughterProcessor({super.state, super.count, required super.heirType});

  @override
  RuleApplication getResult() {
    final calculator = DaughterInheritanceCalculator(
        _createContext());
    final result = calculator.calculate();


    return InheritingApplication(
        count: count,
        description: result.description,
        heirName: heirName,
        share: result.share,
        colorIndex: ColorsNumbers.four
    );
  }

  InheritanceState _createContext() {
    return InheritanceState(
      count: count,
      heirName: heirName,
      extra: state!.extra,
      isHeirSingle: isSingle,
      baseValue: state!.baseValue,
      heirsItems: state!.heirsItems,
      isMotherPresent: state!.isMotherPresent,
    );
  }

  @override
  // TODO: implement heirName
  String get heirName => isSingle ? heirType.heirName : heirType.getPluralName(count);
}


class SonsDaughterProcessor extends HeirProcessor {
  SonsDaughterProcessor({super.state, super.count, required super.heirType});


  @override
  RuleApplication getResult() {
    if (shouldBlock(state!)) {
      return BlockedApplication(
          heirName: heirName,
          description: "تحجب بنت الابن بوجود الابن"
      );
    }

    final calculator = SonsDaughterInheritanceCalculator(
        _createContext());
    final result = calculator.calculate();


    return InheritingApplication(
        count: count,
        description: result.description,
        heirName: heirName,
        share: result.share,
        colorIndex: ColorsNumbers.four
    );
  }

  InheritanceState _createContext() {
    return InheritanceState(
      heirName: heirName,
      extra: state!.extra,
      isHeirSingle: isSingle,
      baseValue: state!.baseValue,
      heirsItems: state!.heirsItems,
      isMotherPresent: state!.isMotherPresent,
    );
  }

  @override
  // TODO: implement heirName
  String get heirName =>
      isSingle ? heirType.heirName : heirType.getPluralName(count);

  @override
  bool shouldBlock(InheritanceState state) {
    if (state.hasHeir(HeirType.son)) return true;
    return false;
  }
}


class FullSisterProcessor extends HeirProcessor{
  FullSisterProcessor({super.state, super.count, required super.heirType});

  static const _blockingHeirs = [
    HeirType.son, HeirType.sonsSon,
    HeirType.father, HeirType.grandfather
  ];

  @override
  RuleApplication getResult() {
    if (shouldBlock(state!)) {
      return BlockedApplication(
          heirName: heirName,
          description: "تحجب الأخت الشقيقة في حضور الفرع الوارث او الأصل الوارث من الذكور"
      );
    }

    final calculator = FullSisterInheritanceCalculator(
        _createContext());
    final result = calculator.calculate();


    return InheritingApplication(
        count: count,
        description: result.description,
        heirName: heirName,
        share: result.share,
        colorIndex: ColorsNumbers.four
    );
  }

  InheritanceState _createContext() {
    return InheritanceState(
      heirName: heirName,
      extra: state!.extra,
      isHeirSingle: isSingle,
      baseValue: state!.baseValue,
      heirsItems: state!.heirsItems,
      isMotherPresent: state!.isMotherPresent,
    );
  }

  @override
  // TODO: implement heirName
  String get heirName => isSingle ? heirType.heirName : heirType.getPluralName(count);


  @override
  bool shouldBlock(InheritanceState state) {
    for (final heir in _blockingHeirs) {
      if (state.hasHeir(heir)) return true;
    }
    return false;
  }
}


class PaternalSisterProcessor extends HeirProcessor{
  PaternalSisterProcessor({super.state, super.count, required super.heirType});

  static const _blockingHeirs = [
    HeirType.son, HeirType.sonsSon,
    HeirType.father, HeirType.grandfather,
  ];

  @override
  RuleApplication getResult() {
    if (shouldBlock(state!)) {
      return BlockedApplication(
          heirName: heirName,
          description: "تحجب الأخت لأب في وجود الفرع الوارث او الأصل الوارث من الذكور أو في حالة البنت والأخت الشقيقة مجتميعن"
      );
    }

    final calculator = PaternalSisterInheritanceCalculator(_createContext());
    final result = calculator.calculate();


    return InheritingApplication(
        count: count,
        description: result.description,
        heirName: heirName,
        share: result.share,
        colorIndex: ColorsNumbers.four
    );
  }


  InheritanceState _createContext() {
    return InheritanceState(
      heirName: heirName,
      extra: state!.extra,
      isHeirSingle: isSingle,
      baseValue: state!.baseValue,
      heirsItems: state!.heirsItems,
      isMotherPresent: state!.isMotherPresent,
    );
  }

  @override
  // TODO: implement heirName
  String get heirName => isSingle ? heirType.heirName : heirType.getPluralName(count);


  @override
  bool shouldBlock(InheritanceState state) {
    for (final heir in _blockingHeirs) {
      if (state.hasHeir(heir)) return true;
      if(state.hasHeir(HeirType.daughter) && state.hasHeir(HeirType.fullSister)) return true;
    }
    return false;
  }
}


class MaternalSiblingsProcessor extends HeirProcessor {
  MaternalSiblingsProcessor({super.state, super.count, required super.heirType});

  static const _blockingHeirs = [
    HeirType.son, HeirType.daughter, HeirType.father,
    HeirType.grandfather, HeirType.sonsSon,
    HeirType.sonsDaughter
  ];

  @override
  RuleApplication getResult() {
    if (shouldBlock(state!)) {
      return BlockedApplication(
          heirName: heirName,
          description: "يحجب $heirName في حضور الابن أو ابن الابن أو البنت أو بنت الابن أو الأب أو الجد"
      );
    }

    final share = isSingle ? Shares.sixth : Shares.third;
    final description = isSingle
        ? "يرث $heirName السدس في حالة عدم أصل أو فرع وارث"
        : "يرث $heirName الثلث في حالة عدم أصل أو فرع وارث";

    return InheritingApplication(
      colorIndex: ColorsNumbers.four,
      heirName: heirName,
      share: share,
      count: count,
      description: description,
    );
  }

  @override
  // TODO: implement heirName
  String get heirName => isSingle ? heirType.heirName : heirType.getPluralName(count);

  @override
  bool shouldBlock(InheritanceState state) {
    for (final heir in _blockingHeirs) {
      if (state.hasHeir(heir)) return true;
    }
    return false;
  }
}


class SonProcessor extends HeirProcessor {
  SonProcessor({super.state, super.count, required super.heirType});

  @override
  RuleApplication getResult() {
    return InheritingApplication(
      colorIndex: ColorsNumbers.five,
      heirName: heirName,
      share: state!.extra,
      count: count,
      description: "يرث $heirName بالتعصيب باقي التركة",
    );
  }

  @override
  // TODO: implement heirName
  String get heirName => isSingle ? heirType.heirName : heirType.getPluralName(count);
}


class SonsSonProcessor extends HeirProcessor{
  SonsSonProcessor({super.state, super.count, required super.heirType});

  @override
  RuleApplication getResult() {
    if (shouldBlock(state!)) {
      return BlockedApplication(
          heirName: heirName,
          description: "يحجب $heirName بحضور الابن"
      );
    }

    return InheritingApplication(
      colorIndex: ColorsNumbers.five,
      heirName: heirName,
      share: state!.extra,
      count: count,
      description: "يرث $heirName بالتعصيب باقي التركة",
    );
  }

  @override
  // TODO: implement heirName
  String get heirName => isSingle ? heirType.heirName : heirType.getPluralName(count);

  @override
  bool shouldBlock(InheritanceState state) {
    if (state.hasHeir(HeirType.son)) return true;
    return false;
  }
}


class  FullBrotherProcessor extends HeirProcessor {
  FullBrotherProcessor({super.state, super.count, required super.heirType});

  static const _blockingHeirs = [
    HeirType.son, HeirType.sonsSon, HeirType.father,
  ];

  @override
  RuleApplication getResult() {
    if (shouldBlock(state!)) {
      return BlockedApplication(
          heirName: heirName,
          description: "يحجب $heirName بحضور الابن أو ابن الابن أو الأب"
      );
    }

    return InheritingApplication(
      colorIndex: ColorsNumbers.five,
      heirName: heirName,
      share: state!.extra,
      count: count,
      description: "يرث $heirName بالتعصيب باقي التركة",
    );
  }

  @override
  // TODO: implement heirName
  String get heirName => isSingle ? heirType.heirName : heirType.getPluralName(count);

  @override
  bool shouldBlock(InheritanceState state) {
    for (final heir in _blockingHeirs) {
      if (state.hasHeir(heir)) return true;
    }
    return false;
  }
}


class PaternalBrotherProcessor extends HeirProcessor{
  PaternalBrotherProcessor({super.state, super.count, required super.heirType});

  static const _blockingHeirs = [
    HeirType.son, HeirType.sonsSon, HeirType.father,
    HeirType.fullBrother
  ];

  @override
  RuleApplication getResult() {
    if (shouldBlock(state!)) {
      return BlockedApplication(
          heirName: heirName,
          description: "يحجب الأخ لأب بحضور الابن أو ابن الابن أو الأب أو الأخ الشقيق"
      );
    }

    return InheritingApplication(
      colorIndex: ColorsNumbers.five,
      heirName: heirName,
      share: state!.extra,
      count: count,
      description: "يرث $heirName لأب بالتعصيب باقي التركة",
    );
  }

  @override
  // TODO: implement heirName
  String get heirName => isSingle ? heirType.heirName : heirType.getPluralName(count);

  @override
  bool shouldBlock(InheritanceState state) {
    for (final heir in _blockingHeirs) {
      if (state.hasHeir(heir)) return true;
    }
    return false;
  }
}


class  FullBrothersSonProcessor extends HeirProcessor{
  FullBrothersSonProcessor({super.state, super.count, required super.heirType});

  static const _blockingHeirs = [
    HeirType.son, HeirType.sonsSon, HeirType.father,
  ];

  @override
  RuleApplication getResult() {
    if (shouldBlock(state!)) {
      return BlockedApplication(
          heirName: heirName,
          description: "يحجب ابن الأخ الشقيق بحضور الأخ الشقيق الابن أو ابن الابن أو الأب"
      );
    }

    return InheritingApplication(
      colorIndex: ColorsNumbers.five,
      heirName: heirName,
      share: state!.extra,
      count: count,
      description: "يرث $heirName بالتعصيب باقي التركة",
    );
  }

  @override
  // TODO: implement heirName
  String get heirName => isSingle ? heirType.heirName : heirType.getPluralName(count);

  @override
  bool shouldBlock(InheritanceState state) {
    for (final heir in _blockingHeirs) {
      if (state.hasHeir(heir)) return true;
    }
    return false;
  }
}

class PaternalBrothersSonProcessor extends HeirProcessor {
  PaternalBrothersSonProcessor({super.state, super.count, required super.heirType});

  static const _blockingHeirs = [
    HeirType.son, HeirType.sonsSon, HeirType.father,
    HeirType.fullBrothersSon
  ];

  @override
  RuleApplication getResult() {
    if (shouldBlock(state!)) {
      return BlockedApplication(
          heirName: heirName,
          description: "يحجب ابن الأخ لأب بحضور الابن أو ابن الابن أو الأب أو الأخ الشقيق"
      );
    }

    return InheritingApplication(
      colorIndex: ColorsNumbers.five,
      heirName: heirName,
      share: state!.extra,
      count: count,
      description: "يرث $heirName الأخوة لأب بالتعصيب باقي التركة",
    );
  }

  @override
  // TODO: implement heirName
  String get heirName => isSingle ? heirType.heirName : heirType.getPluralName(count);

  @override
  bool shouldBlock(InheritanceState state) {
    for (final heir in _blockingHeirs) {
      if (state.hasHeir(heir)) return true;
    }
    return false;
  }
}


class FullUncleProcessor extends HeirProcessor {
  FullUncleProcessor({super.state, super.count, required super.heirType});

  static const _blockingHeirs = [
    HeirType.son, HeirType.sonsSon, HeirType.father,
    HeirType.fullBrothersSon, HeirType.paternalBrothersSon,
  ];

  @override
  RuleApplication getResult() {
    if (shouldBlock(state!)) {
      return BlockedApplication(
          heirName: heirName,
          description: "يحجب العم الشقيق بحضور الابن أو ابن الابن أو الأب أو الأخ الشقيق أو الأخ لأب"
      );
    }

    return InheritingApplication(
      colorIndex: ColorsNumbers.five,
      heirName: heirName,
      share: state!.extra,
      count: count,
      description: "يرث $heirName الأشقاء بالتعصيب باقي التركة",
    );
  }

  @override
  // TODO: implement heirName
  String get heirName => isSingle ? heirType.heirName : heirType.getPluralName(count);

  @override
  bool shouldBlock(InheritanceState state) {
    for (final heir in _blockingHeirs) {
      if (state.hasHeir(heir)) return true;
    }
    return false;
  }
}


class PaternalUncleProcessor extends HeirProcessor {
  PaternalUncleProcessor({super.state, super.count, required super.heirType});

  static const _blockingHeirs = [
    HeirType.son, HeirType.sonsSon, HeirType.father,
    HeirType.fullBrothersSon, HeirType.paternalBrothersSon,
    HeirType.fullUncle
  ];

  @override
  RuleApplication getResult() {
    if (shouldBlock(state!)) {
      return BlockedApplication(
          heirName: heirName,
          description: "يحجب العم لأب بحضور الابن أو ابن الابن أو الأب أو الأخ الشقيق أو الأخ لأب أو العم الشقيق"
      );
    }

    return InheritingApplication(
        colorIndex: ColorsNumbers.five,
        heirName: heirName,
        share: state!.extra,
        description: "يرث $heirName لأب بالتعصيب باقي التركة",
        count: count
    );
  }

  @override
  // TODO: implement heirName
  String get heirName => isSingle ? heirType.heirName : heirType.getPluralName(count);

  @override
  bool shouldBlock(InheritanceState state) {
    for (final heir in _blockingHeirs) {
      if (state.hasHeir(heir)) return true;
    }
    return false;
  }
}


class FullCousinProcessor extends HeirProcessor{
  FullCousinProcessor({super.state, super.count, required super.heirType});

  static const _blockingHeirs = [
    HeirType.son, HeirType.sonsSon, HeirType.father,
    HeirType.fullBrothersSon, HeirType.paternalBrothersSon,
    HeirType.fullUncle, HeirType.paternalUncle,
  ];

  @override
  RuleApplication getResult() {
    if (shouldBlock(state!)) {
      return BlockedApplication(
          heirName: heirName,
          description: "يحجب ابن العم الشقيق بحضور الابن أو ابن الابن أو الأب أو الأخ الشقيق أو الأخ لأب أو العم الشقيق أو العم لأب"
      );
    }

    return InheritingApplication(
        colorIndex: ColorsNumbers.five,
        heirName: heirName,
        share: state!.extra,
        description: "يرث $heirName العم الشقيق بالتعصيب باقي التركة",
        count: count
    );
  }

  @override
  // TODO: implement heirName
  String get heirName => isSingle ? heirType.heirName : heirType.getPluralName(count);

  @override
  bool shouldBlock(InheritanceState state) {
    for (final heir in _blockingHeirs) {
      if (state.hasHeir(heir)) return true;
    }
    return false;
  }
}


class PaternalCousinProcessor extends HeirProcessor {
  PaternalCousinProcessor({super.state, super.count, required super.heirType});

  static const _blockingHeirs = [
    HeirType.son, HeirType.sonsSon, HeirType.father,
    HeirType.fullBrothersSon, HeirType.paternalBrothersSon,
    HeirType.fullUncle, HeirType.paternalUncle,
    HeirType.fullCousin
  ];

  @override
  RuleApplication getResult() {
    if (shouldBlock(state!)) {
      return BlockedApplication(
          heirName: HeirType.paternalCousin.heirName,
          description: "يحجب ابن العم لأب بحضور الابن أو ابن الابن أو الأب أو الأخ الشقيق أو الأخ لأب أو العم الشقيق أو العم لأب أو ابن العم الشقيق"
      );
    }

    return InheritingApplication(
        description: "يرث $heirName العم لأب بالتعصيب باقي التركة",
        colorIndex: ColorsNumbers.five,
        share: state!.extra,
        heirName: heirName,
        count: count
    );
  }

  @override
  String get heirName => isSingle ? heirType.heirName : heirType.getPluralName(count);

  @override
  bool shouldBlock(InheritanceState state) {
    for (final heir in _blockingHeirs) {
      if (state.hasHeir(heir)) return true;
    }
    return false;
  }
}


