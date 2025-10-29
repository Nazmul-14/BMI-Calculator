import 'package:flutter/material.dart';

import 'BMI_Calculator.dart';
class MyApp extends StatelessWidget {
  const MyApp ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',

      home: BmiCalculator(),
    );
  }
}
