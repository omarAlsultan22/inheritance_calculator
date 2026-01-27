import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:men/presentation/layouts/details_layout.dart';
import 'package:men/presentation/cubits/distribution_shares_cubit.dart';
import 'package:men/presentation/states/distribution_shares_state.dart';


class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DistributionSharesCubit, DistributionSharesState>(
      builder: (context, state) {
        final detailsItems = state.heirsDetails!;
        return DetailsLayout(detailsItems);
      },
    );
  }
}