import 'heir_processor_model.dart';
import 'inheritance_state_model.dart';
import 'package:men/models/rule_application_model.dart';
import 'package:men/models/blocked_application_model.dart';
import 'package:men/models/inheriting_application_model.dart';
import 'package:men/models/inheritance_calculator_model.dart';


class HusbandProcessor extends HeirProcessor {
  HusbandProcessor({super.state});

  @override
  RuleApplication getResult() {
    if (shouldBlock(state!)) {
      return InheritingApplication(
          description: "يرث الزوج الربع في حالة وجود فرع وارث ذكر أو أنثي",
          heirName: heirName,
          share: 0.25,
          colorIndex: 0
      );
    }
    return InheritingApplication(
        description: "يرث الزوج النصف في حالة عدم وجود فرع وارث ذكر أو أنثي",
        heirName: heirName,
        share: 0.5,
        colorIndex: 0
    );
  }

  @override
  String get heirName => HeirType.husband.heirName;

  @override
  bool shouldBlock(InheritanceState state) {
    return state.hasBranch();
  }
}


class WifeProcessor extends HeirProcessor {
  WifeProcessor({super.state, super.count});

  @override
  RuleApplication getResult() {
    if (shouldBlock(state!)) {
      return InheritingApplication(
          description: "ترث $heirName الثمن في حالة وجود فرع وارث ذكر أو أنثي",
          heirName: heirName,
          share: 0.125,
          colorIndex: 0,
          count: count
      );
    }
    return InheritingApplication(
        description: "ترث $heirName الربع في حالة عدم وجود فرع وارث ذكر أو أنثي",
        heirName: heirName,
        share: 0.25,
        colorIndex: 0,
        count: count
    );
  }

  @override
  String get heirName =>
      isSingle ? state!.heirType!.heirName : state!.heirType!.getPluralName(count);

  @override
  bool shouldBlock(InheritanceState state) {
    return state.hasBranch();
  }
}


class FatherProcessor extends HeirProcessor {
  FatherProcessor({super.state});

  @override
  RuleApplication getResult() {
    final calculator = FatherAndGrandfatherInheritanceCalculator(_createContext());
    final result = calculator.calculate();

    _applyUpdates(calculator.update);

    return InheritingApplication(
      description: result.description,
      heirName: heirName,
      share: result.share,
      colorIndex: 1,
    );
  }


  InheritanceState _createContext() {
    return InheritanceState(
      extra: state!.totalExtra,
      baseValue: state!.baseValue,
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
  String get heirName => heirType!.heirName;
}


class MotherProcessor extends HeirProcessor {
  MotherProcessor({super.state});

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
          share: 0.16,
          colorIndex: 2
      );
    }
    final calculator = MotherInheritanceCalculator(
        _createContext());
    final result = calculator.calculate();


    return InheritingApplication(
      description: result.description,
      heirName: heirName,
      share: result.share,
      colorIndex: 2,
    );
  }

  InheritanceState _createContext() {
    return InheritanceState(
      extra: state!.totalExtra,
      baseValue: state!.baseValue,
      isMotherPresent: state!.isMotherPresent,
    );
  }

  @override
  // TODO: implement heirName
  String get heirName => HeirType.mother.heirName;

  @override
  bool shouldBlock(InheritanceState state) {
    for (final heir in _blockingHeirs) {
      if (state.hasHeir(heir)) return true;
    }
    return false;
  }
}


class GrandfatherProcessor extends HeirProcessor {
  GrandfatherProcessor({super.state});

  @override
  RuleApplication getResult() {
    if (shouldBlock(state!)) {
      return BlockedApplication(
          heirName: heirName,
          description: "يحجب $heirName بالأصل الوارث الذي يسبقه وهو الأب"
      );
    }

    final calculator = FatherAndGrandfatherInheritanceCalculator(_createContext());
    final result = calculator.calculate();

    _applyUpdates(calculator.update);

    return InheritingApplication(
      description: result.description,
      heirName: heirName,
      share: result.share,
      colorIndex: 2,
    );
  }

