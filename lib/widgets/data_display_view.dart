import 'package:flutter/material.dart';
import 'package:flutter_assignment/models/course_data.dart';

class DataDisplayView extends StatelessWidget {
  const DataDisplayView({
    Key? key,
    required this.dataContent,
    required this.size,
  }) : super(key: key);
  final CourseData dataContent;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(
              height: 60,
              width: 40,
              child: Icon(
                Icons.save_rounded,
                size: 60,
              ),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dataContent.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: size.width * 0.75,
                  child: Text(
                    dataContent.description,
                    style: const TextStyle(color: Colors.black54),
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                      size: 16,
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                      size: 16,
                    ),
                    Text(
                      dataContent.language,
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 16),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.adb,
                      color: Colors.black,
                    ),
                    Text(
                      dataContent.watchersCount.toString(),
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 16),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.face,
                      color: Colors.black,
                    ),
                    Text(
                      dataContent.stargazerCount.toString(),
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 16),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
        const Divider(color: Colors.grey),
      ],
    );
  }
}
