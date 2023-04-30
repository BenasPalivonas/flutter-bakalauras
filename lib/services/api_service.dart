import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';
import 'api_constants.dart';

String USER_GROUP = '';
String USER_NUMBER = '';
String USER_ID = '';

class ApiService {
  Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  Future<List<Lecturer>?> getLecturers() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.lecturers);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List<dynamic>;
        return data.map((item) => Lecturer.fromJson(item)).toList();
      }
    } catch (e) {
      log(e.toString());
    }
    return [];
  }

  Future<List<Lecture>?> getLectures() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.lectures);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List<dynamic>;
        return data.map((item) => Lecture.fromJson(item)).toList();
      }
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<List<Subject>?> getSubjects() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.subjects);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List<dynamic>;
        return data.map((item) => Subject.fromJson(item)).toList();
      }
    } catch (e) {
      log(e.toString());
    }
    return [];
  }

  Future<List<Assignment>?> getAssignments() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.assignments);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List<dynamic>;
        return data.map((item) => Assignment.fromJson(item)).toList();
      }
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<void> updateAssignment(String id, bool completed) async {
    var url =
        Uri.parse(ApiConstants.baseUrl + ApiConstants.assignments + id + '/');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({'completed': completed});

    final response = await http.patch(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      log('Assignment $id updated successfully!');
    } else {
      log('Failed to update assignment $id');
    }
  }

  Future<void> createAssignment(Assignment assignment) async {
    var url =
        Uri.parse(ApiConstants.baseUrl + ApiConstants.assignments + 'create');
    headers:
    <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final body = jsonEncode(assignment.toJson());

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      log('Successfully created assignment');
    } else {
      print('Failed to create assignment');
    }
  }

  Future<bool> deleteAssignment(String id) async {
    var url =
        Uri.parse(ApiConstants.baseUrl + ApiConstants.assignments + id + "/");
    print(url);
    final response = await http.delete(url, headers: headers);
    inspect(response);
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  // API GUIDE https://blog.codemagic.io/rest-api-in-flutter/
  Future<bool> Login(dynamic apiBody) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.login);
      var response =
          await http.post(url, headers: headers, body: jsonEncode(apiBody));
      if (response.statusCode == 200) {
        USER_NUMBER = json.decode(response.body)['student_number'];
        USER_GROUP = json.decode(response.body)['student_group'];
        USER_ID = json.decode(response.body)['id'].toString();
        return json.decode(response.body)['success'];
      }
    } catch (e) {
      log(e.toString());
      return false;
    }

    return false;
  }
}

class Lecturer {
  final String id;
  final String name;
  final String email;

  Lecturer({
    required this.id,
    required this.name,
    required this.email,
  });

  factory Lecturer.fromJson(Map<String, dynamic> json) {
    return Lecturer(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
    );
  }
}

enum Weekday {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

extension WeekdayExtension on Weekday {
  String get name {
    switch (this) {
      case Weekday.monday:
        return 'Monday';
      case Weekday.tuesday:
        return 'Tuesday';
      case Weekday.wednesday:
        return 'Wednesday';
      case Weekday.thursday:
        return 'Thursday';
      case Weekday.friday:
        return 'Friday';
      case Weekday.saturday:
        return 'Saturday';
      case Weekday.sunday:
        return 'Sunday';
      default:
        return '';
    }
  }
}

class Lecture {
  final String id;
  final Subject subject;
  final String time;
  final Venue venue;
  final Lecturer? lecturer;
  final List<dynamic> studentGroups;
  final Weekday weekday;

  Lecture({
    required this.id,
    required this.subject,
    required this.time,
    required this.venue,
    required this.lecturer,
    required this.studentGroups,
    required this.weekday,
  });

  factory Lecture.fromJson(Map<String, dynamic> json) {
    return Lecture(
      id: json['id'].toString(),
      subject: Subject.fromJson(json['subject']),
      time: json['time'],
      venue: Venue.fromJson(json['venue']),
      studentGroups: (json['student_groups']
          .map((group) => StudentGroup.fromJson(group))
          .toList()),
      lecturer:
          json['lecturer'] == null ? null : Lecturer.fromJson(json['lecturer']),
      weekday: Weekday.values[Weekday.values
          .map((e) => e.toString().split('.')[1])
          .toList()
          .indexOf(json['day_of_week'].toString().toLowerCase())],
    );
  }
}

class StudentGroup {
  final String id;
  final String name;
  StudentGroup({
    required this.id,
    required this.name,
  });

  factory StudentGroup.fromJson(Map<String, dynamic> json) {
    return StudentGroup(
      id: json['id'].toString(),
      name: json['name'],
    );
  }
}

class Venue {
  final String id;
  final String name;
  Venue({
    required this.id,
    required this.name,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'].toString(),
      name: json['name'],
    );
  }
}

class Student {
  final String id;
  final String fullName;
  final String username;
  final String email;
  final StudentGroup studentGroup;
  Student({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.studentGroup,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'].toString(),
      fullName: json['full_name'],
      username: json['username'],
      email: json['email'],
      studentGroup: StudentGroup.fromJson(json['student_group']),
    );
  }
}

class Assignment {
  final String? id;
  final String name;
  final Subject subject;
  final DateTime date;
  final String details;
  final bool completed;
  final Venue? venue;
  final Lecturer? lecturer;
  // final String? student_id;

  Assignment({
    this.id,
    required this.name,
    required this.subject,
    required this.date,
    required this.details,
    this.lecturer,
    this.venue,
    // this.student_id,
    required this.completed,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'subject_id': subject.id,
        // 'student_id': student_id,
        'due_date': date.toIso8601String(),
        'details': details,
        'completed': completed,
      };

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'].toString(),
      name: json['name'],
      subject: Subject.fromJson(json['subject']),
      date: DateTime.parse(json['due_date']),
      details: json['details'],
      completed: json['completed'],
      venue: json['venue'] == null ? null : Venue.fromJson(json['venue']),
      lecturer:
          json['lecturer'] == null ? null : Lecturer.fromJson(json['lecturer']),
    );
  }

  void showDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(subject.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${translate('modal.name')} ${name}'),
              SizedBox(height: 8),
              Text('${translate('modal.subject')} ${subject.name}'),
              SizedBox(height: lecturer == null ? 0 : 8),
              lecturer == null
                  ? Text('')
                  : Text('${translate('modal.lecturer')} ${lecturer?.name}'),
              SizedBox(height: venue == null ? 0 : 8),
              venue == null
                  ? Text('')
                  : Text("${translate('subtitles.venue')}: ${venue?.name}"),
              SizedBox(height: 8),
              Text('${translate('modal.additional_details')} ',
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

class Subject {
  String id;
  String name;

  Subject({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'].toString(),
      name: json['name'],
    );
  }
}
