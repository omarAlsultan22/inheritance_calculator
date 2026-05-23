import '../models/inheritance_update.dart';
import '../../domain/rules/inheriting_application.dart';
import '../../domain/entities/heir_processor_model.dart';
import '../../domain/entities/rule_application_model.dart';
import '../../constants/numbers/calculation_constants.dart';
import '../../domain/entities/inheritance_state_model.dart';
import '../../constants/numbers/person_count_constants.dart';
import 'package:men/data/processors/FatherOrGrandfatherInheritanceCalculator.dart';


class FatherProcessor extends HeirProcessor {
  FatherProcessor({super.state, required super.heirType});

  @override
  RuleApplication getResult() {
    final calculator = FatherOrGrandfatherInheritanceCalculator(
        _createContext());
    final result = calculator.calculate();

    _applyUpdates(calculator.update);

    return InheritingApplication(
        description: result.description,
        heirName: heirName,
        share: result.share,
        colorIndex: PersonCountConstants.one
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

  void _applyUpdates(InheritanceUpdate update) {
    if (update.extraAdjustment != CalculationConstants.zero) {
      state!.updateExtra(); //
    }

    if (update.markMotherPresent) {
      state!.markMotherPresent();
    }
  }

  @override
  // TODO: implement heirName
  String get heirName => heirType.heirName;
}