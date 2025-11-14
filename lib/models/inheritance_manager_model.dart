import 'inheritance_state_model.dart';

// مدير التوزيع الرئيسي

class InheritanceManager {
  static void distribute(InheritanceState state) {
    for (final heirName in state.heirsItems.values) {
      final result = heirName.getResult();
      result.execute(state);
    }
  }
}