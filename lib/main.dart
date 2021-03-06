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
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // removes "debug" banner in top right
      title: 'My List',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: PageEntry('Home'),
    );
  }
}