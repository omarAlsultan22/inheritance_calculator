import '../../core/constants/colors_constants.dart';
import '../../domain/rules/inheriting_application.dart';
import '../../domain/entities/heir_processor_model.dart';
import '../../domain/entities/rule_application_model.dart';


class SonProcessor extends HeirProcessor {
  SonProcessor({super.state, super.count, required super.heirType});

  @override
  RuleApplication getResult() {
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
}