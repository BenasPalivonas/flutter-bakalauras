import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Lecture {
  final String subject;
  final DateTime time;
  final String venue;

  Lecture({required this.subject, required this.time, required this.venue});
}

List<Lecture> lectures = [
  Lecture(
      subject: "Mathematics",
      time: DateTime(2023, 4, 2, 10, 0),
      venue: "Room 101"),
  Lecture(
      subject: "Computer Science",
      time: DateTime(2023, 4, 2, 14, 0),
      venue: "Room 202"),
  Lecture(
      subject: "English", time: DateTime(2023, 4, 3, 9, 0), venue: "Room 303"),
  Lecture(
      subject: "History", time: DateTime(2023, 4, 4, 16, 0), venue: "Room 404"),
  Lecture(
      subject: "History", time: DateTime(2023, 4, 4, 16, 0), venue: "Room 404"),
  Lecture(
      subject: "History", time: DateTime(2023, 4, 4, 16, 0), venue: "Room 404"),
  Lecture(
      subject: "History", time: DateTime(2023, 4, 4, 16, 0), venue: "Room 404"),
  Lecture(
      subject: "History", time: DateTime(2023, 4, 4, 16, 0), venue: "Room 404"),
  Lecture(
      subject: "History", time: DateTime(2023, 4, 4, 16, 0), venue: "Room 404"),
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
          title: Text("Paskaitos"),
          bottom: TabBar(
            tabs: [
              Tab(text: "Today"),
              Tab(text: "Tomorrow"),
              Tab(text: "All Week"),
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
              ReturnDayInLithuanian(dayOfWeek),
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
                title: Text(lecture.subject),
                subtitle:
                    Text("Time: ${lecture.time} - Venue: ${lecture.venue}"),
              );
            },
          ),
        ],
      );
    },
  );
}

String ReturnDayInLithuanian(String dayOfTheWeek) {
  if (dayOfTheWeek == "Monday") {
    return "Pirmadienis";
  }
  if (dayOfTheWeek == "Tuesday") {
    return "Antradienis";
  }
  if (dayOfTheWeek == "Wednesday") {
    return "Trečiadienis";
  }
  if (dayOfTheWeek == "Thursday") {
    return "Ketvirtadienis";
  }
  if (dayOfTheWeek == "Friday") {
    return "Penktadienis";
  }
  if (dayOfTheWeek == "Saturday") {
    return "Šeštadienis";
  }
  if (dayOfTheWeek == "Sunday") {
    return "Sekmadienis";
  }

  return "";
}
