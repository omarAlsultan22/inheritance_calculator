import '../../core/enums/heir_type.dart';
import '../models/inheritance_result.dart';
import 'package:men/core/constants/colors_constants.dart';
import '../../core/inheritance/inheritance_shares.dart';
import '../../domain/rules/inheriting_application.dart';
import '../../domain/entities/heir_processor_model.dart';
import '../../domain/entities/rule_application_model.dart';
import '../../domain/entities/inheritance_state_model.dart';


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
        colorIndex: ColorsConstants.four
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
