import '../../core/enums/heir_type.dart';
import '../../core/constants/colors_constants.dart';
import '../../domain/rules/blocked_application.dart';
import '../../domain/rules/inheriting_application.dart';
import '../../domain/entities/heir_processor_model.dart';
import '../../domain/entities/rule_application_model.dart';
import '../../domain/entities/inheritance_state_model.dart';


class PaternalCousinProcessor extends HeirProcessor {
  PaternalCousinProcessor({super.state, super.count, required super.heirType});

  static const _blockingHeirs = [
    HeirType.son, HeirType.sonsSon, HeirType.father,
    HeirType.fullBrothersSon, HeirType.paternalBrothersSon,
    HeirType.fullUncle, HeirType.paternalUncle,
    HeirType.fullCousin
  ];

  @override
  RuleApplication getResult() {
    if (shouldBlock(state!)) {
      return BlockedApplication(
          heirName: HeirType.paternalCousin.heirName,
          description: "يحجب ابن العم لأب بحضور الابن أو ابن الابن أو الأب أو الأخ الشقيق أو الأخ لأب أو العم الشقيق أو العم لأب أو ابن العم الشقيق"
      );
    }

    return InheritingApplication(
        description: "يرث $heirName العم لأب بالتعصيب باقي التركة",
        colorIndex: ColorsConstants.five,
        share: state!.extra,
        heirName: heirName,
        count: count
    );
  }

  @override
  String get heirName => isSingle ? heirType.heirName : heirType.getPluralName(count);

  @override
  bool shouldBlock(InheritanceState state) {
    for (final heir in _blockingHeirs) {
      if (state.hasHeir(heir)) return true;
    }
    return false;
  }
}