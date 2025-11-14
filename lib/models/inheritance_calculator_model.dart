import 'package:men/models/inheritance_state_model.dart';
import 'package:men/models/rule_application_model.dart';
import 'heir_processor_model.dart';
import 'inheritance_result.dart';


class InheritanceUpdate {
  double extraAdjustment;
  bool markMotherPresent;

  InheritanceUpdate({
    this.extraAdjustment = 0.0,
    this.markMotherPresent = false,
  });
}


class FatherAndGrandfatherInheritanceCalculator extends HeirProcessor {
  final InheritanceState _context;

  FatherAndGrandfatherInheritanceCalculator(this._context);

  final update = InheritanceUpdate();

  InheritanceResult calculate() {
    if (_hasMaleDescendant()) {
      return _calculateOneSixthShare();
    } else {
      return _calculateResidualShare();
    }
  }

  bool _hasMaleDescendant() {
    return _context.hasHeir(HeirType.son) ||
        _context.hasHeir(HeirType.sonsSon);
  }

  InheritanceResult _calculateOneSixthShare() {
    return InheritanceResult(
        share: 0.16,
        description: "يرث الأب السدس في وجود فرع وارث ذكر",
        explanation: _buildExplanation(HeirType.son, HeirType.sonsSon)
    );
  }

  InheritanceResult _calculateResidualShare() {

    update.extraAdjustment = 1.0;
    _getDaughtersShare();
    _getSonsDaughtersShare();
    _handleMotherPresence();

    return InheritanceResult(
        share: 0.16 + _context.extra!,
        description: _getResidualDescription(),
        explanation: _getResidualDescription()
    );
  }

  String _getResidualDescription() {
    return _context.baseValue! > 1
        ? "يرث الأب السدس وتعصيب مع وجود فرع وارث أنثى"
        : "يرث الأب بالتعصيب في غياب الفرع الوارث";
  }

  bool _hasDaughter(){
    return _context.hasHeir(HeirType.daughter);
  }
  bool _hasSonsDaughter(){
    return _context.hasHeir(HeirType.sonsDaughter);
  }

  void _getDaughtersShare(){
    if(_hasDaughter()) {
      double totalShare = _context.extra!;
      final daughterCount = _context.isCount(HeirType.daughter);

      final isSingle = daughterCount < 2;

      final share = isSingle ? 0.5 : 0.66;
      final finalShare = totalShare - share;

      _context.extra = finalShare;
    }
  }

  void _getSonsDaughtersShare() {
    if (_hasDaughter()) {
      double totalShare = _context.extra!;
      final finalShare = totalShare - 0.16;
      _context.extra = finalShare;
      return;
    }

    if (_hasSonsDaughter()) {
      double totalShare = _context.extra!;
      final sonsDaughterCount = _context.isCount(HeirType.daughter);

      final isSingle = sonsDaughterCount < 2;

      final share = isSingle ? 0.5 : 0.66;
      final finalShare = totalShare - share;

      _context.extra = finalShare;
    }
  }

  void _handleMotherPresence() {
    if (_context.hasHeir(HeirType.mother) && !_context.isMotherPresent!) {
      update.markMotherPresent = true;
    }
  }

  String _buildExplanation(HeirType firstType, HeirType secondType) {
    final heirs = [firstType, secondType]
        .where((type) => _context.hasHeir(type))
        .map((type) => type.heirName)
        .join(' أو ');

    return "يرث ${_context.heirName} السدس في وجود $heirs";
  }

  @override
  RuleApplication getResult() {
    // TODO: implement getResult
    throw UnimplementedError();
  }

