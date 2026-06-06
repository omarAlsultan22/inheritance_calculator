import '../../data/models/data_model.dart';


class DistributionSharesState {
  final List<ItemModel>? heirsData;
  final Map<String, String>? heirsDetails;

  DistributionSharesState({
    this.heirsData,
    this.heirsDetails
  });

  factory DistributionSharesState.initial(){
    return DistributionSharesState(
        heirsData: [],
        heirsDetails: {}
    );
  }
}
