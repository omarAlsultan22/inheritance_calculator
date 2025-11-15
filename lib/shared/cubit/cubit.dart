import '../../models/item_model.dart';
import 'package:flutter/material.dart';
import '../../models/states_models.dart';
import 'package:men/models/data_model.dart';
import 'package:men/shared/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/heir_processor_model.dart';
import '../../models/inheritance_state_model.dart';
import '../../models/inheritance_manager_model.dart';
import '../../modules/display_screen/display_screen.dart';


class DataCubit extends Cubit<DataStates> {
  DataCubit() : super(DataInitialState());

  static DataCubit get(context) => BlocProvider.of(context);

  bool color = false;
  String? selectedItem;
  late BuildContext context;
  List<DataItems> dataItems = [];
  Map<String, String> detailsItems = {};
  static InheritanceState _inheritanceState = InheritanceState();

  Map<String, HeirType> heirsList = {
    'الزوج': HeirType.husband,
    'الزوجة': HeirType.wife,
    'الأب': HeirType.father,
    'الأم': HeirType.mother,
    'الابن': HeirType.son,
    'البنت': HeirType.daughter,
    'ابن الابن': HeirType.sonsSon,
    'بنت الابن': HeirType.sonsDaughter,
    'الجد': HeirType.grandfather,
    'الجدة لأب': HeirType.paternalGrandMother,
    'الجدة لأم': HeirType.maternalGrandmother,
    'الأخت الشقيقة': HeirType.fullSister,
    'الأخت لأب': HeirType.paternalSister,
    'الأخ الشقيق': HeirType.fullBrother,
    'الأخ لأب': HeirType.paternalBrother,
    'الأخوة لأم': HeirType.maternalSiblings,
    'العم الشقيق': HeirType.fullUncle,
    'العم لأب': HeirType.paternalUncle,
    'ابن الأخ الشقيق': HeirType.fullBrothersSon,
    'ابن الأخ لأب': HeirType.paternalBrothersSon,
    'ابن العم الشقيق': HeirType.fullCousin,
    'ابن العم لأب': HeirType.paternalCousin,
  };

  Map<String, HeirProcessor> heirsMap = {
    'الزوج': HusbandProcessor(state: _inheritanceState),
    'الزوجة': WifeProcessor(state: _inheritanceState, count: 1),
    'الأب': FatherProcessor(state: _inheritanceState),
    'الأم': MotherProcessor(state: _inheritanceState),
    'الجد': GrandfatherProcessor(state: _inheritanceState),
    'الجدة لأب': PaternalGrandmotherProcessor(state: _inheritanceState),
    'الجدة لأم': MaternalGrandmotherProcessor(state: _inheritanceState),
    'البنت': DaughterProcessor(state: _inheritanceState, count: 1),
    'بنت الابن': SonsDaughterProcessor(state: _inheritanceState, count: 1),
    'الابن': SonProcessor(state: _inheritanceState, count: 1),
    'ابن الابن': SonsSonProcessor(state: _inheritanceState, count: 1),
    'الأخت الشقيقة': FullSisterProcessor(state: _inheritanceState, count: 1),
    'الأخت لأب': PaternalSisterProcessor(state: _inheritanceState, count: 1),
    'الأخوة لأم': MaternalSiblingsProcessor(state: _inheritanceState, count: 1),
    'الأخ الشقيق': FullBrotherProcessor(state: _inheritanceState, count: 1),
    'الأخ لأب': PaternalBrotherProcessor(state: _inheritanceState, count: 1),
    'ابن الأخ الشقيق': FullBrothersSonProcessor(state: _inheritanceState, count: 1),
    'ابن الأخ لأب': PaternalBrothersSonProcessor(state: _inheritanceState, count: 1),
    'العم الشقيق': FullUncleProcessor(state: _inheritanceState, count: 1),
    'العم لأب': PaternalUncleProcessor(state: _inheritanceState, count: 1),
    'ابن العم الشقيق': FullCousinProcessor(state: _inheritanceState, count: 1),
    'ابن العم لأب': PaternalCousinProcessor(state: _inheritanceState, count: 1),
  };


  static const List<String> _category1 = ["الزوج", "الزوجة"];
  static const List<String> _category2 = ["الأب", "الجد"];
  static const List<String> _category3 = ["الأم", "الجدة لأب", "الجدة لأم"];
  static const List<String> _category4 = [
    "البنت",
    "بنت الابن",
    "الأخت الشقيقة",
    "الأخت لأب",
    "الأخوة لأم"
  ];

  final List<List<TextValue>> multiList = [
    _firstList,
    _secondList,
    _thirdList,
    _fourthList,
    _fifthList,
  ];

