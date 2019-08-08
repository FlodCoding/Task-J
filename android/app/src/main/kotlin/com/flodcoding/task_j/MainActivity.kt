package com.flodcoding.task_j

import android.os.Bundle
import android.widget.Toast
import com.flodcoding.task_j.applist.AppInfoTempBean
import com.flodcoding.task_j.applist.AppListDialog
import com.flodcoding.task_j.utils.AppInstalledUtil
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "com.flod.task_j.android"

    private lateinit var mCurSelectAppTemp: AppInfoTempBean


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
            when {
                call.method == "getSavedAppInfoList" -> {
                    val savedList = AppInstalledUtil.getSaveListToFlutter()
                    if (savedList.isNotEmpty()) {
                        result.success(savedList)
                    }

                }
                call.method == "showInstallAppList" ->
                    AppListDialog(object : AppListDialog.OnAppSelectedListener {
                        override fun onSelected(appInfoTempBean: AppInfoTempBean?) {
                            if (appInfoTempBean != null) {

                                mCurSelectAppTemp = appInfoTempBean
                                result.success(mapOf(
                                        "appName" to appInfoTempBean.appName,
                                        "appIconBytes" to appInfoTempBean.iconBytes

                                ))
                            } else {

                            }
                        }

                    }).show(supportFragmentManager)
                call.method == "saveAppInfo" -> {
                    AppInstalledUtil.save(mCurSelectAppTemp)
                    Toast.makeText(this, "保存成功", Toast.LENGTH_SHORT).show()

                }
                else -> result.notImplemented()
            }
        }

    }


}


