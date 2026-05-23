import 'package:men/domain/entities/rule_application_model.dart';
import 'inheritance_state_model.dart';
import '../../enums/heir_type.dart';


abstract class HeirProcessor {
  int count;
  HeirType heirType;
  InheritanceState? state;

  HeirProcessor({
    this.state,
    this.count = 0,
    required this.heirType
  });

  bool get isSingle => count < 2;

  String get heirName;

  RuleApplication getResult();

  bool shouldBlock(InheritanceState state) => false;

}