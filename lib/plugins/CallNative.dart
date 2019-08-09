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

  static saveTask() async {
    _platform.invokeMethod('saveTask');
  }

  static Future<List<AppInfoBean>> getSavedList() async {
    dynamic result = await _platform.invokeMethod('getSavedAppInfoList');

    if (result is List) {
      return result.map((f) => AppInfoBean(f["appName"], f["appIconBytes"])).toList();
    }

    return null;
  }
}
