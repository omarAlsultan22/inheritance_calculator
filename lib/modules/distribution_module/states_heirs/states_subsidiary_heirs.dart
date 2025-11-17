import 'package:men/models/shares_model.dart';
import '../../../models/heir_type_model.dart';
import '../../../models/inheritance_result.dart';
import '../../../models/inheritance_state_model.dart';


class InheritanceUpdate {
  double extraAdjustment;
  bool markMotherPresent;

  InheritanceUpdate({
    this.extraAdjustment = 0.0,
    this.markMotherPresent = false,
  });
}


class FatherAndGrandfatherInheritanceCalculator{
  final InheritanceState _context;

  FatherAndGrandfatherInheritanceCalculator(this._context);

  final update = InheritanceUpdate();

  InheritanceResult calculate() {
    if (_hasMaleDescendant()) {
      return _calculateOneSixthShare();
    }
      return _calculateResidualShare();
    }

  bool _hasMaleDescendant() {
    return _context.heirsItems!.containsKey(HeirType.son.heirName) ||
        _context.heirsItems!.containsKey(HeirType.sonsSon.heirName);
  }

  InheritanceResult _calculateOneSixthShare() {
    return InheritanceResult(
        share: Shares.sixth,
        description: "يرث الأب السدس في وجود فرع وارث ذكر",
    );
  }

  InheritanceResult _calculateResidualShare() {

    update.extraAdjustment = 1.0;
    _getDaughtersShare();
    _getSonsDaughtersShare();
    _handleMotherPresence();

    return InheritanceResult(
        share: Shares.sixth + _context.extra!,
        description: _getResidualDescription(),
    );
  }

  String _getResidualDescription() {
    return _context.baseValue! > 1
        ? "يرث الأب السدس وتعصيب مع وجود فرع وارث أنثى"
        : "يرث الأب بالتعصيب في غياب الفرع الوارث";
  }

  bool _hasDaughter(){
    return _context.heirsItems!.containsKey(HeirType.daughter.heirName);
  }
  bool _hasSonsDaughter(){
    return _context.heirsItems!.containsKey(HeirType.sonsDaughter.heirName);
  }

  void _getDaughtersShare(){
    if(_hasDaughter()) {
      double totalShare = _context.extra!;
      final daughterCount = _context.heirsItems![HeirType.daughter.heirName]!.count;

      final isSingle = daughterCount < 2;

      final share = isSingle ? Shares.hafe : Shares.twoThirds;
      final finalShare = totalShare - share;

      _context.extra = finalShare;
    }
  }

  void _getSonsDaughtersShare() {
    if (_hasDaughter()) {
      double totalShare = _context.extra!;
      final finalShare = totalShare - Shares.sixth;
      _context.extra = finalShare;
      return;
    }

    if (_hasSonsDaughter()) {
      double totalShare = _context.extra!;
      final sonsDaughterCount = _context.heirsItems![HeirType.daughter.heirName]!.count;

      final isSingle = sonsDaughterCount < 2;

      final share = isSingle ? Shares.hafe : Shares.twoThirds;
      final finalShare = totalShare - share;

      _context.extra = finalShare;
    }
  }

  void _handleMotherPresence() {
    if (_context.heirsItems!.containsKey(HeirType.mother) && !_context.isMotherPresent!) {
      update.markMotherPresent = true;
    }
  }
}


class MotherInheritanceCalculator {
  final InheritanceState _context;

  MotherInheritanceCalculator(this._context);

  InheritanceResult calculate() {
    if (_hasSpouses()) {
      return CalculateShareRemainingThird();
    }
    return CalculateOneThirdShare();
  }

  bool _hasSpouses() {
    return _context.heirsItems!.containsKey(HeirType.husband.heirName) ||
        _context.heirsItems!.containsKey(HeirType.wife.heirName);
  }

  InheritanceResult CalculateShareRemainingThird() {
    return InheritanceResult(
        share: _context.extra! / 3,
        description: "ترث الأم ثلث الباقي في أحد العمرتين مع الأب وأحد الزوجين",
    );
  }

  InheritanceResult CalculateOneThirdShare() {
    return InheritanceResult(
        share: Shares.third,
        description: "ترث الأم الثلث في غياب الفرع الوراث ذكور واناث والأخوة الأشقاء ذكور واناث والأخت لأب",
    );
  }
}

class PaternalGrandmotherInheritanceCalculator {
  final InheritanceState _context;

  PaternalGrandmotherInheritanceCalculator(this._context);

