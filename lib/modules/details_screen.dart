import 'package:men/layouts/details_layout.dart';
import 'package:men/layouts/display_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../shared/cubit/states.dart';
import '../shared/cubit/cubit.dart';


class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataCubit, DataStates>(
      builder: (context, state) {
        final detailsItems = DataCubit.get(context).detailsItems;
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: buildDisplayAppBar(context),
            backgroundColor: Colors.grey[900],
            body: buildDetailsBody(detailsItems),
          ),
        );
      },
    );
  }
}