  InheritanceState _createContext() {
    return InheritanceState(
      extra: state!.totalExtra,
      baseValue: state!.baseValue,
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
  String get heirName => HeirType.grandfather.heirName;

  @override
  bool shouldBlock(InheritanceState state) {
    if (state.hasHeir(HeirType.father)) return true;
    return false;
  }
}


class PaternalGrandmotherProcessor extends HeirProcessor {
  PaternalGrandmotherProcessor({super.state});

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

    final calculator = PaternalGrandmotherInheritanceCalculator(_createContext());
    final result = calculator.calculate();


    return InheritingApplication(
      description: result.description,
      heirName: heirName,
      share: result.share,
      colorIndex: 1,
    );
  }

  InheritanceState _createContext() {
    return InheritanceState(
      extra: state!.totalExtra,
      baseValue: state!.baseValue,
      isMotherPresent: state!.isMotherPresent,
    );
  }


  @override
  // TODO: implement heirName
  String get heirName => HeirType.paternalGrandMother.heirName;

  @override
  bool shouldBlock(InheritanceState state) {
    for (final heir in _blockingHeirs) {
      if (state.hasHeir(heir)) return true;
    }
    return false;
  }
}


class MaternalGrandmotherProcessor extends HeirProcessor {
  MaternalGrandmotherProcessor({super.state});

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
      colorIndex: 2,
    );
  }

  InheritanceState _createContext() {
    return InheritanceState(
      extra: state!.totalExtra,
      baseValue: state!.baseValue,
      isMotherPresent: state!.isMotherPresent,
    );
  }

  @override
  // TODO: implement heirName
  String get heirName => HeirType.mother.heirName;

  @override
  bool shouldBlock(InheritanceState state) {
    for (final heir in _blockingHeirs) {
      if (state.hasHeir(heir)) return true;
    }
    return false;
  }
}


class DaughterProcessor extends HeirProcessor {
  DaughterProcessor({super.state, super.count});

  late final heirType = state!.heirType;

  @override
  RuleApplication getResult() {

    final calculator = DaughterInheritanceCalculator(
        _createContext());
    final result = calculator.calculate();


    return InheritingApplication(
      description: result.description,
      heirName: heirName,
      share: result.share,
      colorIndex: 4,
      count: count
    );

  }

  InheritanceState _createContext() {
    return InheritanceState(
      count: count,
      heirName: heirName,
      extra: state!.totalExtra,
      isHeirSingle: isSingle,
      baseValue: state!.baseValue,
      isMotherPresent: state!.isMotherPresent,
    );
  }

  @override
  // TODO: implement heirName
  String get heirName => isSingle ? heirType!.heirName : heirType!.getPluralName(count);
}


class SonsDaughterProcessor extends HeirProcessor {
  SonsDaughterProcessor({super.state, super.count});


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
      description: result.description,
      heirName: heirName,
      share: result.share,
      colorIndex: 5,
      count: count
    );
  }

  InheritanceState _createContext() {
    return InheritanceState(
      heirName: heirName,
      extra: state!.totalExtra,
      isHeirSingle: isSingle,
      baseValue: state!.baseValue,
      isMotherPresent: state!.isMotherPresent,
    );
  }

  @override
  // TODO: implement heirName
  String get heirName =>
      isSingle ? heirType!.heirName : heirType!.getPluralName(count);

  @override
  bool shouldBlock(InheritanceState state) {
    if (state.hasHeir(HeirType.son)) return true;
    return false;
  }
}


class FullSisterProcessor extends HeirProcessor{
  FullSisterProcessor({super.state, super.count});

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
        description: result.description,
        heirName: heirName,
        share: result.share,
        colorIndex: 5,
        count: count
    );
  }

  InheritanceState _createContext() {
    return InheritanceState(
      heirName: heirName,
      extra: state!.totalExtra,
      isHeirSingle: isSingle,
      baseValue: state!.baseValue,
      isMotherPresent: state!.isMotherPresent,
    );
  }

  @override
  // TODO: implement heirName
  String get heirName => isSingle ? heirType!.heirName : heirType!.getPluralName(count);


  @override
  bool shouldBlock(InheritanceState state) {
    for (final heir in _blockingHeirs) {
      if (state.hasHeir(heir)) return true;
    }
    return false;
  }
}


