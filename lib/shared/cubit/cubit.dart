import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:men/models/data_model.dart';
import 'package:men/shared/cubit/states.dart';

class CubitData extends Cubit<DataStates> {
  CubitData() : super(DataInitialState());

  static CubitData get(context) => BlocProvider.of(context);

  List<DataItems> dataItems = [];
  Map<String, String> detailsItems = {};

  Future <void> insertData({
    required List<DataItems> dataSet,
    required Map<String, String> details
  }) async {
    try {
      emit(DataLoadingState());
      dataItems = dataSet;
      detailsItems = details;
      emit(DataSuccessState());
    }
    catch (error) {
      emit(DataErrorState(error.toString()));
    }
  }

  void clear() {
    detailsItems.clear();
    emit(DataSuccessState());
  }
}