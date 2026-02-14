import '../../core/enums/heir_type.dart';
import '../models/inheritance_result.dart';
import '../../core/constants/colors_constants.dart';
import '../../domain/rules/blocked_application.dart';
import '../../domain/rules/inheriting_application.dart';
import '../../domain/entities/heir_processor_model.dart';
import '../../domain/entities/rule_application_model.dart';
import '../../domain/entities/inheritance_state_model.dart';
import '../../core/constants/inheritance/inheritance_shares.dart';


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
        colorIndex: ColorsConstants.one
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