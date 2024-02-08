import 'package:flutter/material.dart';
import 'package:twenty_forty_eight/home_page.dart';

class TwentyFortyEightApp extends StatelessWidget {
  const TwentyFortyEightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2048',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const TwentyFortyEightHomePage(),
    );
  }
}
