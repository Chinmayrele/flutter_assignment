import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/course_data.dart';

int page = 1;

class DataProvider with ChangeNotifier {
  // bool loadMoreDone = false;
  String apiUrl =
      "https://api.github.com/users/JakeWharton/repos?page=$page&per_page=15";

  List<CourseData> courseList = [];

  Future<void> firstLoadData() async {
    final response = await http.get(Uri.parse(apiUrl));
    final result = (json.decode(response.body));

    debugPrint("RESULT DATA: $result");
    debugPrint("LENGTH: ${result.length}");
    if (result != null) {
      for (int i = 0; i < result.length; i++) {
        var data = result[i];
        courseList.add(
          CourseData(
              id: data['id'] ?? 0,
              name: data['name'] ?? "Nothing",
              description: data['description'] ?? "No description",
              language: data['language'] ?? "None",
              watchersCount: data['watchers_count'] ?? 0,
              stargazerCount: data['stargazers_count'] ?? 0),
        );
      }
    }
  }
}
