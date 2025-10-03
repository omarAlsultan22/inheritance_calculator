import 'dart:ui';
import 'data_model.dart';


class InheritanceState {
  bool done = false;
  bool isHere = false;
  double extra = 1.0;
  double value = 0.0;

  final Map<String, int> heirsCount = {};
  final Map<String, bool> heirsDone = {};
  final Map<String, String> heirsDetails = {};
  final List<DataItems> dataset = [];

  static const List<int> _pal = [
    0xFFF2387C, // Light Pink
    0xFF05C7F2, // Sky Blue
    0xFF04D9C4, // Teal
    0xFFF2B705, // Yellow
    0xFFF26241, // Dark Red
    0xFFF25241  // Red
  ];

  void reset() {
    done = false;
    isHere = false;
    extra = 1.0;
    value = 0.0;
    heirsCount.clear();
    heirsDone.clear();
    heirsDetails.clear();
    dataset.clear();
  }
  void addHeir(String heir, String detailsText, double share, int colorIndex) {
    if (!heirsDone.containsKey(heir)) {
      heirsDetails[heir] = detailsText;
      extra -= share;
      dataset.add(DataItems(share, heir, Color(_pal[colorIndex])));
      heirsDone[heir] = true;
    }
  }
}