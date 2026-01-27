import 'package:flutter/material.dart';
import '../layouts/selection_layout.dart';
import '../states/management_items_state.dart';
import '../cubits/management_items_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SelectionScreen extends StatelessWidget {
  SelectionScreen({super.key});

  late ManagementItemsCubit _dataCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManagementItemsCubit, ManagementItemsState>(
      builder: (context, state) {
        _dataCubit = ManagementItemsCubit.get(context);
        return SelectionLayout(state, _dataCubit);
      },
    );
  }
}