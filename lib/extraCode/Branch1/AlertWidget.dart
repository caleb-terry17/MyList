///////////////////////////////////////////////////////////////////////////////
// file: AlertWidget.dart
// author: Caleb Terry
// last edit: 07/18/2021
// description: creats structure for alert box to be used in multiple situations
///////////////////////////////////////////////////////////////////////////////

import 'package:flutter/material.dart';

// Alert class: stateful widget
class Alert extends StatefulWidget {
  _AlertState createState() => _AlertState();
}

class _AlertState extends State<Alert> {
  /////////////////
  // private
  /////////////////
  
  _showAlert(BuildContext context) {
    // Navigator.of(context).push(
    //   MaterialPageRoute<void>(
    //     showDialog(
    //       context: context,
    //       builder: (BuildContext context) {
    //         return AlertDialog(
    //           title: new Text('Alert Message Title Text.'),
    //           actions: <Widget>[
    //             TextButton(
    //               child: new Text("Okay"),
    //               onPressed: () { Navigator.of(context).pop(); },
    //             ),
    //           ],
    //         );
    //       },
    //     );
    //   );
    // );
  }

  /////////////////
  // public
  /////////////////
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
          ElevatedButton(
            onPressed: () => _showAlert(context),
            child: Text('Click Here to Show Alert Dialog Box'),
          ),
      ),
    );
  }
}