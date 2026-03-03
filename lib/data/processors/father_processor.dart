import '../models/inheritance_update.dart';
import '../../domain/rules/inheriting_application.dart';
import '../../domain/entities/heir_processor_model.dart';
import '../../domain/entities/rule_application_model.dart';
import '../../domain/entities/inheritance_state_model.dart';
import 'package:men/core/constants/numbers/decimal_numbers.dart';
import 'package:men/core/constants/numbers/natural_numbers_constants.dart';
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
        colorIndex: NaturalNumbersConstants.one
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
    if (update.extraAdjustment != DecimalNumbersConstants.zero) {
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