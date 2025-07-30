abstract class DataStates{}
class DataInitialState extends DataStates{}
class DataLoadingState extends DataStates{}
class DataSuccessState extends DataStates{}
class DataErrorState extends DataStates{
  final String error;
  DataErrorState(this.error);
}