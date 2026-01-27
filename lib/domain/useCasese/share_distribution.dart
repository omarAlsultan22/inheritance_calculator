import '../services/inheritance_manager.dart';
import '../entities/inheritance_state_model.dart';
import '../../core/constants/heirs_constants.dart';
import '../../core/services/inheritance_service.dart';


class ShareDistribution {
  InheritanceState shareDistribution() {
    final _inheritanceState = HeirsStats.inheritanceState;
    _inheritanceState.reset();
    for (final _list in HeirsListsConstants.multiList) {
      for (final _item in _list) {
        final process = HeirsStats.heirsMap[_item.heirName];
        process!.count = _item.totalHeirs;
        _inheritanceState.heirsItems![_item.heirName] = process;
      }
    }

    InheritanceManager.distribute(HeirsStats.inheritanceState);

    if (_inheritanceState.heirsData.isEmpty) {

    }
    return _inheritanceState;
  }
}