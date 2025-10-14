import 'inheritance_state_model.dart';

abstract class HeirProcessor {
  late int? count;
  late InheritanceState? state;

  HeirProcessor({this.state, this.count});

  void process();
}