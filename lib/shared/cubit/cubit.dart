import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:men/models/data_model.dart';
import 'package:men/shared/cubit/states.dart';

class DataCubit extends Cubit<DataStates> {
  DataCubit() : super(DataInitialState());

  static DataCubit get(context) => BlocProvider.of(context);

  List<DataItems> dataItems = [];
  Map<String, String> detailsItems = {};

  Future <void> insertData({
    required List<DataItems> dataSet,
    required Map<String, String> details,
    required double extra
  }) async {
    try {
      emit(DataLoadingState());
      if(extra != 0.0) {
        if (dataSet.length == 1) {
          dataSet[0].value += extra;
        }
        else {
          double rest = extra / dataSet.length;
          dataSet.map((e) => e.value += rest);
        }
      }
      dataItems = dataSet;
      detailsItems = details;
      emit(DataSuccessState());
    }
    catch (error) {
      emit(DataErrorState(error.toString()));
    }
  }
}