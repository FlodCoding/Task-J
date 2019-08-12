import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskItemBean {
  int id;
  bool isStart;
  AppInfoBean _appInfoBean;
  TimeBean _timeBean;

  TaskItemBean({int id = 0, @required TimeBean time, @required AppInfoBean appInfo, bool start = true}) {
    this.id = id;
    isStart = start;
    _timeBean = time;
    _appInfoBean = appInfo;
  }

  AppInfoBean get appInfoBean => _appInfoBean;

  TimeBean get timeBean => _timeBean;

  TaskItemBean.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    isStart = json['isStart'];
    _appInfoBean = json['appInfo'] != null ? AppInfoBean.fromJson(json['appInfo']) : null;
    _timeBean = json['time'] != null ? TimeBean.fromJson(json['time']) : null;
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = id;
    data['isStart'] = isStart;
    if (_timeBean != null) {
      data['time'] = _timeBean.toJson();
    }

    if (_appInfoBean != null) {
      data['appInfo'] = _appInfoBean.toJson();
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

  TimeBean({@required DateTime dateTime, List<dynamic> repeatInWeek, bool repeat = false}) {
    if (repeatInWeek == null) repeatInWeek = List.generate(7, (index) => false);
    this.repeatInWeek = repeatInWeek.cast();
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

  TimeBean.fromJson(Map<String, dynamic> json) {
    repeat = json['repeat'];
    repeatInWeek = json['repeatInWeek'];
    dateTime = DateTime.fromMillisecondsSinceEpoch(json['dateTime']);
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

  AppInfoBean.fromJson(Map<String, dynamic> json) {
    appName = json['appName'];
    appIconBytes = json['appIconBytes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['appName'] = appName;
    data['appIconBytes'] = appIconBytes;
    return data;
  }
}
