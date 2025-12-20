import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layouts/display_screen.dart';
import 'widgets/animation_managers.dart';
import '../../shared/cubit/states.dart';
import 'package:flutter/material.dart';
import '../../shared/cubit/cubit.dart';


class DisplayScreen extends StatefulWidget {
  const DisplayScreen({Key? key}) : super(key: key);

  @override
  _DisplayScreenState createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> with TickerProviderStateMixin {
  late DisplayAnimationManager _animationManager;
  late DataCubit _dataCubit;

  @override
  void initState() {
    super.initState();
    _dataCubit = DataCubit.get(context);
    _animationManager = DisplayAnimationManager(
      vsync: this,
      dataCubit: _dataCubit,
    );
    _animationManager.initializeAnimations();
  }

  @override
  void dispose() {
    _animationManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _widgetContext = context;
    return BlocBuilder<DataCubit, DataStates>(
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: Colors.grey[900],
            appBar: buildDisplayAppBar(_widgetContext),
            body: buildDisplayBody(_dataCubit, _widgetContext, _animationManager),
          ),
        );
      },
    );
  }
}