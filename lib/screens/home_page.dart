import 'dart:convert';

import 'package:flutter/material.dart';
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

  @override
  void initState() {
    provider = Provider.of<DataProvider>(context, listen: false);
    provider.firstLoadData().then((value) {
      setState(() {
        isLoadingComplete = true;
      });
    });
    controller = ScrollController()..addListener(loadMoreData);
    super.initState();
  }

  Future<void> loadMoreData() async {
    setState(() {
      loadMoreRunning = true;
    });
    page += 1;
    try {
      final response = await http.get(Uri.parse(
          "https://api.github.com/users/JakeWharton/repos?page=$page&per_page=15"));
      final List result = (json.decode(response.body));

      debugPrint("RESULT DATA2: $result");
      debugPrint("LENGTH02: ${result.length}");
      if (result.isNotEmpty) {
        for (int i = 0; i < result.length; i++) {
          var data = result[i];
          provider.courseList.add(
            CourseData(
                id: data['id'] ?? 0,
                name: data['name'] ?? "Nothing",
                description: data['description'] ?? "No description",
                language: data['language'] ?? "None",
                watchersCount: data['watchers_count'] ?? 0,
                stargazerCount: data['stargazers_count'] ?? 0),
          );
        }
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
                      height: size.height * 0.92,
                      child: ListView.builder(
                        controller: controller,
                        itemBuilder: (ctx, index) {
                          return DataDisplayView(
                              size: size,
                              dataContent: provider.courseList[index]);
                        },
                        itemCount: provider.courseList.length,
                        // shrinkWrap: true,
                      ),
                    ),
                    if (loadMoreRunning)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 40, top: 10),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    if (!hasNextPage)
                      Container(
                        padding: const EdgeInsets.only(top: 30, bottom: 40),
                        color: Colors.amber,
                        child: const Center(
                            child: Text("You Have Fetched All the Contents")),
                      )
                  ],
                ),
              ),
            )
          : const CircularProgressIndicator(),
    );
  }
}
