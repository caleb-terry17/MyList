///////////////////////////////////////////////////////////////////////////////
// file: main.dart
// author: Caleb Terry
// last edit: 07/18/2021
// description: runs the My List app
///////////////////////////////////////////////////////////////////////////////

import 'package:flutter/material.dart';
import 'PageEntry.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My List',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: PageEntry(),
    );
  }
}
