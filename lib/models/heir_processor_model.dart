import 'inheritance_state_model.dart';
import 'package:men/models/rule_application_model.dart';

abstract class HeirProcessor {
  int count;
  InheritanceState? state;

  HeirProcessor({this.state, this.count = 0});

  bool get isSingle => count < 2;

  String get heirName;

  HeirType? get heirType => state!.heirType;

  RuleApplication getResult();

  bool shouldBlock(InheritanceState state) => false;

}