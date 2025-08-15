abstract class DataStates{
  final String? error;
  DataStates({this.error});
}
class DataInitialState extends DataStates{}
class DataLoadingState extends DataStates{}
class DataSuccessState extends DataStates{}
class DataErrorState extends DataStates{
  DataErrorState({super.error});
}