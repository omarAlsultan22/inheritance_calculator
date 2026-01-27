import 'package:men/domain/entities/rule_application_model.dart';
import '../../core/enums/heir_type.dart';
import 'inheritance_state_model.dart';


abstract class HeirProcessor {
  int count;
  HeirType heirType;
  InheritanceState? state;

  HeirProcessor({this.state, required this.heirType, this.count = 0});

  bool get isSingle => count < 2;

  String get heirName;

  RuleApplication getResult();

  bool shouldBlock(InheritanceState state) => false;

}