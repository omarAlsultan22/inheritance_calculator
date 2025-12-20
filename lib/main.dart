import 'package:men/screens/selection_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:men/shared/cubit/cubit.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(
      MultiBlocProvider(
          providers: [
            BlocProvider<DataCubit>(create: (context) => DataCubit())
          ],
          child: const MyApp()));
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SelectionScreen(),
    );
  }
}







