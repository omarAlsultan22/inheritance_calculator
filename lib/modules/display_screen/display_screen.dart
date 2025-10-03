import 'package:men/modules/display_screen/painters/line_painter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'painters/donut_chart_painter.dart';
import 'widgets/animation_managers.dart';
import '../../shared/cubit/states.dart';
import 'package:flutter/material.dart';
import '../../shared/cubit/cubit.dart';
import '../../models/data_model.dart';
import 'widgets/chart_widgets.dart';
import '../details_screen.dart';


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

  AppBar _buildAppBar() {
    return AppBar(
      scrolledUnderElevation: 0.0,
      title: const Text(
        'النتيجة',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      backgroundColor: Colors.grey[900],
    );
  }

  Widget _buildBody(List<DataItems> dataItems) {
    return Column(
      children: [
        Center(
          child: Container(
            width: 300.0,
            height: 300.0,
            child: CustomPaint(
              painter: DonutChartPainter(
                  dataItems,
                  _animationManager.fullAngle, // تم التصحيح
                  context
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              itemCount: _dataCubit.dataItems.length,
              itemBuilder: (context, index) {
                return ChartLabelWidget(
                  label: _dataCubit.dataItems[index].label,
                  anime: _animationManager.animation.value,
                  value: _animationManager.degrees[index],
                  toggle: _animationManager.showLines[index],
                  color: _dataCubit.dataItems[index].color,
                  linePainter: LinePainter(
                      _animationManager.animations[index],
                      _dataCubit.dataItems[index].color,
                      _animationManager.showLines[index]
                  ), animation: _animationManager.animations[index],
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: MaterialButton(
            height: 50,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DetailsScreen())
              );
            },
            child: const Text(
              "التفاصيل",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            color: Colors.amber,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataCubit, DataStates>(
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: Colors.grey[900],
            appBar: _buildAppBar(),
            body: _buildBody(_dataCubit.dataItems),
          ),
        );
      },
    );
  }
}