  InheritanceResult calculate() {
    if (_hasMaternalGrandmother()) {
      return CalculateOneHalfSixthShare();
    }
    return _calculateOneSixthShare();
  }

  bool _hasMaternalGrandmother() {
    return _context.heirsItems!.containsKey(HeirType.maternalGrandmother.heirName);
  }

  InheritanceResult CalculateOneHalfSixthShare() {
    return InheritanceResult(
        share: Shares.thirtySecond,
        description: "ترث الجدة لأب مع الجدة لأم السدس في حالة غياب الأم والأب",
    );
  }

  InheritanceResult _calculateOneSixthShare() {
    return InheritanceResult(
        share: Shares.sixth,
        description: "ترث الجدة لأب السدس منفردة في حالة غياب الأب و الأم و الجدة لأم",
    );
  }
}


class MaternalGrandmotherInheritanceCalculator{
  final InheritanceState _context;

  MaternalGrandmotherInheritanceCalculator(this._context);

  InheritanceResult calculate() {
    if (_hasPaternalGrandmother()) {
      return CalculateOneHalfSixthShare();
    }
    return _calculateOneSixthShare();
  }

  bool _hasPaternalGrandmother() {
    return _context.heirsItems!.containsKey(HeirType.paternalGrandMother.heirName);
  }

  InheritanceResult CalculateOneHalfSixthShare() {
    return InheritanceResult(
        share: Shares.thirtySecond,
        description: "ترث الجدة لأم مع الجدة لأب السدس في حالة غياب الأم والأب",
    );
  }

  InheritanceResult _calculateOneSixthShare() {
    return InheritanceResult(
        share: Shares.sixth,
        description: "ترث الجدة لأم السدس منفردة في حالة غياب الأب و الأم و الجدة لأم",
    );
  }
}


class DaughterInheritanceCalculator{
  final InheritanceState _context;

  DaughterInheritanceCalculator(this._context);

  InheritanceResult calculate() {
    if (_hasSon()) {
      return _calculateOneShareInnervation();
    }
    return _calculateSpecifiedShare();
  }

  bool _hasSon() {
    return _context.heirsItems!.containsKey(HeirType.son.heirName);
  }

  InheritanceResult _calculateOneShareInnervation() {

    final sonsCount = _context.heirsItems![HeirType.son.heirName]!.count;
    final share = _context.extra! / (sonsCount * 2 + _context.count!);
    final totalShare = share * _context.count!;
    final heirName = _context.heirName;

    return InheritanceResult(
        share: totalShare,
        description: "ترث $heirName بالتعصيب في وجود المعصب لهم وهو الابن",
    );
  }

  InheritanceResult _calculateSpecifiedShare() {
    return InheritanceResult(
        share: getShare(),
        description: gerDescription(),
    );
  }

  String gerDescription(){
    return _context.isHeirSingle!
        ? "ترث البنت النصف في غياب المعصب لها وهو الابن"
        : "ترث البنات الثلثان في غياب المعصب لهم وهو الابن";
  }

  double getShare() {
    return _context.isHeirSingle! ? Shares.hafe : Shares.twoThirds;
  }
}


class SonsDaughterInheritanceCalculator {
  final InheritanceState _context;

  SonsDaughterInheritanceCalculator(this._context);

  InheritanceResult calculate() {
    if (_hasSonSon()) {
      return _calculateOneShareInnervation();
    }
    else if (_hasDaughter()) {
      return _calculateOneSixthShare();
    }
    return _calculateSpecifiedShare();
  }


  bool _hasSonSon() {
    return _context.heirsItems!.containsKey(HeirType.sonsSon.heirName);
  }

  bool _hasDaughter() {
    return _context.heirsItems!.containsKey(HeirType.daughter.heirName);
  }

  InheritanceResult _calculateOneShareInnervation() {
    final sonsCount = _context.heirsItems![HeirType.sonsSon.heirName]!.count;
    final share = _context.extra! / (sonsCount * 2 + _context.count!);
    final totalShare = share * _context.count!;
    final heirName = _context.heirName;

    return InheritanceResult(
        share: totalShare,
        description: "ترث $heirName بالتعصيب في وجود المعصب لها ابن الابن",
    );
  }

  InheritanceResult _calculateOneSixthShare() {
    final heirName = _context.heirName;

    return InheritanceResult(
      share: Shares.sixth,
      description: "ترث $heirName السدس في وجود البنت",
    );
  }

