///////////////////////////////////////////////////////////////////////////////
// file: PageEntry.dart
// author: Caleb Terry
// last edit: 08/09/2021
// description: controls all aspects for a single PageEntry given a ListEntry 
//              object
///////////////////////////////////////////////////////////////////////////////

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'Settings.dart';

// global variables
PageEntry archivePage = new PageEntry("Archive");  // page to store all archived pages

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
}

class _PageEntryState extends State<PageEntry> {
  /////////////////
  // private
  /////////////////
  
  // private data members
  final _biggerFont = const TextStyle(fontSize: 18.0);  // used to make the font size larger

  // private member functions

  // private member functions
  // creates a new entry in the page input
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
                      if (_newTitle == "") { _showAlert("No title entered"); }
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
        // int index = i ~/ 2;
        // if (i.isOdd) return const Divider();  // divider for each row
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
          caption: 'Archive',
          color: Colors.blue,
          icon: Icons.archive,
          onTap: () => _archive(entry),
        ),
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

  // displays archive page
  void _gotoArchive(PageEntry page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return _buildArchivePage(page);
        },
      ),
    );
  }

  // builds page for archive
  Widget _buildArchivePage(PageEntry page) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: page.getLength(),
      itemBuilder: (context, i) {
        // int index = i ~/ 2;
        // if (i.isOdd) return const Divider();  // divider for each row
        return _buildArchiveRow(page, page.getEntry(i));
      },
    );
  }

  // builds row for archive
  Widget _buildArchiveRow(PageEntry page, PageEntry entry) {
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
          onTap: (() { _gotoArchive(entry); }),
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
          caption: 'Remove',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => _delete(page, entry),
        ),
      ],
    );
  }

  // archives entry given
  void _archive(PageEntry entry) {
    // making sure that entry is not aleady in archive
    if (!archivePage.hasEntry(entry)) { archivePage.addEntry(entry); }
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

  // goes to page with more options for list
  void _more(PageEntry entry) {
    Navigator.of(context).push(  // pushes the route to the Navigator's stack
      MaterialPageRoute<void>(
        // builder property returns a scaffold containing the app bar for the new route (new page)
        // the body of the new route consists of a ListView containing the ListTiles rows, each row is separated by a divider
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(entry.getShortTitle()),
              backgroundColor: headingColor,
              actions: [],
            ),
            body: ListView(
              children: [
                ListTile(
                  title: Text("Option 1"),
                  tileColor: Colors.blue,
                  // trailing: Icon(Icons.share),
                  onTap: () {
                    _share(entry);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // share entry
  void _share(PageEntry entry) {

  }

  // deletes the entry from the page
  void _delete(PageEntry page, PageEntry entry) {  
    setState(() { 
      page.popEntry(entry); 
      // if in archive, pop as well
      // NOTE: need to also iterate through entry to see if any of its children are in archive
      if (archivePage.hasEntry(entry)) { archivePage.popEntry(entry); }
    });
  }

  // shows alert input to user
  void _showAlert(String alert) {
    Navigator.of(context).push(  // pushes the route to the Navigator's stack
      MaterialPageRoute<void>(
        // builder property returns a scaffold containing the app bar for the new route (new page)
        // the body of the new route consists of a ListView containing the ListTiles rows, each row is separated by a divider
        builder: (BuildContext context) {
          return Container(
            color: Colors.white,
            child: AlertDialog(
              title: Text(alert),
              backgroundColor: Colors.white,
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // saves page to json file
  _savePage(PageEntry page) {

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
            icon: Icon(Icons.archive), 
            onPressed: () { _gotoArchive(archivePage); }
          ),
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