///////////////////////////////////////////////////////////////////////////////
// file: PageEntry.dart
// author: Caleb Terry
// last edit: 07/18/2021
// description: controls all aspects for a single PageEntry given a ListEntry 
//              object
///////////////////////////////////////////////////////////////////////////////

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'ListEntry.dart';
import 'AlertWidget.dart';

// PageEntry does little besides creating it state class
class PageEntry extends StatefulWidget {
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
  void _addEntry(ListEntry entry) {
    bool _switchValue = true;  // new entry list or just entry
    String _newTitle = "";  // new entry title
    String _newDescription = "";  // new entry description
    String _displayValue = "List";  // value to be displayed next to switch
    Navigator.of(context).push(  // pushes the route to the Navigator's stack
      MaterialPageRoute<void>(
        // builder property returns a scaffold containing the app bar for the new route (new page)
        // the body of the new route consists of a ListView containing the ListTiles rows, each row is separated by a divider
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text("New List"),
              actions: [IconButton(icon: Icon(Icons.check), onPressed: () {
                // if (_newTitle == "") { Alert(); }  // no input, show alert to user
                // else { entry.push(ListEntry(_newTitle, description: _newDescription, list: _switchValue)); }
                entry.push(ListEntry(_newTitle, description: _newDescription, list: _switchValue));
                // _gotoPage(entry);  // going back to page that entry was added on 
                Navigator.of(context).pop();
              }),],
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
                      _newTitle = newVal;  // storing name of list
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
                    onChanged: (newVal) { _newDescription = newVal; }  // storing description of list
                  ),
                ),
                SwitchListTile(
                  title: Text(_displayValue),
                  value: _switchValue,
                  onChanged: (bool value) {
                    setState(() {
                      _switchValue = value;
                      if (_switchValue) { _displayValue = "List"; }
                      else { _displayValue = "Entry"; }
                    });
                  },
                ),
              ]
            )
          );
        },
      ),
    );
    // NOTE: there is automatically a back arrow in the Add List menu, did not have to explicitly implement Navigator.pop
  }

  // function to build the listview that displays the pages content
  Widget _buildPage(ListEntry page) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: /*1*/ (context, i) {
        if (i.isOdd) return const Divider();  // divider for each row
        int index = i ~/ 2;
        // if (index < page.getLength()) { return _buildRow(page, page.getEntry(index)); }  // entry for row
        try { return _buildRow(page, page.getEntry(index)); }
        catch (e) { print(e); }
        return Container();  // end of list, no more entries
      },
    );
  }
  
  // lays out each individual row for PageEntry
  Widget _buildRow(ListEntry page, ListEntry entry) {
    // return ListTile(
    //   title: Text(
    //     entry.getTitle(),  // name for current list
    //     style: _biggerFont,
    //   ),
    //   subtitle: Text(entry.getDescription()),
    //   // trailing: Icon(Icons.list),  // putting the list icon to the side because they are movable
    //   onTap: (() {  // what happens when the row is tapped
    //   // goto that list PageEntry if is a list
    //     if (entry.isList()) { _gotoPage(entry); }  // otherwise do nothing
    //     // calling setState() triggers a call to the build method for the State object, resulting in an update to the UI
    //     setState(() {}); 
    //   }),
    // );
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
          onTap: (() {  // what happens when the row is tapped
            // goto that list PageEntry if is a list
            if (entry.isList()) { _gotoPage(entry); }  // otherwise do nothing
            // calling setState() triggers a call to the build method for the State object, resulting in an update to the UI
            setState(() {}); 
          }),
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
                  onPressed:  () { 
                    _addEntry(page);
                    setState(() {});
                  } 
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
  void _gotoArchive() {
    Navigator.of(context).push(  // pushes the route to the Navigator's stack
      MaterialPageRoute<void>(
        // builder property returns a scaffold containing the app bar for the new route (new page)
        // the body of the new route consists of a ListView containing the ListTiles rows, each row is separated by a divider
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(_archivePage.getTitle()),
              actions: [
                IconButton(
                  icon: Icon(Icons.add), 
                  onPressed:  () { 
                    _addEntry(_archivePage);
                    setState(() {});
                  } 
                ),
              ],
            ),
            body: _buildPage(_archivePage),
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

  // share entry
  void _share(ListEntry entry) {

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

  // deletes the entry from teh page
  void _delete(ListEntry page, ListEntry entry) { 
    page.pop(page); 
    setState(() {});
  }

  // edits the given entry
  void _editEntry(ListEntry entry) {
    String _newTitle = entry.getTitle();
    String _newDescription = entry.getDescription();
    String _displayValue;
    bool _switchValue = entry.isList();
    if (entry.isList()) { _displayValue = "List"; }
    else { _displayValue = "Entry"; }
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
                    entry.setTitle(_newTitle);
                    entry.setDescription(_newDescription);
                    entry.setList(_switchValue);
                    setState(() {});
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
                SwitchListTile(
                  title: Text(_displayValue),
                  value: _switchValue,
                  onChanged: (bool value) {
                    setState(() {
                      _switchValue = value;
                      if (_switchValue) { _displayValue = "List"; }
                      else { _displayValue = "Entry"; }
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  /////////////////
  // public
  /////////////////
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_homePage.getTitle()),
        // NOTE: whatever is inserted in the "icon" parameter is what will show in the top right
        actions: [
          IconButton(
            icon: Icon(Icons.archive), 
            onPressed: () { _gotoArchive(); } 
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