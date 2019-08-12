import "dart:convert" show json;

import 'package:flutter/services.dart';
import 'package:task_j/model/bean/TaskItemBean.dart';

class CallNative {
  static const _platform = const MethodChannel('com.flod.task_j.android');

  static Future<AppInfoBean> selectApp() async {
    Map result = await _platform.invokeMethod('showInstallAppList');
    if (result == null) {
      return null;
    } else {
      var appName = result["appName"];
      var appIconBytes = result["appIconBytes"];
      return AppInfoBean(appName, appIconBytes);
    }
  }

  static Map<String, dynamic> covertToMap(TaskItemBean taskBean) {
    return <String, dynamic>{
      'id': taskBean.id,
      'appName': taskBean.appInfoBean.appName,
      'appIconBytes': taskBean.appInfoBean.appIconBytes,
      'repeat': taskBean.timeBean.repeat,
      'repeatInWeek': taskBean.timeBean.repeatInWeek,
      'dateTime': taskBean.timeBean.dateTime.millisecondsSinceEpoch,
      'isStart': taskBean.isStart,
    };
  }

  static TaskItemBean mapToTaskBean(Map map) {
    return TaskItemBean(
      id: map["id"],
      appInfo: AppInfoBean(map["appName"], map["appIconBytes"]),
      time: TimeBean(
          dateTime: DateTime.fromMillisecondsSinceEpoch(map["dateTime"]),
          repeatInWeek: map["repeatInWeek"],
          repeat: map["repeat"]),
      start: map["isStart"],
    );
  }

  static updateTask(TaskItemBean taskBean) async {
    var map = taskBean.toJson();
    _platform.invokeMethod('updateTask', map);
  }

  static deleteTask(int id) {
    _platform.invokeMethod('deleteTask', <String, dynamic>{"id": id});
  }

  static Future<List<TaskItemBean>> getSavedList() async {
    dynamic result = await _platform.invokeMethod('getTaskList');

    var resultList = json.decode(result);
    if (resultList is List) {
      return resultList.map((f) {
        TaskItemBean.fromJson(f);
      }).toList();
    }

    return null;
  }
}
