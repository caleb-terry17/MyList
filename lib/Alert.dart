///////////////////////////////////////////////////////////////////////////////
// file: Alert.dart
// author: Caleb Terry
// last edit: 08/11/2021
// description: creates a pop up widget with text input
///////////////////////////////////////////////////////////////////////////////
import 'package:flutter/material.dart';

class Alert extends StatefulWidget {
  /////////////////
  // private
  /////////////////
  
  // private data members
  String _alert = "";  // alert to show to user
  
  /////////////////
  // public
  /////////////////
  
  // constructors
  Alert(String alert, { Key? key }) : super(key: key) {
    this._alert = alert;
  }

  // public member functions
  @override
  _AlertState createState() => _AlertState();

  // public accessor functions
  String getAlert() { return _alert; }
}

class _AlertState extends State<Alert> {
  /////////////////
  // private
  /////////////////
  
  /////////////////
  // public
  /////////////////
  
  // public member functions
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: AlertDialog(
        title: Text(widget.getAlert()),
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            child: Text("Ok"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}