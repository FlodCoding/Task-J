import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'page/HomePage.dart';
import 'page/TaskDetail.dart';
import 'page/condition/TimePickerPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark));
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          fontFamily: 'PingFang',
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          backgroundColor: Colors.white),
      home: HomePage(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'), // 美国英语
        const Locale('zh', 'CN'), // 中文简体
      ],
      locale: const Locale('zh', 'CN'),
      routes: {
        "/TaskDetailPage": (context) => TaskDetailPage(),
        "/TimePickerPage": (context) => TimePickerPage(),
      },
    );
  }
}
