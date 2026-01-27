import 'package:flutter/material.dart';


Future<Object?> navigator(BuildContext context, Widget link) =>
  Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => link));
