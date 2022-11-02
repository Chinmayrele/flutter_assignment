import 'package:flutter/material.dart';
import 'package:flutter_assignment/providers/data_provider.dart';
import 'package:flutter_assignment/screens/home_page.dart';
import 'package:flutter_assignment/screens/biometric_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DataProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const BiometricScreen(),
      ),
    );
  }
}
