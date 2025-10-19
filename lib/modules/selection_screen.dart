import 'package:flutter_bloc/flutter_bloc.dart';
import '../layouts/selection_layout.dart';
import 'package:flutter/material.dart';
import '../shared/cubit/states.dart';
import '../shared/cubit/cubit.dart';


class SelectionScreen extends StatelessWidget {
  SelectionScreen({super.key});

  late DataCubit _dataCubit;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DataCubit, DataStates>(
      listener: statesListener,
      builder: (context, state) {
        _dataCubit = DataCubit.get(context);
        initDataCubit(context, _dataCubit);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: Colors.grey[900],
            appBar: buildSelectionAppBar(),
            body: Column(
              children: [
                const SizedBox(height: 50),
                headline(),
                itemsMenu(_dataCubit),
                selectedItems(_dataCubit),
                calculateButton(_dataCubit, state),
              ],
            ),
          ),
        );
      },
    );
  }
}