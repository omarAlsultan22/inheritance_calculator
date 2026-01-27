import 'app/my_app.dart';
import 'package:flutter/material.dart';
import 'domain/useCasese/rest_the_extra.dart';
import 'domain/useCasese/items_operators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'domain/useCasese/update_heir_count.dart';
import 'domain/useCasese/share_distribution.dart';
import 'package:men/presentation/cubits/management_items_cubit.dart';
import 'package:men/presentation/cubits/distribution_shares_cubit.dart';


void main() {
  final _UpdateItem = UpdateHeirCount();
  final _restTheExtra = RestTheExtra();
  final _itemsOperators = ItemsOperators();
  final _shareDistribution = ShareDistribution();

  runApp(
      MultiBlocProvider(
          providers: [
            BlocProvider<ManagementItemsCubit>(
                create: (context) =>
                    ManagementItemsCubit(
                        updateItem: _UpdateItem,
                        itemsOperators: _itemsOperators
                    )
            ),

            BlocProvider<DistributionSharesCubit>(
                create: (context) =>
                    DistributionSharesCubit(
                        restTheExtra: _restTheExtra,
                        shareDistribution: _shareDistribution
                    )
            )
          ],
          child: const MyApp()));
}








