import 'package:flutter_bloc/flutter_bloc.dart';
import '../states/distribution_shares_state.dart';
import '../../domain/useCasese/rest_the_extra.dart';
import '../../domain/useCasese/share_distribution.dart';


class DistributionSharesCubit extends Cubit<DistributionSharesState> {
  final RestTheExtra _restTheExtra;
  final ShareDistribution _shareDistribution;

  DistributionSharesCubit({
    required RestTheExtra restTheExtra,
    required ShareDistribution shareDistribution,
  })
      :
        _restTheExtra = restTheExtra,
        _shareDistribution = shareDistribution,
        super(DistributionSharesState(heirsData: [], heirsDetails: {}));


  static DistributionSharesCubit get(context) => BlocProvider.of(context);

  Future <void> executeDistribution() async {
    final _inheritanceState = await _shareDistribution.shareDistribution();
    final _newState = await _restTheExtra.calcTheRest(_inheritanceState);
    emit(_newState);
  }
}