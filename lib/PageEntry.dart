///////////////////////////////////////////////////////////////////////////////
// file: PageEntry.dart
// author: Caleb Terry
// last edit: 08/12/2021
// description: controls all aspects for a single PageEntry given a ListEntry 
//              object
///////////////////////////////////////////////////////////////////////////////
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share_plus/share_plus.dart'; 
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'Alert.dart';
import 'Settings.dart';

class PageEntry extends StatefulWidget {
  /////////////////
  // private
  /////////////////
  
  // private data members
  final _info = <String>["", ""];  // holds title in idx 0 and description in idx 1
  final _subPage = <PageEntry>[];  // holds all child pages for current page
  
  /////////////////
  // public
  /////////////////
    
  // constructor
  PageEntry(String title, {Key? key, description = ""}) : super(key: key) {
    _info[0] = title;
    _info[1] = description;
  }

  // public member functions
  @override
  _PageEntryState createState() => _PageEntryState();
  bool hasEntry(PageEntry entry) { return _subPage.contains(entry); }

  // public accessor functions
  String getTitle() { return _info[0]; }
  String getShortTitle() { 
    // returns a shortened version of the title if necessary
    return _info[0].length > 12 ? _info[0].substring(1, 12) + "..." : _info[0];
  }
  String getDescription() { return _info[1]; }
  PageEntry getEntry(int index) { return _subPage[index]; }
  int getLength() { return _subPage.length; }

  // public mutator functions
  void setTitle(String title) { _info[0] = title; }
  void setDescription(String description) { _info[1] = description; }
  void addEntry(PageEntry entry) { _subPage.add(entry); }
  void popEntry(PageEntry entry) { _subPage.remove(entry); }

  // converts the current page to a string
  String writeString(String str, int tabAmount) {
    // creating string tab
    String tab = '    ' * tabAmount;
    str += tab + '{\n';  // opening bracket
    str += tab + '"title":"' + this.getTitle() + '",\n';  // title
    str += tab + '"description":"' + this.getDescription() + '",\n';  // description
    // setting up for subpage
    str += tab + '"entries":[';  // opening brace
    // writing subcontents if has sub pages
    if (this.getLength() > 0) {
      str += '\n';
      for (int i = 0; i < this.getLength(); ++i) {
        str = this.getEntry(i).writeString(str, tabAmount + 1);
      }
      // adding tab before closing brace if their are entries
      str += tab;
    }
    
    str += ']\n';
    str += tab + '}\n';  // closing bracket
    return str;
  }

  // writes the current page into a file
  void writeFile(IOSink file, int tabAmount) {
    // creating string tab
    String tab = '    ' * tabAmount;
    file.write(tab + '{\n');  // opening bracket
    file.write(tab + '"title":"' + this.getTitle() + '",\n');  // title
    file.write(tab + '"description":"' + this.getDescription() + '",\n');  // description
    // setting up for subpage
    file.write(tab + '"entries":[');  // opening brace
    // writing subcontents if has sub pages
    if (this.getLength() > 0) {
      file.write('\n');
      for (int i = 0; i < this.getLength(); ++i) {
        this.getEntry(i).writeFile(file, tabAmount + 1);
      }
      // adding tab before closing brace if their are entries
      file.write(tab);
    }
    file.write(']\n');
    file.write(tab + '}\n');  // closing bracket
  }
}

class _PageEntryState extends State<PageEntry> {
  /////////////////
  // private
  /////////////////
  
  // private data members
  final _biggerFont = const TextStyle(fontSize: 18.0);  // used to make the font size larger

  // private member functions

