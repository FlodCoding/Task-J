import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskItemBean {
  int id;
  bool isStart;
  AppInfoBean appInfoBean;
  TimeBean timeBean;

  TaskItemBean({int id = 0, @required TimeBean time, @required AppInfoBean appInfo, bool start = true}) {
    this.id = id;
    isStart = start;
    timeBean = time;
    appInfoBean = appInfo;
  }



  TaskItemBean.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'];
    isStart = jsonMap['isStart'];
    appInfoBean =
        jsonMap['appInfo'] != null ? AppInfoBean.fromJson(Map<String, dynamic>.from(jsonMap['appInfo'])) : null;
    timeBean = jsonMap['time'] != null ? TimeBean.fromJson(Map<String, dynamic>.from(jsonMap['time'])) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['isStart'] = isStart;
    if (timeBean != null) {
      data['time'] = timeBean.toJson();
    }

    if (appInfoBean != null) {
      data['appInfo'] = appInfoBean.toJson();
    }
    return data;
  }
}

class TimeBean {
  static String get strNoRepeat => "只执行一次";

  static String get strTomorrow => "明天";

  static String get strToday => "今天";


  List<bool> repeatInWeek;
  bool repeat;
  DateTime dateTime;

  TimeOfDay get timeOfDay => TimeOfDay.fromDateTime(dateTime);

  set timeOfDay(TimeOfDay timeOfDay) {
    dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, timeOfDay.hour, timeOfDay.minute);
  }

  TimeBean({@required DateTime dateTime, List<bool> repeatInWeek, bool repeat = false}) {
    if (repeatInWeek == null) repeatInWeek = List.generate(7, (index) => false);
    this.repeatInWeek = repeatInWeek;
    this.repeat = repeat;
    this.dateTime = dateTime;
  }



  String repeatInWeekStr() {
    repeat = repeatInWeek.any((element) => element);
    if (repeat) {
      bool isEveryDay = repeatInWeek.every((element) => element);
      if (isEveryDay) return "每天";
      return "${repeatInWeek[0] ? '周一 ' : ''}${repeatInWeek[1] ? '周二 ' : ''}${repeatInWeek[2] ? '周三 ' : ''}"
          "${repeatInWeek[3] ? '周四 ' : ''}${repeatInWeek[4] ? '周五 ' : ''}"
          "${repeatInWeek[5] ? '周六 ' : ''}${repeatInWeek[6] ? "周日 " : ''}";
    } else {
      return strNoRepeat;
    }
  }

  String dateToString() {
    DateTime now = DateTime.now();
    if (dateTime.day == now.day)
      return strToday;
    else if (dateTime.day == now.day + 1) {
      return strTomorrow;
    } else {
      return "${dateTime.year}-${dateTime.month}-${dateTime.day} ";
    }
  }

  String timeOfDayToString() {
    return DateFormat("HH:mm").format(dateTime);
  }

  @override
  String toString() {
    String repeatStr = repeat ? repeatInWeekStr() + "\n" : dateToString() + " ";
    return "$repeatStr${timeOfDayToString()}";
  }

  TimeBean.fromJson(Map<String, dynamic> jsonMap) {
    repeat = jsonMap['repeat'];
    repeatInWeek = List.castFrom(jsonMap['repeatInWeek']);
    dateTime = DateTime.fromMillisecondsSinceEpoch(jsonMap['dateTime']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['repeat'] = repeat;
    data['repeatInWeek'] = repeatInWeek;
    data['dateTime'] = dateTime.millisecondsSinceEpoch;
    return data;
  }
}

class AppInfoBean {
  String appName;
  Uint8List appIconBytes;

  AppInfoBean(
    this.appName,
    this.appIconBytes,
  );

  AppInfoBean.fromJson(Map<String, dynamic> jsonMap) {
    appName = jsonMap['appName'];
    appIconBytes = Uint8List.fromList(jsonMap['appIconBytes']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['appName'] = appName;
    data['appIconBytes'] = appIconBytes;
    return data;
  }
}
