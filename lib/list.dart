import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';

class Item {
  String name;
  String subject;
  DateTime date;
  String details;
  bool completed;

  Item(
      {required this.name,
      required this.subject,
      required this.date,
      required this.details,
      this.completed = false});
}

class MyListScreen extends StatefulWidget {
  @override
  _MyListScreenState createState() => _MyListScreenState();
}

class _MyListScreenState extends State<MyListScreen> {
  int _currentIndex = 0;

  List<Item> _items = [
    Item(
        name: 'Buy groceries',
        subject: 'Shopping',
        date: DateTime.now(),
        details: 'Milk, bread, eggs',
        completed: false),
    Item(
        name: 'Finish project',
        subject: 'Work',
        date: DateTime.now().add(Duration(days: 3)),
        details: 'Deadline on Friday',
        completed: false),
    Item(
        name: 'Call mom',
        subject: 'Personal',
        date: DateTime.now().add(Duration(days: 1)),
        details: 'Ask about her trip',
        completed: false),
    Item(
        name: 'Call mom',
        subject: 'Personal',
        date: DateTime.now().add(Duration(days: 1)),
        details: 'Ask about her trip',
        completed: false),
    Item(
        name: 'Call ben',
        subject: 'Personal',
        date: DateTime.now().add(Duration(days: 1)),
        details: 'Ask about her trip',
        completed: false),
    Item(
        name: 'Call ben',
        subject: 'Personal',
        date: DateTime.now().add(Duration(days: 1)),
        details: 'Ask about her trip',
        completed: false),
    Item(
        name: 'Call ben',
        subject: 'Personal',
        date: DateTime.now().add(Duration(days: 1)),
        details: 'Ask about her trip',
        completed: false),
    Item(
        name: 'Call ben',
        subject: 'Personal',
        date: DateTime.now().add(Duration(days: 1)),
        details: 'Ask about her trip',
        completed: false),
    Item(
        name: 'Call ben',
        subject: 'Personal',
        date: DateTime.now().add(Duration(days: 1)),
        details: 'Ask about her trip',
        completed: false),
    Item(
        name: 'Call meme',
        subject: 'Personal',
        date: DateTime.now().add(Duration(days: 1)),
        details: 'Ask about her trip',
        completed: true),
  ];

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
                    items: _items,
                  ),
                  ClickableList(
                    completed: true,
                    items: _items,
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
  final List<Item> items;

  const ClickableList({Key? key, required this.completed, required this.items})
      : super(key: key);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<ClickableList> {
  bool _completed = false;
  List<Item> _items = [];

  @override
  void initState() {
    super.initState();
    _completed = widget.completed;
    _items = widget.items;
  }

  void _showDetails(Item item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(item.subject),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${translate('modal.name')} ${item.name}'),
              SizedBox(height: 8),
              Text('${translate('modal.subject')} ${item.subject}'),
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

  void _toggleItemCompletion(Item item) {
    setState(() {
      item.completed = !item.completed;
    });
  }

  void _deleteItem(Item item) {
    setState(() {
      _items.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
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
                        '${item.subject} - ${DateFormat('yyyy-MM-dd HH:mm').format(item.date)}'),
                    textColor: Colors.black,
                    onTap: () {
                      _showDetails(item);
                    },
                    trailing: PopupMenuButton(
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(
                            child: Text(item.completed
                                ? translate('assignments.mark_as_not_completed')
                                : translate('assignments.mark_as_completed')),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
