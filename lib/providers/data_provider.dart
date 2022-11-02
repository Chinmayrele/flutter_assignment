import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assignment/db/course_database.dart';
import 'package:http/http.dart' as http;

import '../models/course_data.dart';

int page = 1;

class DataProvider with ChangeNotifier {
  // bool loadMoreDone = false;
  String apiUrl =
      "https://api.github.com/users/JakeWharton/repos?page=$page&per_page=15";

  List<CourseData> courseList = [];

  Future<bool> firstLoadData() async {
    courseList.clear();
    try {
      final response = await http.get(Uri.parse(apiUrl));
      final List result = (json.decode(response.body));

      debugPrint("RESULT DATA: $result");
      debugPrint("LENGTH OF RESULT: ${result.length}");
      if (result.isNotEmpty) {
        for (int i = 0; i < result.length; i++) {
          debugPrint("LOOP: $i");
          var data = result[i];
          CourseData c = CourseData(
              id: data['id'] ?? 0,
              name: data['name'] ?? "Nothing",
              description: data['description'] ?? "No description",
              language: data['language'] ?? "None",
              watchersCount: data['watchers_count'] ?? 0,
              stargazerCount: data['stargazers_count'] ?? 0);
          courseList.add(c);
          debugPrint("1");
          // await CourseDatabase.instance.dropTabe();
          await CourseDatabase.instance.create(c);
          debugPrint("2");
        }
      }
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<bool> checkInternetConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      return false;
    }
    return true;
  }
}
