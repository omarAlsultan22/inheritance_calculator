import 'package:men/models/rule_application_model.dart';
import '../../../models/inheritance_state_model.dart';


class BlockedApplication extends RuleApplication {
  BlockedApplication({required super.heirName, required super.description});

  @override
  void execute(InheritanceState state) {
    state.addDetails(heirName, description);
  }
}