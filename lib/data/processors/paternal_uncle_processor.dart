import '../../core/enums/heir_type.dart';
import '../../core/constants/colors_constants.dart';
import '../../domain/rules/blocked_application.dart';
import '../../domain/rules/inheriting_application.dart';
import '../../domain/entities/heir_processor_model.dart';
import '../../domain/entities/rule_application_model.dart';
import '../../domain/entities/inheritance_state_model.dart';


class PaternalUncleProcessor extends HeirProcessor {
  PaternalUncleProcessor({super.state, super.count, required super.heirType});

  static const _blockingHeirs = [
    HeirType.son, HeirType.sonsSon, HeirType.father,
    HeirType.fullBrothersSon, HeirType.paternalBrothersSon,
    HeirType.fullUncle
  ];

  @override
  RuleApplication getResult() {
    if (shouldBlock(state!)) {
      return BlockedApplication(
          heirName: heirName,
          description: "يحجب العم لأب بحضور الابن أو ابن الابن أو الأب أو الأخ الشقيق أو الأخ لأب أو العم الشقيق"
      );
    }

    return InheritingApplication(
        colorIndex: ColorsConstants.five,
        heirName: heirName,
        share: state!.extra,
        description: "يرث $heirName لأب بالتعصيب باقي التركة",
        count: count
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