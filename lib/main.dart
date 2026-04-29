import 'package:flutter/material.dart';

import 'package:hungry/root.dart';

void main() {
  runApp(Hungry());
}

class Hungry extends StatelessWidget {
  const Hungry({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      debugShowCheckedModeBanner: false,
      title: 'Hungry',
      home: Root(),
    );
  }
}
