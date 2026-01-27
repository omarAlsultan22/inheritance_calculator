import 'package:flutter/cupertino.dart';
import '../../data/models/item_model.dart';
import '../../core/services/inheritance_service.dart';


class UpdateHeirCount {
  void updateItem(HeirModel _heirModel) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final process = HeirsStats.heirsMap[_heirModel.heirName];
      if (process == null) {
        print('Processor not found for: ${_heirModel.heirName}');
        return;
      }

      const _fixedItems = [
        'الأب',
        'الأم',
        'الزوج',
        'الجد',
        'الجدة لأب',
        'الجدة لأم'
      ];
      const _incrementableItems = [
        'الابن', 'ابن الابن', 'الأخ الشقيق', 'الأخ لأب',
        'البنت', 'بنت الابن', 'الأخت الشقيقة', 'الأخت لأب'
      ];

      if (_fixedItems.contains(_heirModel.heirName)) {
        _heirModel.isShowing = true;
      } else if (_incrementableItems.contains(_heirModel.heirName)) {
        _heirModel.isShowing = false;
        if (!_heirModel.isShowing) {
          _heirModel.totalHeirs++;
          process.count = _heirModel.totalHeirs;
        }
      } else {
        _heirModel.isShowing = !_heirModel.isShowing;
      }
    });
  }
}