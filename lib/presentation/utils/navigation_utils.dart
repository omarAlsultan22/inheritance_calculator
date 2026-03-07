import 'package:flutter/material.dart';


class NavigationUtils {
  static Future<Object?> navigator(BuildContext context, Widget link) =>
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => link));
}
