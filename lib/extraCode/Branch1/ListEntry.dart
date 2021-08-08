///////////////////////////////////////////////////////////////////////////////
// file: ListEntry.dart
// author: Caleb Terry
// last edit: 07/18/2021
// description: contains ListEntry object class and methods
///////////////////////////////////////////////////////////////////////////////

// class to hold each list
class ListEntry {
  /////////////////
  // private
  /////////////////
  
  // private data members
  late String _title;
  late String _description;
  var _subList = <ListEntry>[];
  bool _isList = true;

  /////////////////
  // public 
  /////////////////
  
  // constructor
  ListEntry(String title, { String description = "", bool list = true }) {
    this._title = title;
    this._description = description;
    this._isList = list;
  }

  // public accessor functions
  String getTitle() { return this._title; }
  String getDescription() { return this._description; }
  int getLength() { return _subList.length; }
  ListEntry getEntry(int index) {
    // if valid index return entry otherwise null
    return (index < _subList.length ? _subList[index] : throw("No value in list"));
  }
  bool isList() { return _isList; }
  
  // public mutator functions
  void setTitle(String title) { this._title = title; }
  void setDescription(String description) { this._description = description; }
  void setList(bool isList) {
    if (isList) { this._isList = true; }
    else { this._isList = false; }
  }
  void push(ListEntry entry) { this._subList.add(entry); }
  void pop(ListEntry entry) { this._subList.remove(entry); }
  bool contains(ListEntry entry) { return this._subList.contains(entry); }
}
