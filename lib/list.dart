import 'package:flutter/material.dart';

class Item {
  final String name;
  final String subject;
  final String date;
  final String details;
  bool isCompleted;

  Item({
    required this.name,
    required this.subject,
    required this.date,
    required this.details,
    required this.isCompleted,
  });
}

class ClickableList extends StatefulWidget {
  @override
  _ClickableListState createState() => _ClickableListState();
}

class _ClickableListState extends State<ClickableList> {
  final List<Item> _items = [
    Item(
        name: 'John',
        subject: 'Flutter',
        date: 'March 1, 2023',
        details: 'This is some additional details about Flutter',
        isCompleted: true),
    Item(
        name: 'Jane',
        subject: 'Dart',
        date: 'March 2, 2023',
        details: 'This is some additional details about Dart',
        isCompleted: false),
    Item(
        name: 'Bob',
        subject: 'Widgets',
        date: 'March 3, 2023',
        details: 'This is some additional details about Widgets',
        isCompleted: false),
  ];

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
              Text('Name: ${item.name}'),
              SizedBox(height: 8),
              Text('Subject: ${item.subject}'),
              SizedBox(height: 8),
              Text('Date: ${item.date}'),
              SizedBox(height: 16),
              Text('Additional Details:',
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

  void _toggleComplete(Item item) {
    setState(() {
      item.isCompleted = !item.isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clickable List'),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(
              _items[index].subject,
              style: _items[index].isCompleted
                  ? TextStyle(decoration: TextDecoration.lineThrough)
                  : null,
            ),
            subtitle: Text(_items[index].name),
            trailing: Text(_items[index].date),
            onTap: () {
              _showDetails(_items[index]);
            },
            onLongPress: () {
              _toggleComplete(_items[index]);
            },
          );
        },
      ),
    );
  }
}
