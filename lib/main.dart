import 'package:flutter/material.dart';

import 'page/HomePage.dart';
import 'page/TaskDetail.dart';
import 'page/condition/TimePickerPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'PingFang',
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: {
        "/TaskDetailPage": (context) => TaskDetailPage(),
        "/TimePickerPage": (context) => TimePickerPage(),
      },
    );
  }
}
