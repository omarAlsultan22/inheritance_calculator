import '../../core/enums/heir_type.dart';
import '../models/inheritance_result.dart';
import '../../core/constants/colors_constants.dart';
import '../../domain/rules/blocked_application.dart';
import '../../domain/rules/inheriting_application.dart';
import '../../domain/entities/heir_processor_model.dart';
import '../../domain/entities/rule_application_model.dart';
import '../../domain/entities/inheritance_state_model.dart';
import '../../core/constants/inheritance/inheritance_shares.dart';


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
        colorIndex: ColorsConstants.four
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