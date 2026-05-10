import '../../domain/rules/inheriting_application.dart';
import '../../domain/entities/heir_processor_model.dart';
import '../../domain/entities/rule_application_model.dart';
import '../../domain/entities/inheritance_state_model.dart';
import '../../presentation/constants/inheritance_shares.dart';
import 'package:men/core/constants/numbers/person_count_constants.dart';


class HusbandProcessor extends HeirProcessor {
  HusbandProcessor({super.state, required super.heirType});

  @override
  RuleApplication getResult() {
    if (shouldBlock(state!)) {
      return InheritingApplication(
          description: "يرث الزوج الربع في حالة وجود فرع وارث ذكر أو أنثي",
          heirName: heirName,
          share: InheritanceShares.quarter,
          colorIndex: PersonCountConstants.zero
      );
    }
    return InheritingApplication(
        description: "يرث الزوج النصف في حالة عدم وجود فرع وارث ذكر أو أنثي",
        heirName: heirName,
        share: InheritanceShares.hafe,
        colorIndex: PersonCountConstants.zero
    );
  }

  @override
  String get heirName => heirType.heirName;

  @override
  bool shouldBlock(InheritanceState state) {
    return state.hasBranch();
  }
}