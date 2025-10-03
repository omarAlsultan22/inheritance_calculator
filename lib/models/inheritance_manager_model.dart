import 'heirs_map_model.dart';
import 'inheritance_state_model.dart';

// مدير التوزيع الرئيسي

class InheritanceManager {
  static void distribute(InheritanceState state) {
    for (final heirName in state.heirsCount.keys) {
      final processor = heirsMap[heirName];
      final count = state.heirsCount[heirName];
      processor?.process(state: state, count: count);
    }
  }
}