class PaternalSisterProcessor extends HeirProcessor{
  PaternalSisterProcessor({super.state, super.count});

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
        description: result.description,
        heirName: heirName,
        share: result.share,
        colorIndex: 3,
        count: count
    );
  }


  InheritanceState _createContext() {
    return InheritanceState(
      heirName: heirName,
      extra: state!.totalExtra,
      isHeirSingle: isSingle,
      baseValue: state!.baseValue,
      isMotherPresent: state!.isMotherPresent,
    );
  }

  @override
  // TODO: implement heirName
  String get heirName => isSingle ? heirType!.heirName : heirType!.getPluralName(count);


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
  MaternalSiblingsProcessor({super.state, super.count});

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

    final share = isSingle ? 0.16 : 0.33;
    final description = isSingle
        ? "يرث $heirName السدس في حالة عدم أصل أو فرع وارث"
        : "يرث $heirName الثلث في حالة عدم أصل أو فرع وارث";

    return InheritingApplication(
      colorIndex: 5,
      heirName: heirName,
      share: share,
      count: count,
      description: description,
    );
  }

  @override
  // TODO: implement heirName
  String get heirName => isSingle ? heirType!.heirName : heirType!.getPluralName(count);

  @override
  bool shouldBlock(InheritanceState state) {
    for (final heir in _blockingHeirs) {
      if (state.hasHeir(heir)) return true;
    }
    return false;
  }
}


class SonProcessor extends HeirProcessor {
  SonProcessor({super.state, super.count});

  @override
  RuleApplication getResult() {
    return InheritingApplication(
      colorIndex: 5,
      heirName: heirName,
      share: state!.totalExtra,
      count: count,
      description: "يرث $heirName بالتعصيب باقي التركة",
    );
  }

  @override
  // TODO: implement heirName
  String get heirName => isSingle ? heirType!.heirName : heirType!.getPluralName(count);
}


class SonsSonProcessor extends HeirProcessor{
  SonsSonProcessor({super.state, super.count});

  @override
  RuleApplication getResult() {
    if (shouldBlock(state!)) {
      return BlockedApplication(
          heirName: heirName,
          description: "يحجب $heirName بحضور الابن"
      );
    }

    return InheritingApplication(
      colorIndex: 5,
      heirName: heirName,
      share: state!.totalExtra,
      count: count,
      description: "يرث $heirName بالتعصيب باقي التركة",
    );
  }

  @override
  // TODO: implement heirName
  String get heirName => isSingle ? heirType!.heirName : heirType!.getPluralName(count);

  @override
  bool shouldBlock(InheritanceState state) {
    if (state.hasHeir(HeirType.son)) return true;
    return false;
  }
}


class  FullBrotherProcessor extends HeirProcessor {
  FullBrotherProcessor({super.state, super.count});

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
      colorIndex: 5,
      heirName: heirName,
      share: state!.totalExtra,
      count: count,
      description: "يرث $heirName بالتعصيب باقي التركة",
    );
  }

  @override
  // TODO: implement heirName
  String get heirName => isSingle ? heirType!.heirName : heirType!.getPluralName(count);

  @override
  bool shouldBlock(InheritanceState state) {
    for (final heir in _blockingHeirs) {
      if (state.hasHeir(heir)) return true;
    }
    return false;
  }
}