  static List<TextValue> _firstList = [];
  static List<TextValue> _secondList = [];
  static List<TextValue> _thirdList = [];
  static List<TextValue> _fourthList = [];
  static List<TextValue> _fifthList = [];


  void sendWidgetContext(BuildContext currentContext) {
    context = currentContext;
    emit(DataSuccessState());
  }


  Future <void> insertData({
    required List<DataItems> dataSet,
    required Map<String, String> details,
    required double extra
  }) async {
    try {
      emit(DataLoadingState());
      if (extra != 0.0) {
        const String value = 'الباقي';
        dataSet.add(DataItems(extra, value, Color(0xFF388E3C)));
        details[value] =
        'يقسم الباقي علي الورثة الموجودين بالتساوي في حالة عدم وجود معصب';
      }
      dataItems = dataSet;
      detailsItems = details;
      emit(DataSuccessState());
    }
    catch (error) {
      emit(DataErrorState(error: error.toString()));
    }
  }


  bool get buttonLuck {
    final _hasItems = _firstList.isNotEmpty ||
        _secondList.isNotEmpty ||
        _thirdList.isNotEmpty ||
        _fourthList.isNotEmpty ||
        _fifthList.isNotEmpty;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      color = _hasItems;
      emit(DataSuccessState());
    });
    return color;
  }


  void checkKey(String? key) {
    if (keyNotEmpty(key)) {
      if (!checkCouple(key!)) {
        selectedItem = key;
        addTextValue(key);
        buttonLuck;
        emit(DataSuccessState());
      };
    }
  }

  bool keyNotEmpty(String? key) {
    return key != null && key.isNotEmpty;
  }

  bool checkCouple(String key) {
    if (key == 'الزوج') {
      return _firstList.any((item) =>
      item.textValue == 'الزوجة');
    }

    if (key == 'الزوجة') {
      return _firstList.any((item) =>
      item.textValue == 'الزوج');
    }

    return false;
  }


  void addTextValue(String value) {
    if (value.isEmpty) {
      return;
    }

    final textValue = TextValue(value, true, true, true);
    final List<TextValue> targetList = _getTargetList(value);

    if (!_containsValue(targetList, value)) {
      targetList.add(textValue);
      var process = heirsMap[value];
      if (process != null) {
        process.state!.heirType = heirsList[selectedItem];
        _inheritanceState.heirsItems[value] = process;
      }
      emit(DataSuccessState());
    }
  }


  List<TextValue> _getTargetList(String value) {
    if (_category1.contains(value)) return _firstList;
    if (_category2.contains(value)) return _secondList;
    if (_category3.contains(value)) return _thirdList;
    if (_category4.contains(value)) return _fourthList;
    return _fifthList;
  }

  bool _containsValue(List<TextValue> list, String value) {
    for (final item in list) {
      if (item.textValue == value) return true;
    }
    return false;
  }


  void removeItem(TextValue e) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_firstList.contains(e)) {
        _firstList.remove(e);
      } else if (_secondList.contains(e)) {
        _secondList.remove(e);
      } else if (_thirdList.contains(e)) {
        _thirdList.remove(e);
      } else if (_fourthList.contains(e)) {
        _fourthList.remove(e);
      } else {
        _fifthList.remove(e);
      }

      _inheritanceState.heirsItems.remove(e.textValue);
    });
    buttonLuck;
    emit(DataSuccessState());
  }


  void handleItemTap(TextValue _e) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final process = heirsMap[_e.textValue];
      if (process == null) {
        print('Processor not found for: ${_e.textValue}');
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

      if (_fixedItems.contains(_e.textValue)) {
        _e.toggle = true;
      } else if (_incrementableItems.contains(_e.textValue)) {
        _e.toggle = false;
        if (!_e.toggle) {
          _e.sum++;
          process.count = _e.sum;
        }
      } else {
        _e.toggle = !_e.toggle;
      }
    });
    emit(DataSuccessState());
  }


  void shareDistribution() {
    _inheritanceState.reset();
    for (final _list in multiList) {
      for (final _item in _list) {
        final process = heirsMap[_item.textValue];
        process!.count = _item.sum;
        _inheritanceState.heirsItems[_item.textValue] = process;
      }
    }

    InheritanceManager.distribute(_inheritanceState);

    if (_inheritanceState.dataset.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إضافة ورثة صالحين للإرث')),
      );
      return;
    }

    insertData(
        dataSet: _inheritanceState.dataset,
        details: _inheritanceState.heirsDetails,
        extra: _inheritanceState.totalExtra
    ).whenComplete(() =>
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisplayScreen(),
          ),
        )
    );
    emit(DataSuccessState());
  }
}