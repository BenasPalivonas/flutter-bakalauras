import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';

import 'package:flutter/material.dart';

class ListItem {
  String name;
  String subject;
  String details;

  ListItem({required this.name, required this.subject, required this.details});

  void showDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(subject),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${name}'),
              SizedBox(height: 8),
              Text('Subject: ${subject}'),
              SizedBox(height: 8),
              Text('Additional Details:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(details),
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
}

class MyListItem extends StatelessWidget {
  final ListItem item;

  MyListItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name),
      subtitle: Text(item.subject),
      onTap: () {
        item.showDetails(context);
      },
    );
  }
}

class Calendar extends StatefulWidget {
  @override
  CalendarState createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    print(LocalizationDelegate);
    return (EventCalendar(
      calendarType: CalendarType.GREGORIAN,
      calendarLanguage: translate('current_locale.locale'),
      headerOptions: HeaderOptions(monthStringType: MonthStringTypes.FULL),
      eventOptions: EventOptions(emptyText: ''),
      events: [
        Event(
          child: MyListItem(
              item: new ListItem(
                  name: 'Test',
                  subject: 'test',
                  details: 'additional details')),
          dateTime: CalendarDateTime(
            year: 2023,
            month: 4,
            day: 3,
            calendarType: CalendarType.GREGORIAN,
          ),
        ),
        Event(
          child: MyListItem(
              item: new ListItem(
                  name: 'Test1',
                  subject: 'test1',
                  details: 'additional details')),
          dateTime: CalendarDateTime(
            year: 2023,
            month: 4,
            day: 3,
            calendarType: CalendarType.GREGORIAN,
          ),
        ),
      ],
    )); // return
  }
}
