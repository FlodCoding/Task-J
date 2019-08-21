import 'package:flutter/services.dart';
import 'package:task_j/model/bean/TaskItemBean.dart';

class CallNative {
  static const _platform = const MethodChannel('com.flod.task_j.android');

  static Future<AppInfoBean> selectApp() async {
    Map result = await _platform.invokeMethod('showInstallAppList');
    if (result == null) {
      return null;
    } else {
      return AppInfoBean.fromJson(Map<String, dynamic>.from(result));
    }
  }

  static Future<TaskItemBean> addTask(TaskItemBean taskBean) async {
    var map = taskBean.toJson();
    Map result = await _platform.invokeMethod('addTask', map);
    if (result != null) {
      return TaskItemBean.fromJson(Map<String, dynamic>.from(result));
    }

    return null;
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
    if (result is List) {
      return result.map((f) => f = TaskItemBean.fromJson(Map<String, dynamic>.from(f))).toList();
    }

    return null;
  }
}
