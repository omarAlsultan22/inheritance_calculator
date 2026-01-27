import 'dart:ui';
import '../../data/models/data_model.dart';
import '../entities/inheritance_state_model.dart';
import '../../presentation/states/distribution_shares_state.dart';


class RestTheExtra {
  DistributionSharesState calcTheRest(InheritanceState _inheritanceState) {
    final _extra = _inheritanceState.extra!;
    final _currentHeirsData = _inheritanceState.heirsData;
    final _currentHeirsDetails = _inheritanceState.heirsDetails;

    if (_extra != 0.0) {
      const String value = 'الباقي';

      return DistributionSharesState(
        heirsData: [
          ..._currentHeirsData,
          ItemModel(
            amount: _extra,
            title: value,
            color: const Color(0xFF388E3C),
          ),
        ],
        heirsDetails: {
          ..._currentHeirsDetails,
          value: 'يقسم الباقي علي الورثة الموجودين بالتساوي في حالة عدم وجود معصب'
        },
      );
    }
    return DistributionSharesState(
        heirsData: _currentHeirsData,
        heirsDetails: _currentHeirsDetails
    );
  }
}