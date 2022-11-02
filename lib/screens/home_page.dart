import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_assignment/db/course_database.dart';
import 'package:flutter_assignment/models/course_data.dart';
import 'package:flutter_assignment/providers/data_provider.dart';
import 'package:flutter_assignment/widgets/data_display_view.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController controller;
  late DataProvider provider;
  bool isLoadingComplete = false;
  bool loadMoreRunning = false;
  bool hasNextPage = true;
  bool isInternetConnectivity = true;
  List<CourseData> sqlList = [];
  bool firstLoadDone = true;

  @override
  void dispose() {
    controller.dispose();
    page = 1;
    super.dispose();
  }

  @override
  void initState() {
    provider = Provider.of<DataProvider>(context, listen: false);
    provider.firstLoadData().then((loadDone) {
      firstLoadDone = loadDone;
      provider.checkInternetConnectivity().then((isNet) {
        isInternetConnectivity = isNet;
        CourseDatabase.instance.readAllCourses().then((sqlL) {
          sqlList = sqlL;
          setState(() {
            isLoadingComplete = true;
          });
        });
      });
    }, onError: (err) {
      setState(() {
        isLoadingComplete = true;
      });
    });
    controller = ScrollController()
      ..addListener(() {
        if (controller.position.maxScrollExtent == controller.offset) {
          loadMoreData();
        }
      });
    super.initState();
  }

  Future<void> loadMoreData() async {
    debugPrint("ENTER HERE");
    setState(() {
      loadMoreRunning = true;
    });
    page += 1;
    List<CourseData> newAddedList = [];
    try {
      final response = await http.get(Uri.parse(
          "https://api.github.com/users/JakeWharton/repos?page=$page&per_page=15"));
      final List result = (json.decode(response.body));

      debugPrint("RESULT DATA2: $result");
      debugPrint("LENGTH02: ${result.length}");
      if (result.isNotEmpty) {
        for (int i = 0; i < result.length; i++) {
          var data = result[i];
          CourseData c = CourseData(
              id: data['id'] ?? 0,
              name: data['name'] ?? "Nothing",
              description: data['description'] ?? "No description",
              language: data['language'] ?? "None",
              watchersCount: data['watchers_count'] ?? 0,
              stargazerCount: data['stargazers_count'] ?? 0);
          newAddedList.add(c);
          debugPrint("MY MY MY");
          await CourseDatabase.instance.create(c);
          // provider.courseList.add(
          //   CourseData(
          //       id: data['id'] ?? 0,
          //       name: data['name'] ?? "Nothing",
          //       description: data['description'] ?? "No description",
          //       language: data['language'] ?? "None",
          //       watchersCount: data['watchers_count'] ?? 0,
          //       stargazerCount: data['stargazers_count'] ?? 0),
          // );
        }
        provider.courseList.addAll(newAddedList);
        setState(() {
          loadMoreRunning = false;
        });
      } else {
        setState(() {
          hasNextPage = false;
        });
      }
    } catch (e) {
      debugPrint("ERROR IS HERE.");
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: const Text(
            "Jane's Git",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          )),
      body: isLoadingComplete
          ? SizedBox(
              // height: size.height * 0.98,
              width: size.width * 0.95,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.015,
                    ),
                    SizedBox(
                      height: size.height * 0.89,
                      child:
                          // !firstLoadDone
                          //     ? const Center(
                          //         child: Text(
                          //           "No Net Connection",
                          //           style: TextStyle(
                          //             color: Colors.black,
                          //             fontSize: 18,
                          //             fontWeight: FontWeight.bold,
                          //           ),
                          //         ),
                          //       )
                          ListView.builder(
                        controller: controller,
                        itemBuilder: (ctx, index) {
                          // if (!isInternetConnectivity) {
                          debugPrint(
                              "SQL LIST: $sqlList \n SQL LIST LENGTH: ${sqlList.length}");
                          debugPrint(
                              "COURSE LIST LENGTH: ${provider.courseList.length}");
                          // }
                          if (!isInternetConnectivity
                              ? index < sqlList.length
                              : index < provider.courseList.length) {
                            return DataDisplayView(
                                size: size,
                                dataContent: !isInternetConnectivity
                                    ? sqlList[index]
                                    : provider.courseList[index]);
                          } else {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 25),
                              child: Center(
                                child: hasNextPage
                                    ? const CircularProgressIndicator(
                                        color: Colors.black,
                                      )
                                    : const Text("No More Data to Load!"),
                              ),
                            );
                          }
                        },
                        itemCount: isInternetConnectivity
                            ? provider.courseList.length + 1
                            : sqlList.length,
                        // shrinkWrap: true,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    )
                  ],
                ),
              ),
            )
          : const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child:
                  Center(child: CircularProgressIndicator(color: Colors.red)),
            ),
    );
  }
}
