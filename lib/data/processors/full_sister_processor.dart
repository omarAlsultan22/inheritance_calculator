import '../../core/enums/heir_type.dart';
import '../models/inheritance_result.dart';
import '../../core/constants/colors_constants.dart';
import '../../domain/rules/blocked_application.dart';
import '../../core/inheritance/inheritance_shares.dart';
import '../../domain/rules/inheriting_application.dart';
import '../../domain/entities/heir_processor_model.dart';
import '../../domain/entities/rule_application_model.dart';
import '../../domain/entities/inheritance_state_model.dart';


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
    }
    return false;
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