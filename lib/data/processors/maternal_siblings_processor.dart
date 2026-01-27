import '../../core/enums/heir_type.dart';
import '../../core/constants/colors_constants.dart';
import '../../domain/rules/blocked_application.dart';
import '../../core/inheritance/inheritance_shares.dart';
import '../../domain/rules/inheriting_application.dart';
import '../../domain/entities/heir_processor_model.dart';
import '../../domain/entities/rule_application_model.dart';
import '../../domain/entities/inheritance_state_model.dart';


class MaternalSiblingsProcessor extends HeirProcessor {
  MaternalSiblingsProcessor({super.state, super.count, required super.heirType});

  static const _blockingHeirs = [
    HeirType.son, HeirType.daughter, HeirType.father,
    HeirType.grandfather, HeirType.sonsSon,
    HeirType.sonsDaughter
  ];

  @override
  RuleApplication getResult() {
    if (shouldBlock(state!)) {
      return BlockedApplication(
          heirName: heirName,
          description: "يحجب $heirName في حضور الابن أو ابن الابن أو البنت أو بنت الابن أو الأب أو الجد"
      );
    }

    final share = isSingle ? Shares.sixth : Shares.third;
    final description = isSingle
        ? "يرث $heirName السدس في حالة عدم أصل أو فرع وارث"
        : "يرث $heirName الثلث في حالة عدم أصل أو فرع وارث";

    return InheritingApplication(
      colorIndex: ColorsConstants.four,
      heirName: heirName,
      share: share,
      count: count,
      description: description,
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