class PaternalBrotherProcessor extends HeirProcessor{
  PaternalBrotherProcessor({super.state, super.count});

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
      colorIndex: 5,
      heirName: heirName,
      share: state!.totalExtra,
      count: count,
      description: "يرث $heirName لأب بالتعصيب باقي التركة",
    );
  }

  @override
  // TODO: implement heirName
  String get heirName => isSingle ? heirType!.heirName : heirType!.getPluralName(count);

  @override
  bool shouldBlock(InheritanceState state) {
    for (final heir in _blockingHeirs) {
      if (state.hasHeir(heir)) return true;
    }
    return false;
  }
}


class  FullBrothersSonProcessor extends HeirProcessor{
  FullBrothersSonProcessor({super.state, super.count});

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
      colorIndex: 5,
      heirName: heirName,
      share: state!.totalExtra,
      count: count,
      description: "يرث $heirName بالتعصيب باقي التركة",
    );
  }

  @override
  // TODO: implement heirName
  String get heirName => isSingle ? heirType!.heirName : heirType!.getPluralName(count);

  @override
  bool shouldBlock(InheritanceState state) {
    for (final heir in _blockingHeirs) {
      if (state.hasHeir(heir)) return true;
    }
    return false;
  }
}

class PaternalBrothersSonProcessor extends HeirProcessor {
  PaternalBrothersSonProcessor({super.state, super.count});

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
      colorIndex: 5,
      heirName: heirName,
      share: state!.totalExtra,
      count: count,
      description: "يرث $heirName الأخوة لأب بالتعصيب باقي التركة",
    );
  }

  @override
  // TODO: implement heirName
  String get heirName => isSingle ? heirType!.heirName : heirType!.getPluralName(count);

  @override
  bool shouldBlock(InheritanceState state) {
    for (final heir in _blockingHeirs) {
      if (state.hasHeir(heir)) return true;
    }
    return false;
  }
}


class FullUncleProcessor extends HeirProcessor {
  FullUncleProcessor({super.state, super.count});

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
      colorIndex: 5,
      heirName: heirName,
      share: state!.totalExtra,
      count: count,
      description: "يرث $heirName الأشقاء بالتعصيب باقي التركة",
    );
  }

  @override
  // TODO: implement heirName
  String get heirName => isSingle ? heirType!.heirName : heirType!.getPluralName(count);

  @override
  bool shouldBlock(InheritanceState state) {
    for (final heir in _blockingHeirs) {
      if (state.hasHeir(heir)) return true;
    }
    return false;
  }
}


class PaternalUncleProcessor extends HeirProcessor {
  PaternalUncleProcessor({super.state, super.count});

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
      colorIndex: 5,
      heirName: heirName,
      share: state!.totalExtra,
      description: "يرث $heirName لأب بالتعصيب باقي التركة",
      count: count
    );
  }

  @override
  // TODO: implement heirName
  String get heirName => isSingle ? heirType!.heirName : heirType!.getPluralName(count);

  @override
  bool shouldBlock(InheritanceState state) {
    for (final heir in _blockingHeirs) {
      if (state.hasHeir(heir)) return true;
    }
    return false;
  }
}


class FullCousinProcessor extends HeirProcessor{
  FullCousinProcessor({super.state, super.count});

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
      colorIndex: 5,
      heirName: heirName,
      share: state!.totalExtra,
      description: "يرث $heirName العم الشقيق بالتعصيب باقي التركة",
      count: count
    );
  }

  @override
  // TODO: implement heirName
  String get heirName => isSingle ? heirType!.heirName : heirType!.getPluralName(count);

  @override
  bool shouldBlock(InheritanceState state) {
    for (final heir in _blockingHeirs) {
      if (state.hasHeir(heir)) return true;
    }
    return false;
  }
}


class PaternalCousinProcessor extends HeirProcessor {
  PaternalCousinProcessor({super.state, super.count});

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
        heirName: heirName,
        colorIndex: 5,
        share: state!.totalExtra,
        count: count
    );
  }

  @override
  String get heirName => isSingle ? heirType!.heirName : heirType!.getPluralName(count);

  @override
  bool shouldBlock(InheritanceState state) {
    for (final heir in _blockingHeirs) {
      if (state.hasHeir(heir)) return true;
    }
    return false;
  }
}


