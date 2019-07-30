import 'package:flutter/material.dart';
import 'package:task_j/page/HomePage.dart';

import 'page/TaskDetail.dart';

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
      },
    );
  }
}
