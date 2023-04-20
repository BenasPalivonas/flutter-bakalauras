import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';
import 'api_constants.dart';

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
    print(body.toString());

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      log('Successfully created assignment');
    } else {
      print('Failed to create assignment');
    }
  }

  // API GUIDE https://blog.codemagic.io/rest-api-in-flutter/
  Future<bool> Login(Object apiBody) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.login);
      var response =
          await http.post(url, headers: headers, body: jsonEncode(apiBody));
      if (response.statusCode == 200) {
        print(json.decode(response.body)['success']);
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
  final String venue;
  final Lecturer? lecturer;
  final Weekday weekday;

  Lecture({
    required this.id,
    required this.subject,
    required this.time,
    required this.venue,
    required this.lecturer,
    required this.weekday,
  });

  factory Lecture.fromJson(Map<String, dynamic> json) {
    return Lecture(
      id: json['id'].toString(),
      subject: Subject.fromJson(json['subject']),
      time: json['time'],
      venue: json['venue'],
      lecturer:
          json['lecturer'] == null ? null : Lecturer.fromJson(json['lecturer']),
      weekday: Weekday.values[Weekday.values
          .map((e) => e.toString().split('.')[1])
          .toList()
          .indexOf(json['day_of_week'].toString().toLowerCase())],
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
  final Lecturer? lecturer;

  Assignment({
    this.id,
    required this.name,
    required this.subject,
    required this.date,
    required this.details,
    this.lecturer,
    required this.completed,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'subject_id': subject.id,
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
      lecturer:
          json['lecturer'] == null ? null : Lecturer.fromJson(json['lecturer']),
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
