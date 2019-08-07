package com.flodcoding.task_j

import android.os.Bundle
import com.flodcoding.task_j.applist.AppInfoBean
import com.flodcoding.task_j.applist.AppListDialog
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "com.flod.task_j.android"



    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "showInstallAppList") {
                AppListDialog(object : AppListDialog.OnAppSelectedListener {
                    override fun onSelected(appInfoBean: AppInfoBean?) {
                        if (appInfoBean != null) {

                            result.success(mapOf(
                                    "appName" to appInfoBean.appName,
                                    "appIconBytes" to appInfoBean.appIconBase64Str

                            ))
                        } else {

                        }
                    }

                }).show(supportFragmentManager);
            } else {
                result.notImplemented()
            }
        }
    }


}


