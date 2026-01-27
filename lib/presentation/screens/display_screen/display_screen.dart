import 'package:flutter/material.dart';
import 'widgets/animation_managers.dart';
import '../../layouts/display_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/management_items_cubit.dart';
import '../../states/management_items_state.dart';
import 'package:men/presentation/states/distribution_shares_state.dart';


class DisplayScreen extends StatefulWidget {
  const DisplayScreen({Key? key}) : super(key: key);

  @override
  _DisplayScreenState createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> with TickerProviderStateMixin {
  late DisplayAnimationManager _animationManager;
  late DistributionSharesState _state;

  @override
  void initState() {
    super.initState();
    _state = DistributionSharesState();
    _animationManager = DisplayAnimationManager(
      vsync: this,
      state: _state,
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
    return BlocBuilder<ManagementItemsCubit, ManagementItemsState>(
      builder: (context, state) {
        return DisplayLayout(
            dataHeirs: _state.heirsData!,
            animationManager: _animationManager
        );
      },
    );
  }
}