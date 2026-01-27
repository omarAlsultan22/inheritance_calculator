import '../entities/inheritance_state_model.dart';
import '../entities/rule_application_model.dart';


class BlockedApplication extends RuleApplication {
  BlockedApplication({required super.heirName, required super.description});

  @override
  void execute(InheritanceState state) {
    state.addDetails(heirName, description);
  }
}