import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_event_calendar/flutter_event_calendar.dart';

import 'package:flutter/material.dart';
import 'package:ui/services/api_service.dart';

class MyListItem extends StatelessWidget {
  final Assignment item;

  MyListItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name),
      subtitle: Text(item.subject.name),
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
  List<Assignment> items = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getAssignments();
    print(userNumber);
  }

  Future<void> getAssignments() async {
    setState(() {
      isLoading = true;
    });
    try {
      var response = (await ApiService().getAssignments())!;
      setState(() {
        items = response;
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
    print(LocalizationDelegate);
    return (EventCalendar(
      calendarType: CalendarType.GREGORIAN,
      calendarLanguage: translate('current_locale.locale'),
      headerOptions: HeaderOptions(monthStringType: MonthStringTypes.FULL),
      eventOptions: EventOptions(emptyText: ''),
      events: items
          .map((e) => Event(
              child: MyListItem(item: e),
              dateTime: CalendarDateTime(
                year: e.date.year,
                month: e.date.month,
                day: e.date.day,
                calendarType: CalendarType.GREGORIAN,
              )))
          .toList(),
    )); // return
  }
}
