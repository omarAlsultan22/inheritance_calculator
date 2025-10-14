import 'inheritance_state_model.dart';

// مدير التوزيع الرئيسي

class InheritanceManager {
  static void distribute(InheritanceState state) {
    for (final heirName in state.heirsItems.values) {
      heirName.process();
    }
  }
}