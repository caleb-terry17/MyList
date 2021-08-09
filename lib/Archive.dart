///////////////////////////////////////////////////////////////////////////////
// file: Archive.dart
// author: Caleb Terry
// last edit: 08/09/2021
// description: controls archive page for list app
///////////////////////////////////////////////////////////////////////////////

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'PageEntry.dart';
import 'Settings.dart';

class Archive extends StatefulWidget {
  /////////////////
  // private
  /////////////////
  
  // private data members
  final _archive = <PageEntry>[];  // holds all page entries added to archive
  
  /////////////////
  // public
  /////////////////
  
  // constructors
  Archive({ Key? key }) : super(key: key);

  // public member functions
  @override
  _ArchiveState createState() => _ArchiveState();
  bool hasEntry(PageEntry entry) { return _archive.contains(entry); }

  // public accessor functions
  int getLength() { return _archive.length; }

  // mutator functions
  void addEntry (PageEntry entry) { _archive.add(entry); }
  void popEntry (PageEntry entry) { _archive.remove(entry); }  // NOTE: need to also iterate through and see if any of its children are here as well
}

class _ArchiveState extends State<Archive> {
  /////////////////
  // private
  /////////////////
  
  // private data members
  final _biggerFont = const TextStyle(fontSize: 18.0);  // used to make the font size larger
  
  // private member functions
  
  // builds a row given an entry
  Widget _buildRow(PageEntry entry) {
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
  
  /////////////////
  // public
  /////////////////
  
  // public member functions
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Archive"),  // widget is a reference to the stateful widget
        backgroundColor: headingColor,
        /*actions: [],*/
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: widget.getLength(),
        itemBuilder: (context, i) {
          return _buildRow(_archive[i]);
        },
      ),
    );
  }
}