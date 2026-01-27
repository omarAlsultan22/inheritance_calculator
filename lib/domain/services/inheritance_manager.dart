import '../entities/inheritance_state_model.dart';


class InheritanceManager {
  static void distribute(InheritanceState state) {
    for (final heirName in state.heirsItems!.values) {
      final result = heirName.getResult();
      result.execute(state);
    }
  }
}


