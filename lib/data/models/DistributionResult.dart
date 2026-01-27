import 'data_model.dart';


class DistributionResult {
  List<ItemModel>? heirsData;
  Map<String, String>? heirsDetails;
  final bool hasData;

  DistributionResult({
    required this.heirsData,
    required this.heirsDetails,
  }) : hasData = heirsData!.isNotEmpty;
}