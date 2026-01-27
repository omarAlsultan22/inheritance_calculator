import 'dart:ui';


class ColorsConstants {

  static const int zero = 0;
  static const int one = 1;
  static const int tow = 2;
  static const int there = 3;
  static const int four = 4;
  static const int five = 5;

  static const List<Color> palette = [
    Color(0xFFF2387C),
    Color(0xFF05C7F2),
    Color(0xFF04D9C4),
    Color(0xFFF2B705),
    Color(0xFFF26241),
    Color(0xFFF25241),
  ];

  static Color getColor(int index) {
    assert(index >= 0 && index < palette.length);
    return palette[index];
  }
}