  // private member functions
  // adds entry to the current page
  void _addEntry(PageEntry page) {
    String _newTitle = "";
    String _newDescription = "";
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text("New List"),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.check), 
                  onPressed: () {
                    // adding new entry to page
                    setState(() {  // updates the page to include the newly added entry
                      // checking if there is input
                      if (_newTitle == "") { 
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) {
                              return Alert("No title entered"); 
                            },
                          ),
                        );
                      }
                      else { 
                        page.addEntry(PageEntry(_newTitle, description: _newDescription)); 
                        Navigator.of(context).pop();  // added entry, going back to page
                      }
                    });
                  }
                ),
              ],
            ),
            body: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "List Title",
                    ),
                    minLines: 1,
                    maxLines: 5,
                    onChanged: (newVal) { 
                      setState(() { _newTitle = newVal; });  // storing title of list
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextField( 
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "List Description",
                    ),
                    minLines: 1,
                    maxLines: 5,
                    onChanged: (newVal) { 
                      setState(() { _newDescription = newVal; });  // storing description of list
                    }  
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // builds the current page
  Widget _buildPage(PageEntry page) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: page.getLength(),
      itemBuilder: (context, i) {
        return _buildRow(page, page.getEntry(i));
      },
    );
  }

  // lays out each individual row for PageEntry
  Widget _buildRow(PageEntry page, PageEntry entry) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        // color: Colors.white,
        child: ListTile(
          // leading: CircleAvatar(
          //   backgroundColor: Colors.indigoAccent,
          //   // child: Text('$3'),
          //   foregroundColor: Colors.white,
          // ),
          title: Text(
            entry.getTitle(),
            style: _biggerFont,
          ),
          subtitle: Text(entry.getDescription()),
          onTap: (() { _gotoPage(entry); }),
          onLongPress: (() { _editEntry(entry); }),
        ),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Share',
          color: Colors.indigo,
          icon: Icons.share,
          onTap: () => _share(entry),
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => _delete(page, entry),
        ),
      ],
    );
  }

  // function will take you to page input
  // will handle pushing routes to the Navigators stack whenever entries are added or unadded
  // content for the new page is built in MaterialPageRoute's builder property in an anonymous function
  void _gotoPage(PageEntry page) {
    Navigator.of(context).push(  // pushes the route to the Navigator's stack
      MaterialPageRoute<void>(
        // builder property returns a scaffold containing the app bar for the new route (new page)
        // the body of the new route consists of a ListView containing the ListTiles rows, each row is separated by a divider
        builder: (BuildContext context) { return page; },
      ),
    );
    // NOTE: there is automatically a back arrow in the Add List menu, did not have to explicitly implement Navigator.pop
  }

  // displays settings page
  void _gotoSettings() {
    Navigator.of(context).push(  // pushes the route to the Navigator's stack
      MaterialPageRoute<void>(
        // builder property returns a scaffold containing the app bar for the new route (new page)
        // the body of the new route consists of a ListView containing the ListTiles rows, each row is separated by a divider
        builder: (BuildContext context) { return Settings(); },
      ),
    );
  }

  // edits the given entry
  void _editEntry(PageEntry entry) {
    String _newTitle = entry.getTitle();
    String _newDescription = entry.getDescription();
    Navigator.of(context).push(  // pushes the route to the Navigator's stack
      MaterialPageRoute<void>(
        // builder property returns a scaffold containing the app bar for the new route (new page)
        // the body of the new route consists of a ListView containing the ListTiles rows, each row is separated by a divider
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(entry.getShortTitle()),
              actions: [
                IconButton(
                  icon: Icon(Icons.check), 
                  onPressed:  () { 
                    // need to save changes
                    setState(() {
                      entry.setTitle(_newTitle);
                      entry.setDescription(_newDescription);
                    });
                    Navigator.of(context).pop();
                  } 
                ),
              ],
            ),
            body: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: entry.getTitle(),
                    ),
                    minLines: 1,
                    maxLines: 5,
                    controller: TextEditingController(
                      text: _newTitle,
                    ),
                    onChanged: (newVal) {
                      _newTitle = newVal;  // storing new title
                    }
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: entry.getDescription(),
                    ),
                    minLines: 1,
                    maxLines: 5,
                    controller: TextEditingController(
                      text: _newDescription,
                    ),
                    onChanged: (newVal) {
                      _newDescription = newVal;  // storing new description
                    }
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // share entry
  void _share(PageEntry page) async {
    // getting path for file
    String dirPath = (await getApplicationDocumentsDirectory()).path;
    // setting filename
    String fileName = page.getTitle() + '.json';
    // getting path for file
    String filePath = dirPath + '_' + fileName;
    // creating file
    IOSink file = new File(filePath).openWrite();
    // writing to file
    widget.writeFile(file, 0);
    // closing file
    file.close();
    // sharing file
    await Share.shareFiles(
      [
        filePath
      ], 
      subject: 'Sharing Page: ' + page.getTitle(), 
      text: page.writeString("", 0),  // temporary until i fix the problem of not attaching a file
    );
  }

  // deletes the entry from the page
  void _delete(PageEntry page, PageEntry entry) {  
    setState(() { 
      page.popEntry(entry); 
    });
  }

  /////////////////
  // public
  /////////////////
  // public member functions
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.getShortTitle()),  // widget is a reference to the stateful widget
        backgroundColor: headingColor,
        actions: [
          // IconButton(
          //   icon: Icon(Icons.settings),
          //   onPressed: () { _gotoSettings(); }
          // ),
          IconButton(
            icon: Icon(Icons.add), 
            onPressed: () { _addEntry(widget); } 
          ),
        ],
      ),
      body: _buildPage(widget),
    );
  }
}