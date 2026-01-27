import '../../core/enums/heir_type.dart';
import '../../core/constants/colors_constants.dart';
import '../../domain/rules/blocked_application.dart';
import '../../domain/rules/inheriting_application.dart';
import '../../domain/entities/heir_processor_model.dart';
import '../../domain/entities/rule_application_model.dart';
import '../../domain/entities/inheritance_state_model.dart';


class  FullBrothersSonProcessor extends HeirProcessor{
  FullBrothersSonProcessor({super.state, super.count, required super.heirType});

  static const _blockingHeirs = [
    HeirType.son, HeirType.sonsSon, HeirType.father,
  ];

  @override
  RuleApplication getResult() {
    if (shouldBlock(state!)) {
      return BlockedApplication(
          heirName: heirName,
          description: "يحجب ابن الأخ الشقيق بحضور الأخ الشقيق الابن أو ابن الابن أو الأب"
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
    for (final heir in _blockingHeirs) {
      if (state.hasHeir(heir)) return true;
    }
    return false;
  }
}