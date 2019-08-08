import 'dart:convert';

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
//      var appIconBytes = Base64Decoder().convert(result["appIconBytes"]);
      var appIconBytes = result["appIconBytes"];
      return AppInfoBean(appName, appIconBytes);
    }
  }

  static saveImage() async {
    _platform.invokeMethod('saveAppInfo');
  }

  static Future<List> getSavedList() async {
    List path = await _platform.invokeMethod('getSavedAppInfoList');
    return path;
  }
}
