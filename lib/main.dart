import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
      home: MyHomePage(),
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

class _MyHomePageState extends State<MyHomePage> {
  static const platform = const MethodChannel('com.flod.task_j.android/applist');
  Uint8List imageData = Uint8List(0);

// Get battery level.
  String _string = 'Unknown battery level.';

  Future<Null> _getBatteryLevel() async {
    try {
      Map<dynamic, dynamic> result = await platform.invokeMethod('showInstallAppList');

      _string = result["appName"];
      imageData = Base64Decoder().convert(result["appIconBytes"]);
    } on PlatformException catch (e) {}

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            new RaisedButton(
              child: new Text('Get Battery Level'),
              onPressed: _getBatteryLevel,
            ),
            new Text(_string),
            Image.memory(
              imageData,
              width: 200,
              height: 200,
            )
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyHomePageState();
  }
}
