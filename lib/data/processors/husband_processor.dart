import '../../core/constants/colors_constants.dart';
import '../../domain/rules/inheriting_application.dart';
import '../../domain/entities/heir_processor_model.dart';
import '../../domain/entities/rule_application_model.dart';
import '../../domain/entities/inheritance_state_model.dart';
import '../../core/constants/inheritance/inheritance_shares.dart';


class HusbandProcessor extends HeirProcessor {
  HusbandProcessor({super.state, required super.heirType});

  @override
  RuleApplication getResult() {
    if (shouldBlock(state!)) {
      return InheritingApplication(
          description: "يرث الزوج الربع في حالة وجود فرع وارث ذكر أو أنثي",
          heirName: heirName,
          share: Shares.quarter,
          colorIndex: ColorsConstants.zero
      );
    }
    return InheritingApplication(
        description: "يرث الزوج النصف في حالة عدم وجود فرع وارث ذكر أو أنثي",
        heirName: heirName,
        share: Shares.hafe,
        colorIndex: ColorsConstants.zero
    );
  }

  @override
  String get heirName => heirType.heirName;

  @override
  bool shouldBlock(InheritanceState state) {
    return state.hasBranch();
  }
}