  InheritanceResult _calculateSpecifiedShare() {
    return InheritanceResult(
      share: getShare(),
      description: gerDescription(),
    );
  }

  String gerDescription() {
    return _context.isHeirSingle!
        ? "ترث بنت الابن النصف في غياب البنت و معصبها ابن الابن"
        : "ترث بنات الابن الثلثين في غياب البنت ومعصبهم ابن الابن";
  }

  double getShare() {
    return _context.isHeirSingle! ? Shares.hafe : Shares.twoThirds;
  }
}


class FullSisterInheritanceCalculator {
  final InheritanceState _context;

  FullSisterInheritanceCalculator(this._context);

  InheritanceResult calculate() {
    if (_hasFullBrother()) {
      return _calculateOneShareInnervation();
    }
    else if (_hasDaughter()) {
      return _calculateOneSixthShare();
    }
    return _calculateSpecifiedShare();
  }


bool _hasFullBrother() {
    return _context.heirsItems!.containsKey(HeirType.fullBrother.heirName);
  }

  bool _hasDaughter() {
    return _context.heirsItems!.containsKey(HeirType.daughter.heirName) ||
        _context.heirsItems!.containsKey(HeirType.sonsDaughter.heirName);
  }

  InheritanceResult _calculateOneShareInnervation() {
    final sonsCount = _context.heirsItems![HeirType.fullBrother.heirName]!.count;
    final share = _context.extra! / (sonsCount * 2 + _context.count!);
    final totalShare = share * _context.count!;
    final heirName = _context.heirName;

    return InheritanceResult(
        share: totalShare,
        description: "ترث $heirName بالتعصيب مع وجود المعصب لها الأخ الشقيق",
    );
  }

  InheritanceResult _calculateOneSixthShare() {
    final heirName = _context.heirName;

    return InheritanceResult(
        share: Shares.sixth,
        description: "ترث $heirName السدس في وجود فرع وارث انثي",
    );
  }

  InheritanceResult _calculateSpecifiedShare() {
    return InheritanceResult(
      share: getShare(),
      description: gerDescription(),
    );
  }

  String gerDescription() {
    return _context.isHeirSingle!
        ? "ترث الأخت الشقيقة النصف في غياب الأخ الشقيق والبنت"
        : "ترث الأخوات الشقيقات الثلثين في غياب الأخ الشقيق والبنت";
  }

  double getShare() {
    return _context.isHeirSingle! ? Shares.hafe : Shares.twoThirds;
  }
}


class PaternalSisterInheritanceCalculator {
  final InheritanceState _context;

  PaternalSisterInheritanceCalculator(this._context);

  InheritanceResult calculate() {
    if (_hasPaternalBrother()) {
      return _calculateOneShareInnervation();
    }
    else if (_hasFemale(HeirType.daughter)) {
      return _calculateOneSixthShare(
          "ترث ${_context.heirName} السدس في وجود البنت");
    }
    else if (_hasFemale(HeirType.fullSister)) {
      return _calculateOneSixthShare(
          "ترث ${_context.heirName} السدس في وجود الأخت الشقيقة");
    }
    return _calculateSpecifiedShare();
  }

bool _hasPaternalBrother() {
    return _context.hasHeir(HeirType.paternalBrother);
  }

  bool _hasFemale(HeirType heirType) {
    return _context.heirsItems!.containsKey(heirType.heirName);
  }

  InheritanceResult _calculateOneShareInnervation() {
    final sonsCount = _context.heirsItems![HeirType.paternalBrother.heirName]!.count;
    final share = _context.extra! / (sonsCount * 2 + _context.count!);
    final totalShare = share * _context.count!;
    final heirName = _context.heirName;

    return InheritanceResult(
        share: totalShare,
        description: "ترث $heirName بالتعصيب في وجود الأخ لأب",
    );
  }

  InheritanceResult _calculateOneSixthShare(String description) {
    return InheritanceResult(
        share: Shares.sixth,
        description: description,
    );
  }


  InheritanceResult _calculateSpecifiedShare() {
    return InheritanceResult(
      share: getShare(),
      description: gerDescription(),
    );
  }

  String gerDescription() {
    return _context.isHeirSingle!
        ? "ترث الأخت لأب النصف في غياب البنت والأخت الشقيقة"
        : "ترث الأخوات لأب الثلثين في غياب البنت والأخت الشقيقة";
  }

  double getShare() {
    return _context.isHeirSingle! ? Shares.hafe : Shares.twoThirds;
  }
}
