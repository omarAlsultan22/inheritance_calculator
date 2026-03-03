import '../../core/enums/heir_type.dart';
import '../../domain/rules/blocked_application.dart';
import '../../domain/rules/inheriting_application.dart';
import '../../domain/entities/heir_processor_model.dart';
import '../../domain/entities/rule_application_model.dart';
import '../../domain/entities/inheritance_state_model.dart';
import 'package:men/core/constants/numbers/natural_numbers_constants.dart';


class PaternalBrothersSonProcessor extends HeirProcessor {
  PaternalBrothersSonProcessor({super.state, super.count, required super.heirType});

  static const _blockingHeirs = [
    HeirType.son, HeirType.sonsSon, HeirType.father,
    HeirType.fullBrothersSon
  ];

  @override
  RuleApplication getResult() {
    if (shouldBlock(state!)) {
      return BlockedApplication(
          heirName: heirName,
          description: "يحجب ابن الأخ لأب بحضور الابن أو ابن الابن أو الأب أو الأخ الشقيق"
      );
    }

    return InheritingApplication(
      colorIndex: NaturalNumbersConstants.five,
      heirName: heirName,
      share: state!.extra,
      count: count,
      description: "يرث $heirName الأخوة لأب بالتعصيب باقي التركة",
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