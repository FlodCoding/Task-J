import 'dart:typed_data';

import 'package:flutter/material.dart';

class TaskItemBean {
  TimeBean _timeBean;
  AppInfoBean _appInfoBean;

  TaskItemBean(this._timeBean, this._appInfoBean);

  AppInfoBean get appInfoBean => _appInfoBean;

  TimeBean get timeBean => _timeBean;


}

class TimeBean {
  List<bool> _repeatInWeek;
  DateTime _dateTime;

  List<bool> get repeatInWeek => _repeatInWeek;

  DateTime get dateTime => _dateTime;

  TimeBean({List<bool> repeatInWeek, DateTime dateTime, TimeOfDay timeOfDay}) {
    this._repeatInWeek = repeatInWeek;
    if (timeOfDay != null) {
      this._dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
          timeOfDay.hour, timeOfDay.minute);
    } else {
      this._dateTime = dateTime;
    }
  }

  static String repeatInWeekStr(List<bool> repeatInWeekList) {
    if (repeatInWeekList != null && repeatInWeekList.length == 7) {
      //选择了全部
      if (isEveryDay(repeatInWeekList)) {
        return "每天";
      } else
        return "${repeatInWeekList[0] ? '周一 ' : ''}${repeatInWeekList[1] ? '周二 ' : ''}${repeatInWeekList[2] ? '周三 ' : ''}"
            "${repeatInWeekList[3] ? '周四 ' : ''}${repeatInWeekList[4] ? '周五 ' : ''}"
            "${repeatInWeekList[5] ? '周六 ' : ''}${repeatInWeekList[6] ? "周日 " : ''}";
    }
    return "";
  }

  static bool isEveryDay(List<bool> repeatInWeekList) =>
      repeatInWeekList.every((element) => element);

  String format(BuildContext context) {
    bool isRepeat = _repeatInWeek.any((element) => element);
    String dateStr;
    if (isRepeat) {
      dateStr =
          "${isEveryDay(_repeatInWeek) ? "" : "每"}${repeatInWeekStr(_repeatInWeek)}";
    } else {
      DateTime now = DateTime.now();
      if (_dateTime.day == now.day)
        dateStr = "今天";
      else if (_dateTime.day == now.day + 1) {
        dateStr = "明天";
      } else {
        dateStr = "${_dateTime.year}-${_dateTime.month}-${_dateTime.day} ";
      }
    }

    return "$dateStr${TimeOfDay.fromDateTime(_dateTime).format(context)}";
  }

  @override
  String toString() {
    bool isRepeat = _repeatInWeek.any((element) => element);
    String dateStr;
    if (isRepeat) {
      dateStr =
          "${isEveryDay(_repeatInWeek) ? "" : "每"}${repeatInWeekStr(_repeatInWeek)}";
    } else {
      //TODO 有可能选完时间就过期
      DateTime now = DateTime.now();
      if (_dateTime.isAfter(now)) {
        if (_dateTime.day == now.day)
          dateStr = "今天";
        else if (_dateTime.day == now.day + 1) {
          dateStr = "明天";
        } else {
          dateStr = "${_dateTime.year}-${_dateTime.month}-${_dateTime.day}";
        }
      } else {
        //过期
        return "过期的时间";
      }
    }

    return "$dateStr ${format12Hour()}";
  }

  String format12Hour() {
    return "${_dateTime.hour == 0 ? 12 : (_dateTime.hour > 12 ? _dateTime.hour - 12 : _dateTime.hour)}:${_dateTime.minute}${_dateTime.hour > 11 ? "上午" : "下午"}";
  }
}

class AppInfoBean {
  String _appName;
  Uint8List _appIconBytes;

  AppInfoBean(this._appName,this._appIconBytes, );

  String get appName => _appName;

  Uint8List get appIconBytes => _appIconBytes;


}
