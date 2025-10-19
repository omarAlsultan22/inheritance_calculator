import 'inheritance_state_model.dart';

abstract class HeirProcessor {
  int count;
  InheritanceState? state;

  HeirProcessor({this.state, this.count = 0});

  void process();
}