import '../../core/enums/heir_type.dart';
import '../models/inheritance_result.dart';
import '../../core/constants/colors_constants.dart';
import '../../domain/rules/blocked_application.dart';
import '../../core/inheritance/inheritance_shares.dart';
import '../../domain/rules/inheriting_application.dart';
import '../../domain/entities/heir_processor_model.dart';
import '../../domain/entities/rule_application_model.dart';
import '../../domain/entities/inheritance_state_model.dart';


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
        colorIndex: ColorsConstants.tow
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