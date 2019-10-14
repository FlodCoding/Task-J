import 'package:flutter/services.dart';
import 'package:task_j/model/bean/TaskItemBean.dart';

class CallNative {
  static const _platform = const MethodChannel('com.flod.task_j.android');

  static Future<AppInfoBean> selectApp() async {
    Map result = await _platform.invokeMethod('showInstallAppList');
    if (result == null) {
      //cancel
      return null;
    } else {
      return AppInfoBean.fromJson(Map<String, dynamic>.from(result));
    }
  }

  static Future<TaskBean> addTask(TaskBean taskBean) async {
    var map = taskBean.toJson();
    Map result = await _platform.invokeMethod('addTask', map);
    //回传储存进数据库的Id
    if (result != null) {
      Map<String, dynamic> jsonMap = Map<String, dynamic>.from(result);
      taskBean.id = jsonMap['id'];
      taskBean.timeBean.eventId = jsonMap['calendarId'];
      return taskBean;
    }

    return null;
  }

  static Future<Gesture> addGesture() async {
    Map result = await _platform.invokeMethod('addGesture');
    if (result != null) {
      return Gesture.fromJson(Map<String, dynamic>.from(result));
    }
    return null;
  }

  static updateTask(TaskBean taskBean) async {
    var map = taskBean.toJson();
    _platform.invokeMethod('updateTask', map);
  }

  static deleteTask(int id) {
    _platform.invokeMethod('deleteTask', <String, dynamic>{"id": id});
  }

  static Future<List<TaskBean>> getTaskList() async {
    dynamic result = await _platform.invokeMethod('getTaskList');
    if (result is List) {
      return result.map((f) => f = TaskBean.fromJson(Map<String, dynamic>.from(f))).toList();
    }

    return null;
  }
}
