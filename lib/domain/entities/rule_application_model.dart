import 'inheritance_state_model.dart';


abstract class RuleApplication {
  final int? count;
  final double? share;
  final int? colorIndex;
  final String heirName;
  final String description;

  RuleApplication({
    this.count,
    this.share,
    this.colorIndex,
    required this.heirName,
    required this.description,
  });

  void execute(InheritanceState state);
}

