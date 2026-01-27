import '../../core/enums/heir_type.dart';
import '../../core/constants/colors_constants.dart';
import '../../domain/rules/blocked_application.dart';
import '../../domain/rules/inheriting_application.dart';
import '../../domain/entities/heir_processor_model.dart';
import '../../domain/entities/rule_application_model.dart';
import '../../domain/entities/inheritance_state_model.dart';


class SonsSonProcessor extends HeirProcessor{
  SonsSonProcessor({super.state, super.count, required super.heirType});

  @override
  RuleApplication getResult() {
    if (shouldBlock(state!)) {
      return BlockedApplication(
          heirName: heirName,
          description: "يحجب $heirName بحضور الابن"
      );
    }

    return InheritingApplication(
      colorIndex: ColorsConstants.five,
      heirName: heirName,
      share: state!.extra,
      count: count,
      description: "يرث $heirName بالتعصيب باقي التركة",
    );
  }

  @override
  // TODO: implement heirName
  String get heirName => isSingle ? heirType.heirName : heirType.getPluralName(count);

  @override
  bool shouldBlock(InheritanceState state) {
    if (state.hasHeir(HeirType.son)) return true;
    return false;
  }
}