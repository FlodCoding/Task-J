package com.flodcoding.task_j.channel

import com.flodcoding.task_j.FlutterFragmentActivity
import com.flodcoding.task_j.applist.AppInfoTempBean
import com.flodcoding.task_j.applist.AppListDialog
import com.flodcoding.task_j.database.AppInfo
import com.flodcoding.task_j.database.Task
import com.flodcoding.task_j.database.TaskModel
import com.flodcoding.task_j.utils.JsonUtil
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.runBlocking

/**
 * SimpleDes:
 * Creator: Flood
 * Date: 2019-08-08
 * UseDes:
 *
 */
object FlutterMethodChannel {
    private const val CHANNEL = "com.flod.task_j.android"

    fun registerMethodCallBack(fragmentActivity: FlutterFragmentActivity) {

        MethodChannel(fragmentActivity.flutterView, CHANNEL).setMethodCallHandler { call, result ->

            runBlocking {
                when {
                    call.method == "showInstallAppList" ->
                        AppListDialog(object : AppListDialog.OnAppSelectedListener {
                            override fun onSelected(appInfoTempBean: AppInfoTempBean?) {
                                if (appInfoTempBean != null) {
                                    result.success(AppInfo(appInfoTempBean.appName, appInfoTempBean.iconBytes
                                            ?: ByteArray(0)).toMap())
                                }
                            }

                        }).show(fragmentActivity.supportFragmentManager)

                    call.method == "getTaskList" -> {
                        val tasks = TaskModel.getTaskList().map { it.toMap() }.toList()
                        result.success(tasks)
                    }


                    call.method == "updateTask" -> {
                        val task = JsonUtil.mapToObj(call.arguments as Map<*, *>, Task::class.java)
                        TaskModel.update(task!!)
                        print("saveSuccess")
                    }
                    call.method == "deleteTask" -> {
                        val id = (call.arguments as Map<*, *>)["id"] as Number
                        TaskModel.delete(id.toLong())
                    }

                    else -> result.notImplemented()
                }
            }


        }
    }
}