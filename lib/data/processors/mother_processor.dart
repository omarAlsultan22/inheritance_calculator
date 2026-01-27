import '../../core/enums/heir_type.dart';
import '../models/inheritance_result.dart';
import '../../core/constants/colors_constants.dart';
import '../../core/inheritance/inheritance_shares.dart';
import '../../domain/rules/inheriting_application.dart';
import '../../domain/entities/heir_processor_model.dart';
import '../../domain/entities/rule_application_model.dart';
import '../../domain/entities/inheritance_state_model.dart';


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
          description: "ترث $heirName السدس في وجود أخوة او فرع وارث ذكر او انثي",
          heirName: heirName,
          share: Shares.sixth,
          colorIndex: ColorsConstants.tow
      );
    }
    final calculator = MotherInheritanceCalculator(
        _createContext());
    final result = calculator.calculate();


    return InheritingApplication(
        description: result.description,
        heirName: heirName,
        share: result.share,
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