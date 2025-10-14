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
  final InheritanceState _inheritanceState = InheritanceState();


  Map<String, HeirProcessor> heirsMap = {
    'الزوج': HusbandProcessor(),
    'الزوجة': WifeProcessor(),
    'الأب': FatherProcessor(),
    'الأم' : MotherProcessor(),
    'الجد': PaternalGrandfatherProcessor(),
    'الجدة لأب': PaternalGrandmotherProcessor(),
    'الجدة لأم': MaternalGrandmotherProcessor(),
    'البنت': DaughterProcessor(),
    'بنت الابن': SonsDaughterProcessor(),
    'الابن': SonProcessor(),
    'ابن الابن': SonsSonProcessor(),
    'الأخت الشقيقة': FullSisterProcessor(),
    'الأخت لأب': PaternalSisterProcessor(),
    'الأخوة لأم': MaternalSiblingsProcessor(),
    'الأخ الشقيق': FullBrotherProcessor(),
    'الأخ لأب': PaternalBrotherProcessor(),
    'ابن الأخ الشقيق': FullBrothersSonProcessor(),
    'ابن الأخ لأب': PaternalBrothersSonProcessor(),
    'العم الشقيق': FullUncleProcessor(),
    'العم لأب': PaternalUncleProcessor(),
    'ابن العم الشقيق': FullCousinProcessor(),
    'ابن العم لأب': PaternalCousinProcessor(),
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


  void sendWidgetContext(BuildContext currentContext){
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
        print(extra);
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
    if (key != null && key.isNotEmpty) {
      selectedItem = key;
      addTextValue(key);
      buttonLuck;
      emit(DataSuccessState());
    }
  }

  void addTextValue(String key) {
    final _textValue = TextValue(key, true, true, true);

    if (_category1.contains(key)) {
      if (!_firstList.any((e) => e.textValue == key)) {
        _firstList.add(_textValue);
      }
    } else if (_category2.contains(key)) {
      if (!_secondList.any((e) => e.textValue == key)) {
        _secondList.add(_textValue);
      }
    } else if (_category3.contains(key)) {
      if (!_thirdList.any((e) => e.textValue == key)) {
        _thirdList.add(_textValue);
      }
    } else if (_category4.contains(key)) {
      if (!_fourthList.any((e) => e.textValue == key)) {
        _fourthList.add(_textValue);
      }
    } else if (!_fifthList.any((e) => e.textValue == key)) {
      _fifthList.add(_textValue);
    }

    final heirProcess = heirsMap[key]!..state = _inheritanceState..count = 1;
    _inheritanceState.heirsItems[key] = heirProcess;

    emit(DataSuccessState());
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
            _inheritanceState.heirsItems[_e.textValue]!.count = _e.sum;
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
        _inheritanceState.heirsItems[_item.textValue]!.count = _item.sum;
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
        extra: _inheritanceState.extra
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