import '../entities/inheritance_state_model.dart';
import '../entities/rule_application_model.dart';


class InheritingApplication extends RuleApplication {
  InheritingApplication({
    required super.description,
    required super.heirName,
    super.colorIndex,
    super.count,
    super.share
  });

  @override
  void execute(InheritanceState state) {
    state.addHeir(heirName, description, share!, colorIndex!, count);
  }
}