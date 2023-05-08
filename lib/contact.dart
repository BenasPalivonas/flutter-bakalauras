import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:ui/services/api_service.dart';

class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  List<Lecturer> lecturers = [];
  List<Lecturer> _filteredLecturers = [];
  bool isLoading = false;

  void _filterLecturers(String searchQuery) {
    setState(() {
      _filteredLecturers = lecturers
          .where((lecturer) =>
              lecturer.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    });
  }

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
      var answer = (await ApiService().getLecturers());
      setState(() {
        lecturers = answer!;
        _filteredLecturers = answer!;
        isLoading = false;
      });
    } catch (e) {
      log(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
          child: ListView.builder(
            itemCount: _filteredLecturers.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(_filteredLecturers[index].name),
                subtitle: Text(_filteredLecturers[index].email),
              );
            },
          ),
        ),
      ],
    );
  }
}
