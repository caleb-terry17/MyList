///////////////////////////////////////////////////////////////////////////////
// file: Settings.dart
// author: Caleb Terry
// last edit: 08/09/2021
// description: controls settings menu for page entry
///////////////////////////////////////////////////////////////////////////////
import 'package:flutter/material.dart';

// global variables
Color headingColor = Colors.white;
final colorAry = <Color>[
  Colors.pink,       Colors.red,        Colors.deepOrange,
  Colors.orange,     Colors.amber,      Colors.yellow,
  Colors.lime,       Colors.lightGreen, Colors.green,
  Colors.teal,       Colors.cyan,       Colors.lightBlue, 
  Colors.blue,       Colors.indigo,     Colors.purple, 
  Colors.deepPurple, Colors.blueGrey,   Colors.brown, 
  Colors.grey
];
final blackAry = <Color>[
  Colors.black,   Colors.black12, Colors.black26,
  Colors.black38, Colors.black45, Colors.black54, 
  Colors.black87
];
final whiteAry = <Color>[
  Colors.white,   Colors.white10, Colors.white12, 
  Colors.white24, Colors.white30, Colors.white38, 
  Colors.white54, Colors.white60, Colors.white70
];

class Settings extends StatefulWidget {
  /////////////////
  // private
  /////////////////
  
  /////////////////
  // public
  /////////////////
  
  // constructor
  const Settings({ Key? key }) : super(key: key);

  // public member functions
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  /////////////////
  // private
  /////////////////
  
  // private member functions

  // creates a menu of colors to select from
  Future<Color> _chooseColor() {
    Color choice = Colors.white;
    Navigator.of(context).push(  // pushes the route to the Navigator's stack
      MaterialPageRoute<void>(
        // builder property returns a scaffold containing the app bar for the new route (new page)
        // the body of the new route consists of a ListView containing the ListTiles rows, each row is separated by a divider
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Colors"),
              backgroundColor: headingColor,
              actions: [],
            ),
            body: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: (colorAry.length/* + blackAry.length + whiteAry.length*/),
              itemBuilder: (context, i) {
                Color currColor = colorAry[i];
                // if (i < colorAry.length) { currColor = colorAry[i]; }
                // else if (i < colorAry.length + blackAry.length) { currColor = blackAry[i - colorAry.length]; }
                // else { currColor = whiteAry[i - colorAry.length - blackAry.length]; }
                return ListTile(
                  title: Text("List Title"),
                  tileColor: currColor,
                  onTap: () {
                    setState(() { choice = currColor; });
                    Navigator.of(context).pop();
                  }
                );
              },
            ),
          );
        },
      ),
    );
    return Future.value(choice);
  }

  // // finds color based on number input
  // Color _findColor(int index) {
  //   // if from color ary
  //   if (index < colorAry.length * 10) {
  //     if (index % 10 == 0) {}  // 50
  //     else if (index % 10 == 5) {}  // 500/color itself
  //     else {}
  //   } else if (index < colorAry.length * 10 + blackAry.length) {  // black ary

  //   } else {  // white ary

  //   }
  //   return Colors.white;
  // }
  
  /////////////////
  // public
  /////////////////
  
  // public member functions
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: headingColor,
        actions: [],
      ),
      body: ListView(
        children: [
          ListTile(
            title: Center(
              child: Text("Heading Colors"),
            ),
            onTap: () async {
              setState(() async { 
                headingColor = await _chooseColor();
              });
            },
          ),
        ],
      ),
    );
  }
}