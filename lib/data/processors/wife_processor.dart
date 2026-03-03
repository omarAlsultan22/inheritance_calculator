import '../../domain/rules/inheriting_application.dart';
import '../../domain/entities/heir_processor_model.dart';
import '../../domain/entities/rule_application_model.dart';
import '../../domain/entities/inheritance_state_model.dart';
import '../../core/constants/inheritance/inheritance_shares.dart';
import 'package:men/core/constants/numbers/natural_numbers_constants.dart';


class WifeProcessor extends HeirProcessor {
  WifeProcessor({super.state, super.count, required super.heirType});

  @override
  RuleApplication getResult() {
    if (shouldBlock(state!)) {
      return InheritingApplication(
          count: count,
          description: "ترث $heirName الثمن في حالة وجود فرع وارث ذكر أو أنثي",
          heirName: heirName,
          share: Shares.eighth,
          colorIndex: NaturalNumbersConstants.zero
      );
    }
    return InheritingApplication(
        count: count,
        description: "ترث $heirName الربع في حالة عدم وجود فرع وارث ذكر أو أنثي",
        heirName: heirName,
        share: Shares.quarter,
        colorIndex: NaturalNumbersConstants.zero
    );
  }

  @override
  String get heirName =>
      isSingle ? heirType.heirName : heirType.getPluralName(count);

  @override
  bool shouldBlock(InheritanceState state) {
    return state.hasBranch();
  }
}