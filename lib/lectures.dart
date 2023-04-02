import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class Lecture {
  final String subject;
  final DateTime time;
  final String venue;
  final String lectrurer;

  Lecture(
      {required this.subject,
      required this.time,
      required this.venue,
      required this.lectrurer});
}

List<Lecture> lectures = [
  Lecture(
      subject: "Matematika",
      time: DateTime(2023, 4, 2, 10, 0),
      venue: "101",
      lectrurer: "Vardenis Pavardenis"),
  Lecture(
      subject: "Matematika2",
      time: DateTime(2023, 4, 1, 10, 0),
      venue: "101",
      lectrurer: "Vardenis Pavardenis"),
  Lecture(
      subject: "Duomenų gavyba",
      time: DateTime(2023, 4, 2, 14, 0),
      venue: "202",
      lectrurer: "Vardenis Pavardenis"),
  Lecture(
      subject: "Anglų kalba",
      time: DateTime(2023, 4, 3, 9, 0),
      venue: "303",
      lectrurer: "Vardenis Pavardenis"),
  Lecture(
      subject: "Istorija",
      time: DateTime(2023, 4, 4, 16, 0),
      venue: "404",
      lectrurer: "Vardenis Pavardenis"),
  Lecture(
      subject: "Istorija",
      time: DateTime(2023, 4, 5, 16, 0),
      venue: "404",
      lectrurer: "Vardenis Pavardenis"),
];

List<Lecture> _todayLectures = [];
List<Lecture> _tomorrowLectures = [];
List<Lecture> _allWeekLectures = [];

class LecturePage extends StatefulWidget {
  const LecturePage({Key? key}) : super(key: key);

  @override
  _LecturePageState createState() => _LecturePageState();
}

class _LecturePageState extends State<LecturePage> {
  @override
  void initState() {
    super.initState();
    // Filter the lectures by today, tomorrow, and all week
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime tomorrow = today.add(Duration(days: 1));
    _todayLectures = lectures
        .where((lecture) =>
            lecture.time.isAfter(today) && lecture.time.isBefore(tomorrow))
        .toList();
    _tomorrowLectures = lectures
        .where((lecture) =>
            lecture.time.isAfter(tomorrow) &&
            lecture.time.isBefore(tomorrow.add(Duration(days: 1))))
        .toList();
    _allWeekLectures = lectures
        .where((lecture) =>
            lecture.time.isAfter(today) &&
            lecture.time.isBefore(tomorrow.add(Duration(days: 7))))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
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
            _buildLectureList(_todayLectures),
            _buildLectureList(_tomorrowLectures),
            _buildLectureList(_allWeekLectures),
          ],
        ),
      ),
    );
  }
}

Widget _buildLectureList(List<Lecture> lectures) {
  Map<String, List<Lecture>> groupedLectures = {};
  // group lectures by day of the week
  for (var lecture in lectures) {
    String dayOfWeek = DateFormat('EEEE').format(lecture.time);
    if (!groupedLectures.containsKey(dayOfWeek)) {
      groupedLectures[dayOfWeek] = [];
    }
    groupedLectures[dayOfWeek]?.add(lecture);
  }
  // build list view with section headers for each day
  return ListView.builder(
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
                title: Text("${lecture.subject.tr}"),
                trailing: Text(DateFormat('HH:mm').format(lecture.time)),
                subtitle: Text(
                    "${translate('subtitles.venue')}: ${lecture.venue} - ${translate('subtitles.lecturer')}: ${lecture.lectrurer}"),
                textColor: Colors.black,
              );
            },
          ),
        ],
      );
    },
  );
}
