import 'dart:async';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import '../../../shared/cubit/cubit.dart';


class DisplayAnimationManager {
  final TickerProvider vsync;
  final DataCubit dataCubit;
  late Timer _timer;
  late AnimationController _textController, _lineController;
  late Animation<double> animation;
  double fullAngle = 0.0;
  final double _secondsToComplete = 5.0;
  List<int> degrees = [];
  List<bool> showLines = [];
  List<Animation<double>> animations = [];
  List<Timer> _lineTimers = []; // لتتبع الـ timers النشطة
  VoidCallback? onUpdate;
  bool _chartCompleted = false;

  DisplayAnimationManager({required this.vsync, required this.dataCubit}) {
    initDegreesAndShowLines();
  }

  void initDegreesAndShowLines() {
    for (var i = 0; i < dataCubit.dataItems.length; i++) {
      degrees.add(0);
      showLines.add(false);
    }
  }

  void initializeAnimations() {
    _initTextAnimation();
    _initDonutChartAnimation();
    _initLineAnimation();
    _textController.forward();
    Future.delayed(const Duration(seconds: 2), () {
      _startAllLineTimers();
      _lineController.forward();
    });
  }

  void _initTextAnimation() {
    _textController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: vsync,
    );
    animation = Tween(begin: 200.0, end: -20.0).animate(_textController)
      ..addListener(() {
        onUpdate?.call();
      });
  }

  void _initDonutChartAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 1000 ~/ 60), (timer) {
      fullAngle += 360.0 / (_secondsToComplete * 1000 / 60);
      if (fullAngle >= 360.0) {
        fullAngle = 360.0;
        timer.cancel();
        _chartCompleted = true;
      }
      onUpdate?.call();
    });
  }

  void _initLineAnimation() {
    _lineController = AnimationController(
      duration: Duration(seconds: 6),
      vsync: vsync,
    );

    // Initialize line animations
    for (var item in dataCubit.dataItems) {
      animations.add(
        Tween<double>(begin: 0, end: item.value * 300).animate(
          CurvedAnimation(
            parent: _lineController,
            curve: Curves.easeInOut,
          ),
        ),
      );
    }

    // استمع لاكتمال أنيميشن الخطوط
    _lineController.addListener(() {
      onUpdate?.call();
    });
  }

  void _startAllLineTimers() {
    // أوقف أي timers سابقة
    for (var timer in _lineTimers) {
      timer.cancel();
    }
    _lineTimers.clear();

    // ابدأ timers جديدة لكل عنصر
    for (int i = 0; i < dataCubit.dataItems.length; i++) {
      _startLineTimer(i);
    }
  }

  void _startLineTimer(int index) {
    final targetValue = (dataCubit.dataItems[index].value * 100).toInt();
    final duration = const Duration(seconds: 2); // مدة زيادة الرقم
    final steps = targetValue;
    final stepDuration = duration ~/ steps;

    showLines[index] = true; // أظهر الخط فوراً

    int currentStep = 0;

    final timer = Timer.periodic(stepDuration, (timer) {
      if (currentStep < steps) {
        degrees[index] = ((currentStep + 1) * targetValue ~/ steps);
        currentStep++;
        onUpdate?.call();
      } else {
        degrees[index] = targetValue; // تأكد من الوصول للقيمة النهائية
        timer.cancel();
        _lineTimers.remove(timer);
        onUpdate?.call();
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