package com.flodcoding.task_j.channel

import com.flodcoding.task_j.FlutterFragmentActivity
import com.flodcoding.task_j.applist.AppInfoTempBean
import com.flodcoding.task_j.applist.AppListDialog
import com.flodcoding.task_j.utils.AppInstalledUtil
import io.flutter.plugin.common.MethodChannel

/**
 * SimpleDes:
 * Creator: Flood
 * Date: 2019-08-08
 * UseDes:
 *
 */
object FlutterMethodChannel {
    private const val CHANNEL = "com.flod.task_j.android"
    private lateinit var mCurSelectAppTemp: AppInfoTempBean

    fun registerMethodCallBack(fragmentActivity: FlutterFragmentActivity) {

        MethodChannel(fragmentActivity.flutterView, CHANNEL).setMethodCallHandler { call, result ->
            when {
                call.method == "getSavedAppInfoList" -> {
                    val savedList = AppInstalledUtil.getSaveListToFlutter()
                    result.success(savedList)
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

                    }).show(fragmentActivity.supportFragmentManager)
                call.method == "saveTask" || call.method == "addTask" -> {
                    //AppInstalledUtil.put(AppInstalledUtil.argToTaskBean(call.arguments))



                }
                call.method == "deleteTask" -> {
                    val id = (call.arguments as Map<*, *>)["id"] as Int
                    AppInstalledUtil.delete(id)
                }

                else -> result.notImplemented()
            }
        }
    }
}