import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ui/services/api_service.dart';

class MyListScreen extends StatefulWidget {
  const MyListScreen({Key? key}) : super(key: key);

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
          automaticallyImplyLeading: false,
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
            const Expanded(
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
  List<Assignment> _filteredItems = [];

  void _filterLecturers(String searchQuery) {
    setState(() {
      _filteredItems = _items
          .where((assignment) =>
              assignment.name
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
              assignment.subject.name
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
              assignment.details
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getAssignments();
    _completed = widget.completed;

    setState(() => {_filteredItems = _items});
  }

  bool checkIfGraded(Grade grade, bool completed) {
    return grade.student.username.toString() == USER_NUMBER;
  }

  Future<void> getAssignments() async {
    setState(() {
      isLoading = true;
    });
    try {
      var response = (await ApiService().getAssignments())!;
      setState(() {
        _items = response
            .where((item) => _completed == true
                ? item.grades.any((grade) => checkIfGraded(grade, _completed))
                : !item.grades.any((grade) => checkIfGraded(grade, _completed)))
            .toList();

        _filteredItems = _items;
      });
    } catch (e) {
      log(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: translate('contacts.search_lecturers'),
                        ),
                        onChanged: _filterLecturers,
                      )),
                  Expanded(
                      child: Scrollbar(
                    child: ListView(
                      shrinkWrap: true,
                      children: _filteredItems.map((item) {
                        return ListTile(
                          title: Text(item.name),
                          subtitle: Text(
                              '${item.subject.name} - ${DateFormat('yyyy-MM-dd HH:mm').format(item.date)}'),
                          textColor: Colors.black,
                          onTap: () {
                            showDetails(context, item);
                          },
                        );
                      }).toList(),
                    ),
                  )),
                ],
              ),
            ),
          );
  }
}

Future<String> _openSubjectSelector(
    BuildContext context, String _filteredBy) async {
  // fetch subjects from api

  List<String> subjects = [translate('filter.show_all')];
  var response = await (ApiService().getSubjects())!;
  var responseNames = response?.map((e) => e.name).toList() ?? [];

  subjects.addAll(responseNames);

  String selectedSubject = await showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 200,
        child: Scaffold(
          appBar: AppBar(
              title: Text(_filteredBy.isEmpty
                  ? translate('filter.select_title')
                  : '${translate('filter.currently_filtered')} ${_filteredBy}'),
              backgroundColor: _filteredBy.isEmpty ? Colors.blue : Colors.green,
              automaticallyImplyLeading: false),
          body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
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

void _showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ),
  );
}

void showDetails(BuildContext context, Assignment item) {
  inspect(item);
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
            const SizedBox(height: 8),
            Text(
                '${translate('modal.subject')} ${translate(item.subject.name)}'),
            SizedBox(height: item.lecturer == null ? 0 : 8),
            item.lecturer == null
                ? const Text('')
                : Text('${translate('modal.lecturer')} ${item.lecturer?.name}'),
            SizedBox(height: item.venue == null ? 0 : 8),
            item.venue == null
                ? const Text('')
                : Text("${translate('subtitles.venue')}: ${item.venue?.name}"),
            const SizedBox(height: 8),
            Text(
                '${translate('modal.date')} ${DateFormat('yyyy-MM-dd HH:mm').format(item.date)}'),
            const SizedBox(height: 8),
            Text(
                '${translate('modal.grade')} ${item.grades.length > 0 ? item.grades.firstWhere((grade) => grade != null ? grade.student.username.toString() == USER_NUMBER : false)?.grade ?? 'N/A' : 'N/A'}'),
            const SizedBox(height: 16),
            Text('${translate('modal.additional_details')}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(item.details),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
