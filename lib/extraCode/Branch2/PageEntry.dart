///////////////////////////////////////////////////////////////////////////////
// file: PageEntry.dart
// author: Caleb Terry
// last edit: 07/18/2021
// description: controls all aspects for a single PageEntry given a ListEntry 
//              object
///////////////////////////////////////////////////////////////////////////////

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'ListEntry.dart';

class PageEntry extends StatefulWidget {
  /////////////////
  // private
  /////////////////
  
  /////////////////
  // public
  /////////////////
  final String title;  // fileds in a Widget subclass are always marked final

  // constructor
  PageEntry({Key? key, required this.title}) : super(key: key);

  @override
  _PageEntryState createState() => _PageEntryState();
}

class _PageEntryState extends State<PageEntry> {
  /////////////////
  // private
  /////////////////
  
  // private data members
  var _homePage = ListEntry("Home", description: "Home Page");  // list entries for home page
  var _archivePage = ListEntry("Archive", description: "Archive Page");  // list entries that have been archived
  final _biggerFont = const TextStyle(fontSize: 18.0);  // used to make the font size larger

  // private member functions
  // creates a new entry in the page input
  void _addEntry(ListEntry page) {
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
                    setState(() { page.push(ListEntry(_newTitle, description: _newDescription)); });  // updates the page to include the newly added entry
                    Navigator.of(context).pop();  // added entry, going back to page
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

  // builds the page input
  Widget _buildPage(ListEntry page) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: page.getLength(),
      itemBuilder: /*1*/ (context, i) {
        // int index = i ~/ 2;
        // if (i.isOdd) return const Divider();  // divider for each row
        return _buildRow(page, page.getEntry(i));
      },
    );
  }

  // lays out each individual row for PageEntry
  Widget _buildRow(ListEntry page, ListEntry entry) {
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
        ),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Archive',
          color: Colors.blue,
          icon: Icons.archive,
          onTap: () => _archive(entry),
        ),
        IconSlideAction(
          caption: 'Edit',
          color: Colors.indigo,
          icon: Icons.edit,
          onTap: () => _editEntry(entry),
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'More',
          color: Colors.black45,
          icon: Icons.more_horiz,
          onTap: () => _more(entry),
        ),
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
  void _gotoPage(ListEntry page) {
    Navigator.of(context).push(  // pushes the route to the Navigator's stack
      MaterialPageRoute<void>(
        // builder property returns a scaffold containing the app bar for the new route (new page)
        // the body of the new route consists of a ListView containing the ListTiles rows, each row is separated by a divider
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(page.getTitle()),
              actions: [
                IconButton(
                  icon: Icon(Icons.add), 
                  onPressed: () { _addEntry(page); } 
                ),
              ],
            ),
            body: _buildPage(page),
          );
        },
      ),
    );
    // NOTE: there is automatically a back arrow in the Add List menu, did not have to explicitly implement Navigator.pop
  }

  // function to create archive page
  void _gotoArchive(ListEntry archivePage) {
    Navigator.of(context).push(  // pushes the route to the Navigator's stack
      MaterialPageRoute<void>(
        // builder property returns a scaffold containing the app bar for the new route (new page)
        // the body of the new route consists of a ListView containing the ListTiles rows, each row is separated by a divider
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(archivePage.getTitle()),
              actions: [
                // IconButton(
                  // icon: Icon(Icons.add), 
                  // onPressed:  () { 
                  //   _addEntry(archivePage);
                  //   setState(() {});
                  // }  // SHOULD YOU BE ABLE TO ADD A PAGE ONLY TO ARCHIVE? CARTER QUESTION??
                // ),
              ],
            ),
            body: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: archivePage.getLength(),
              itemBuilder: /*1*/ (context, i) {
                // int index = i ~/ 2;
                // if (i.isOdd) return const Divider();  // divider for each row
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
                        archivePage.getEntry(i).getTitle(),
                        style: _biggerFont,
                      ),
                      subtitle: Text(archivePage.getEntry(i).getDescription()),
                      onTap: (() { _gotoArchive(archivePage.getEntry(i)); }),
                    ),
                  ),
                  actions: <Widget>[
                    // IconSlideAction(  // don't need to archive something already in archive
                    //   caption: 'Archive',
                    //   color: Colors.blue,
                    //   icon: Icons.archive,
                    //   onTap: () => _archive(archivePage.getEntry(i)),
                    // ),
                    IconSlideAction(
                      caption: 'Edit',
                      color: Colors.indigo,
                      icon: Icons.edit,
                      onTap: () => _editEntry(archivePage.getEntry(i)),
                    ),
                  ],
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'More',
                      color: Colors.black45,
                      icon: Icons.more_horiz,
                      onTap: () => _more(archivePage.getEntry(i)),
                    ),
                    IconSlideAction(
                      caption: 'Remove',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () => _delete(archivePage, archivePage.getEntry(i)),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  // archives entry given
  void _archive(ListEntry entry) {
    // making sure that entry is not aleady in archive
    if (!_archivePage.contains(entry)) { _archivePage.push(entry); }
  }

  // edits the given entry
  void _editEntry(ListEntry entry) {
    String _newTitle = entry.getTitle();
    String _newDescription = entry.getDescription();
    String _displayValue;
    Navigator.of(context).push(  // pushes the route to the Navigator's stack
      MaterialPageRoute<void>(
        // builder property returns a scaffold containing the app bar for the new route (new page)
        // the body of the new route consists of a ListView containing the ListTiles rows, each row is separated by a divider
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(entry.getTitle()),
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
                    onChanged: (newVal) {
                      _newTitle = newVal;  // storing new name
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
                    onChanged: (newVal) {
                      _newDescription = newVal;  // storing new name
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

  // goes to page with more options for list
  void _more(ListEntry entry) {
    Navigator.of(context).push(  // pushes the route to the Navigator's stack
      MaterialPageRoute<void>(
        // builder property returns a scaffold containing the app bar for the new route (new page)
        // the body of the new route consists of a ListView containing the ListTiles rows, each row is separated by a divider
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(entry.getTitle()),
              actions: [],
            ),
            body: ListView(
              children: [
                ListTile(
                  title: Text("Share"),
                  onTap: () {
                    _share(entry);
                  },
                ),
                ListTile(
                  title: Text("more2"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // share entry
  void _share(ListEntry entry) {

  }

  // deletes the entry from the page
  void _delete(ListEntry page, ListEntry entry) {  
    setState(() { 
      page.pop(entry); 
      // if in archive, pop as well
      if (_archivePage.contains(entry)) { _archivePage.pop(entry); }
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
        title: Text(widget.title),  // widget is a reference to the stateful widget
        actions: [
          IconButton(
            icon: Icon(Icons.archive), 
            onPressed: () { _gotoArchive(_archivePage); } 
          ), 
          IconButton(
            icon: Icon(Icons.add), 
            onPressed: () { _addEntry(_homePage); } 
          ),
        ],
      ),
      body: _buildPage(_homePage),
    );
  }
}