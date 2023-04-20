import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:ui/services/api_service.dart';

String filteredBy = '';

class MyListScreen extends StatefulWidget {
  @override
  _MyListScreenState createState() => _MyListScreenState();
}

class _MyListScreenState extends State<MyListScreen> {
  int _currentIndex = 0;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: _currentIndex,
      child: Scaffold(
        appBar: AppBar(
          title: Text(translate('assignments.title')),
        ),
        body: Column(
          children: [
            TabBar(
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              tabs: [
                Tab(
                  text: translate('assignments.not_completed'),
                ),
                Tab(
                  text: translate('assignments.completed'),
                ),
              ],
              dividerColor: Colors.blue,
              indicatorColor: Colors.blue,
              labelColor: Colors.blue,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ClickableList(
                    completed: false,
                  ),
                  ClickableList(
                    completed: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClickableList extends StatefulWidget {
  final bool completed;

  const ClickableList({Key? key, required this.completed}) : super(key: key);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<ClickableList> {
  bool _completed = false;
  bool isLoading = false;
  List<Assignment> _items = [];
  List<Assignment> _originalItems = [];
  String _filteredBy = filteredBy;

  @override
  void initState() {
    super.initState();
    getAssignments();
    _completed = widget.completed;
    _originalItems = _items;
    _filteredBy = filteredBy;
    if (filteredBy.isNotEmpty) {
      setState(() => {
            if (filteredBy == 'Show all')
              {_items = _originalItems}
            else
              {
                _items = _originalItems
                    .where((element) => element.subject.name == filteredBy)
                    .toList()
              }
          });
    }
  }

  Future<void> getAssignments() async {
    setState(() {
      isLoading = true;
    });
    try {
      var response = (await ApiService().getAssignments())!;
      setState(() {
        _items = response;
      });
    } catch (e) {
      log(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showDetails(Assignment item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(item.subject.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${translate('modal.name')} ${item.name}'),
              SizedBox(height: 8),
              Text('${translate('modal.subject')} ${item.subject.name}'),
              SizedBox(height: 8),
              Text('Lecturer: ${item.lecturer.name}'),
              SizedBox(height: 8),
              Text(
                  '${translate('modal.date')} ${DateFormat('yyyy-MM-dd HH:mm').format(item.date)}'),
              SizedBox(height: 16),
              Text('${translate('modal.additional_details')}',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(item.details),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _toggleItemCompletion(Assignment item) async {
    try {
      bool setCompleted = !item.completed;
      await ApiService().updateAssignment(item.id, setCompleted);
      setState(() {
        _items = _items.map((assignment) {
          if (assignment.id == item.id) {
            return Assignment(
              id: assignment.id,
              name: assignment.name,
              subject: assignment.subject,
              date: assignment.date,
              details: assignment.details,
              completed: setCompleted,
              lecturer: assignment.lecturer,
            );
          } else {
            return assignment;
          }
        }).toList();
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void _deleteItem(Assignment item) {
    setState(() {
      _items.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Scrollbar(
                    child: ListView(
                      shrinkWrap: true,
                      children: _items
                          .where((item) => item.completed == this._completed)
                          .map((item) {
                        return ListTile(
                          title: Text(item.name),
                          subtitle: Text(
                              '${item.subject.name} - ${DateFormat('yyyy-MM-dd HH:mm').format(item.date)}'),
                          textColor: Colors.black,
                          onTap: () {
                            _showDetails(item);
                          },
                          trailing: PopupMenuButton(
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem(
                                  child: Text(item.completed
                                      ? translate(
                                          'assignments.mark_as_not_completed')
                                      : translate(
                                          'assignments.mark_as_completed')),
                                  value: 'complete',
                                ),
                                // PopupMenuItem(
                                //   child: Text('Delete'),
                                //    value: 'delete',
                                // ),
                              ];
                            },
                            onSelected: (value) {
                              if (value == 'complete') {
                                _toggleItemCompletion(item);
                              }
                              // else if (value == 'delete') {
                              //   _deleteItem(item);
                              // }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  )),
                ],
              ),
            ),
            floatingActionButton:
                Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  //...
                },
                heroTag: null,
              ),
              SizedBox(
                height: 10,
              ),
              FloatingActionButton(
                child: Icon(Icons.search),
                backgroundColor:
                    _filteredBy.isEmpty ? Colors.blue : Colors.green,
                onPressed: () =>
                    _openSubjectSelector(context, _filteredBy).then((value) {
                  setState(() => {
                        if (value != null)
                          {
                            if (value == 'Show all')
                              {_items = _originalItems}
                            else
                              {
                                _items = _originalItems
                                    .where((element) =>
                                        element.subject.name == value)
                                    .toList()
                              }
                          }
                      });
                  setState(() {
                    if (value != null) {
                      if (value == 'Show all') {
                        _filteredBy = '';
                        filteredBy = '';
                      } else {
                        _filteredBy = value;
                        filteredBy = value;
                      }
                    }
                  });
                  return value;
                }),
                heroTag: null,
              ),
            ]));
  }
}

Future<String> _openSubjectSelector(
    BuildContext context, String _filteredBy) async {
  List<String> subjects = ['Show all', 'Personal', 'Work', 'Shopping'];
  String selectedSubject = await showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 200,
        child: Scaffold(
          appBar: AppBar(
              title: Text(_filteredBy.isEmpty
                  ? 'Select a subject to filter by'
                  : 'Currently filtered by ${_filteredBy}'),
              backgroundColor: _filteredBy.isEmpty ? Colors.blue : Colors.green,
              automaticallyImplyLeading: false),
          body: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0),
              child: (ListView.builder(
                itemCount: subjects.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(subjects[index]),
                    onTap: () {
                      Navigator.pop(context, subjects[index]);
                    },
                  );
                },
              ))),
        ),
      );
    },
  );
  return selectedSubject;
}

void _showSelectedSubjectSnackbar(
    BuildContext context, String selectedSubject) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Filtering by: ${selectedSubject}'),
      duration: Duration(days: 365),
      behavior: SnackBarBehavior.fixed,
      action: SnackBarAction(
        label: 'Clear filter',
        onPressed: () {},
      ),
    ),
  );
}