  @override
  // TODO: implement heirName
  String get heirName => throw UnimplementedError();
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
    return _context.hasHeir(HeirType.husband) ||
        _context.hasHeir(HeirType.wife);
  }

  InheritanceResult CalculateShareRemainingThird() {
    return InheritanceResult(
        share: _context.extra! / 3,
        description: "ترث الأم ثلث الباقي في أحد العمرتين مع الأب وأحد الزوجين",
        explanation: "ترث الأم ثلث الباقي في أحد العمرتين مع الأب وأحد الزوجين"
    );
  }

  InheritanceResult CalculateOneThirdShare() {
    return InheritanceResult(
        share: 0.3,
        description: "ترث الأم الثلث في غياب الفرع الوراث ذكور واناث والأخوة الأشقاء ذكور واناث والأخت لأب",
        explanation: "ترث الأم الثلث في غياب الفرع الوراث ذكور واناث والأخوة الأشقاء ذكور واناث والأخت لأب"
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
    return _context.hasHeir(HeirType.maternalGrandmother);
  }

  InheritanceResult CalculateOneHalfSixthShare() {
    return InheritanceResult(
        share: 0.08,
        description: "ترث الجدة لأب مع الجدة لأم السدس في حالة غياب الأم والأب",
        explanation: "ترث الجدة لأب مع الجدة لأم السدس في حالة غياب الأم والأب"
    );
  }

  InheritanceResult _calculateOneSixthShare() {
    return InheritanceResult(
        share: 0.16,
        description: "ترث الجدة لأب السدس منفردة في حالة غياب الأب و الأم و الجدة لأم",
        explanation: "ترث الجدة لأب السدس منفردة في حالة غياب الأب و الأم و الجدة لأم"
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
    return _context.hasHeir(HeirType.paternalGrandMother);
  }

  InheritanceResult CalculateOneHalfSixthShare() {
    return InheritanceResult(
        share: 0.08,
        description: "ترث الجدة لأم مع الجدة لأب السدس في حالة غياب الأم والأب",
        explanation: "ترث الجدة لأم مع الجدة لأب السدس في حالة غياب الأم والأب"
    );
  }

  InheritanceResult _calculateOneSixthShare() {
    return InheritanceResult(
        share: 0.16,
        description: "ترث الجدة لأم السدس منفردة في حالة غياب الأب و الأم و الجدة لأم",
        explanation: "ترث الجدة لأم السدس منفردة في حالة غياب الأب و الأم و الجدة لأم"
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
    return _context.hasHeir(HeirType.son);
  }

  InheritanceResult _calculateOneShareInnervation() {

    final sonsCount = _context.isCount(HeirType.son);
    final share = _context.extra! / (sonsCount * 2 + _context.count!);
    final totalShare = share * _context.count!;
    final heirName = _context.heirName;

    return InheritanceResult(
        share: totalShare,
        description: "ترث $heirName بالتعصيب في وجود المعصب لهم وهو الابن",
        explanation: "ترث $heirName بالتعصيب في وجود المعصب لهم وهو الابن"
    );
  }

  InheritanceResult _calculateSpecifiedShare() {
    return InheritanceResult(
        share: getShare(),
        description: gerDescription(),
        explanation: gerDescription(),
    );
  }

  String gerDescription(){
    return _context.isHeirSingle!
        ? "ترث البنت النصف في غياب المعصب لها وهو الابن"
        : "ترث البنات الثلثان في غياب المعصب لهم وهو الابن";
  }

  double getShare() {
    return _context.isHeirSingle! ? 0.5 : 0.66;
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
    return _context.hasHeir(HeirType.sonsSon);
  }

  bool _hasDaughter() {
    return _context.hasHeir(HeirType.daughter);
  }

  InheritanceResult _calculateOneShareInnervation() {
    final sonsCount = _context.isCount(HeirType.sonsSon);
    final share = _context.extra! / (sonsCount * 2 + _context.count!);
    final totalShare = share * _context.count!;
    final heirName = _context.heirName;

    return InheritanceResult(
        share: totalShare,
        description: "ترث $heirName بالتعصيب في وجود المعصب لها ابن الابن",
        explanation: "ترث $heirName بالتعصيب في وجود المعصب لها ابن الابن"
    );
  }

  InheritanceResult _calculateOneSixthShare() {
    final heirName = _context.heirName;

    return InheritanceResult(
      share: 0.16,
      description: "ترث $heirName السدس في وجود البنت",
      explanation: "ترث $heirName السدس في وجود البنت",
    );
  }

  InheritanceResult _calculateSpecifiedShare() {
    return InheritanceResult(
      share: getShare(),
      description: gerDescription(),
      explanation: gerDescription(),
    );
  }

  String gerDescription() {
    return _context.isHeirSingle!
        ? "ترث بنت الابن النصف في غياب البنت و معصبها ابن الابن"
        : "ترث بنات الابن الثلثين في غياب البنت ومعصبهم ابن الابن";
  }

  double getShare() {
    return _context.isHeirSingle! ? 0.5 : 0.66;
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
    return _context.hasHeir(HeirType.fullBrother);
  }

  bool _hasDaughter() {
    return _context.hasHeir(HeirType.daughter) ||
        _context.hasHeir(HeirType.sonsDaughter);
  }

  InheritanceResult _calculateOneShareInnervation() {
    final sonsCount = _context.isCount(HeirType.fullBrother);
    final share = _context.extra! / (sonsCount * 2 + _context.count!);
    final totalShare = share * _context.count!;
    final heirName = _context.heirName;

    return InheritanceResult(
        share: totalShare,
        description: "ترث $heirName بالتعصيب مع وجود المعصب لها الأخ الشقيق",
        explanation: "ترث $heirName بالتعصيب مع وجود المعصب لها الأخ الشقيق"
    );
  }

  InheritanceResult _calculateOneSixthShare() {
    final heirName = _context.heirName;

    return InheritanceResult(
        share: 0.16,
        description: "ترث $heirName السدس في وجود فرع وارث انثي",
        explanation: "ترث $heirName السدس في وجود فرع وارث انثي"
    );
  }

  InheritanceResult _calculateSpecifiedShare() {
    return InheritanceResult(
      share: getShare(),
      description: gerDescription(),
      explanation: gerDescription(),
    );
  }

  String gerDescription() {
    return _context.isHeirSingle!
        ? "ترث الأخت الشقيقة النصف في غياب الأخ الشقيق والبنت"
        : "ترث الأخوات الشقيقات الثلثين في غياب الأخ الشقيق والبنت";
  }

  double getShare() {
    return _context.isHeirSingle! ? 0.5 : 0.66;
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
    return _context.hasHeir(heirType);
  }

  InheritanceResult _calculateOneShareInnervation() {
    final sonsCount = _context.isCount(HeirType.paternalBrother);
    final share = _context.extra! / (sonsCount * 2 + _context.count!);
    final totalShare = share * _context.count!;
    final heirName = _context.heirName;

    return InheritanceResult(
        share: totalShare,
        description: "ترث $heirName بالتعصيب في وجود الأخ لأب",
        explanation: "ترث $heirName بالتعصيب في وجود الأخ لأب"
    );
  }

  InheritanceResult _calculateOneSixthShare(String description) {
    return InheritanceResult(
        share: 0.16,
        description: description,
        explanation: description
    );
  }


  InheritanceResult _calculateSpecifiedShare() {
    return InheritanceResult(
      share: getShare(),
      description: gerDescription(),
      explanation: gerDescription(),
    );
  }

  String gerDescription() {
    return _context.isHeirSingle!
        ? "ترث الأخت لأب النصف في غياب البنت والأخت الشقيقة"
        : "ترث الأخوات لأب الثلثين في غياب البنت والأخت الشقيقة";
  }

  double getShare() {
    return _context.isHeirSingle! ? 0.5 : 0.66;
  }
}
