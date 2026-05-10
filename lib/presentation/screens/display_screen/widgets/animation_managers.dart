import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import '../../../states/distribution_shares_state.dart';
import 'package:men/core/constants/numbers/calculation_constants.dart';
import 'package:men/core/constants/numbers/person_count_constants.dart';


class DisplayAnimationManager {
  final TickerProvider _vsync;
  final DistributionSharesState _state;
  late Timer _timer;
  late AnimationController _textController, _lineController;
  late Animation<double> animation;
  double fullAngle = CalculationConstants.zero;
  final double _secondsToComplete = CalculationConstants.five;
  List<int> degrees = [];
  List<bool> showLines = [];
  List<Animation<double>> animations = [];
  List<Timer> _lineTimers = []; // لتتبع الـ timers النشطة
  VoidCallback? _onUpdate;
  bool _chartCompleted = false;

  static const _fullAngleValue = 360.0;
  static const _milliseconds = 1000 ~/ 60;
  static const _variableValue = PersonCountConstants.zero;

  DisplayAnimationManager({
    required TickerProvider vsync,
    required DistributionSharesState state
  })
      : _state = state,
        _vsync = vsync {
    _initDegreesAndShowLines();
  }

  void _initDegreesAndShowLines() {
    for (var i = _variableValue; i < _state.heirsData!.length; i++) {
      degrees.add(_variableValue);
      showLines.add(false);
    }
  }

  void initializeAnimations() {
    _initTextAnimation();
    _initDonutChartAnimation();
    _initLineAnimation();
    _textController.forward();
    Future.delayed(const Duration(seconds: PersonCountConstants.tow), () {
      _startAllLineTimers();
      _lineController.forward();
    });
  }

  void _initTextAnimation() {
    _textController = AnimationController(
      duration: const Duration(seconds: PersonCountConstants.one),
      vsync: _vsync,
    );
    animation = Tween(begin: CalculationConstants.twoHundred,
        end: -CalculationConstants.twenty).animate(_textController)
      ..addListener(() {
        _onUpdate?.call();
      });
  }

  void _initDonutChartAnimation() {
    _timer =
        Timer.periodic(const Duration(milliseconds: _milliseconds), (timer) {
          fullAngle += _fullAngleValue / (_secondsToComplete * _milliseconds);
          if (fullAngle >= _fullAngleValue) {
            fullAngle = _fullAngleValue;
            timer.cancel();
            _chartCompleted = true;
          }
          _onUpdate?.call();
        });
  }

  void _initLineAnimation() {
    _lineController = AnimationController(
      duration: const Duration(seconds: PersonCountConstants.three),
      vsync: _vsync,
    );

    // Initialize line animations
    for (var item in _state.heirsData!) {
      animations.add(
        Tween<double>(
            begin: CalculationConstants.zero, end: item.amount * 300)
            .animate(
          CurvedAnimation(
            parent: _lineController,
            curve: Curves.easeInOut,
          ),
        ),
      );
    }

    // استمع لاكتمال أنيميشن الخطوط
    _lineController.addListener(() {
      _onUpdate?.call();
    });
  }

  void _startAllLineTimers() {
    // أوقف أي timers سابقة
    for (var timer in _lineTimers) {
      timer.cancel();
    }
    _lineTimers.clear();

    // ابدأ timers جديدة لكل عنصر
    for (int i = _variableValue; i < _state.heirsData!.length; i++) {
      _startLineTimer(i);
    }
  }

  void _startLineTimer(int index) {
    final targetValue = (_state.heirsData![index].amount *
        CalculationConstants.oneHundred).toInt();
    final duration = const Duration(seconds: 1); // مدة زيادة الرقم
    final steps = targetValue;
    final stepDuration = duration ~/ steps;

    showLines[index] = true; // أظهر الخط فوراً

    int currentStep = _variableValue;

    final timer = Timer.periodic(stepDuration, (timer) {
      if (currentStep < steps) {
        degrees[index] =
        ((currentStep + PersonCountConstants.one) * targetValue ~/ steps);
        currentStep++;
        _onUpdate?.call();
      } else {
        degrees[index] = targetValue; // التأكد من الوصول للقيمة النهائية
        timer.cancel();
        _lineTimers.remove(timer);
        _onUpdate?.call();
      }
    });

    _lineTimers.add(timer);
  }

  void dispose() {
    _timer.cancel();
    for (var timer in _lineTimers) {
      timer.cancel();
    }
    _lineTimers.clear();
    _textController.dispose();
    _lineController.dispose();
  }
}