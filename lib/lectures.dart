import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:ui/services/api_service.dart';

List<Lecture> _todayLectures = [];
List<Lecture> _tomorrowLectures = [];
List<Lecture> _allWeekLectures = [];

class LecturePage extends StatefulWidget {
  const LecturePage({Key? key}) : super(key: key);
  // lectures = (await ApiService().getLectures())!;

  @override
  _LecturePageState createState() => _LecturePageState();
}

class _LecturePageState extends State<LecturePage> {
  late List<Lecture> lectures = [];
  bool isLoading = false;
  @override
  initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var answer = (await ApiService().getLectures());
      Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
            lectures = answer!;
            isLoading = false;
          }));
    } catch (e) {
      log(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    Weekday today = Weekday.values[now.weekday - 1];
    Weekday tomorrow = Weekday.values[(now.weekday) % 7];

    _todayLectures =
        lectures.where((lecture) => lecture.weekday == today).toList();

    _tomorrowLectures =
        lectures.where((lecture) => lecture.weekday == tomorrow).toList();

    _allWeekLectures = lectures;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(translate('lectures_tabs.title')),
          bottom: TabBar(
            tabs: [
              Tab(text: translate("lectures_tabs.today")),
              Tab(text: translate("lectures_tabs.tomorrow")),
              Tab(text: translate("lectures_tabs.all_week")),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildLectureList(_todayLectures, isLoading),
            _buildLectureList(_tomorrowLectures, isLoading),
            _buildLectureList(_allWeekLectures, isLoading),
          ],
        ),
      ),
    );
  }
}

Widget _buildLectureList(List<Lecture> lectures, bool isLoading) {
  Map<String, List<Lecture>> groupedLectures = {};
  // group lectures by day of the week
  for (var lecture in lectures) {
    String dayOfWeek = lecture.weekday.name;
    if (!groupedLectures.containsKey(dayOfWeek)) {
      groupedLectures[dayOfWeek] = [];
    }
    groupedLectures[dayOfWeek]?.add(lecture);
  }

  // build list view with section headers for each day
  return isLoading
      ? Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        )
      : ListView.builder(
          itemCount: groupedLectures.length,
          itemBuilder: (context, index) {
            String dayOfWeek = groupedLectures.keys.elementAt(index);
            List<Lecture> dayLectures = groupedLectures[dayOfWeek]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // section header with day of week name
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    translate("weekDay.${dayOfWeek}"),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // list of lectures for the day
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: dayLectures.length,
                  itemBuilder: (context, index) {
                    Lecture lecture = dayLectures[index];
                    return ListTile(
                      title: Text("${lecture.subject.name.tr}"),
                      trailing: Text(lecture.time),
                      subtitle: Text(
                          "${translate('subtitles.venue')}: ${lecture.venue} - ${translate('subtitles.lecturer')}: ${lecture.lecturer.name}"),
                      textColor: Colors.black,
                    );
                  },
                ),
              ],
            );
          },
        );
}
