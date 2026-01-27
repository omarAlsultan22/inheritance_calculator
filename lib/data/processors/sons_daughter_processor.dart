import '../../core/enums/heir_type.dart';
import '../models/inheritance_result.dart';
import '../../core/constants/colors_constants.dart';
import '../../domain/rules/blocked_application.dart';
import '../../core/inheritance/inheritance_shares.dart';
import '../../domain/rules/inheriting_application.dart';
import '../../domain/entities/heir_processor_model.dart';
import '../../domain/entities/rule_application_model.dart';
import '../../domain/entities/inheritance_state_model.dart';


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
  String get heirName =>
      isSingle ? heirType.heirName : heirType.getPluralName(count);

  @override
  bool shouldBlock(InheritanceState state) {
    if (state.hasHeir(HeirType.son)) return true;
    return false;
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