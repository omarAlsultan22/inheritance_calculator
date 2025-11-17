import 'package:men/models/inheritance_state_model.dart';
import 'package:men/models/rule_application_model.dart';


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