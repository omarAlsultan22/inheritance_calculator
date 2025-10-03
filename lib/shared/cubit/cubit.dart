import '../../models/inheritance_manager_model.dart';
import '../../models/inheritance_state_model.dart';
import '../../models/item_model.dart';
import 'package:flutter/material.dart';
import '../../modules/display_screen/display_screen.dart';
import 'package:men/models/data_model.dart';
import 'package:men/shared/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class DataCubit extends Cubit<DataStates> {
  DataCubit() : super(DataInitialState());

  static DataCubit get(context) => BlocProvider.of(context);

  bool color = false;
  String? selectedItem;
  late BuildContext context;
  List<DataItems> dataItems = [];
  Map<String, String> detailsItems = {};
  final InheritanceState _inheritanceState = InheritanceState();


  List<String> selectedItems = [
    'الزوج', 'الزوجة', 'الأب', 'الأم', 'الجد',
    'الجدة لأب', 'الجدة لأم', 'الأخت الشقيقة',
    'الأخت لأب', 'الأخوة لأم', 'البنت', 'بنت الابن',
    'الابن', 'ابن الابن', 'الأخ الشقيق', 'الأخ لأب',
    'ابن الأخ الشقيق', 'ابن الأخ لأب', 'العم الشقيق',
    'العم لأب', 'ابن العم الشقيق', 'ابن العم لأب',
  ];

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


  void checkValue(String? value) {
    if (value != null && value.isNotEmpty) {
      selectedItem = value;
      addTextValue(value);
      buttonLuck;
      emit(DataSuccessState());
    }
  }

  void addTextValue(String value) {
    final _textValue = TextValue(value, true, true, true);

    if (_category1.contains(value)) {
      if (!_firstList.any((e) => e.textValue == value)) {
        _firstList.add(_textValue);
        _inheritanceState.heirsCount[value] = 1;
      }
    } else if (_category2.contains(value)) {
      if (!_secondList.any((e) => e.textValue == value)) {
        _secondList.add(_textValue);
        _inheritanceState.heirsCount[value] = 1;
      }
    } else if (_category3.contains(value)) {
      if (!_thirdList.any((e) => e.textValue == value)) {
        _thirdList.add(_textValue);
        _inheritanceState.heirsCount[value] = 1;
      }
    } else if (_category4.contains(value)) {
      if (!_fourthList.any((e) => e.textValue == value)) {
        _fourthList.add(_textValue);
        _inheritanceState.heirsCount[value] = 1;
      }
    } else if (!_fifthList.any((e) => e.textValue == value)) {
      _fifthList.add(_textValue);
      _inheritanceState.heirsCount[value] = 1;
    }
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

        _inheritanceState.heirsCount.remove(e.textValue);
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
            _inheritanceState.heirsCount[_e.textValue] = _e.sum;
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
        _inheritanceState.heirsCount[_item.textValue] = _item.sum;
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