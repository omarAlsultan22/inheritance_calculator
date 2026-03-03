import 'data_model.dart';


class DistributionResult {
  final List<ItemModel>? heirsData;
  final Map<String, String>? heirsDetails;
  final bool hasData;

  DistributionResult({
    required this.heirsData,
    required this.heirsDetails,
  }) : hasData = heirsData!.isNotEmpty;
}