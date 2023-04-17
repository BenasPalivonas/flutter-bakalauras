import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import '../api_constants.dart';

class ApiService {
  Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };

  Future<List<Object>?> getLecturers() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.lecturers);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        print(response.body);
        return [];
      }
    } catch (e) {
      log(e.toString());
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
