package com.flodcoding.task_j.channel

import com.flodcoding.task_j.FlutterFragmentActivity
import com.flodcoding.task_j.data.AppInfoTempBean
import com.flodcoding.task_j.data.database.AppInfo
import com.flodcoding.task_j.data.database.Task
import com.flodcoding.task_j.data.database.TaskModel
import com.flodcoding.task_j.utils.AppListDialog
import com.flodcoding.task_j.utils.CalendarUtil
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
                            override fun onSelected(infoTemp: AppInfoTempBean?) {
                                if (infoTemp != null) {
                                    result.success(AppInfo(infoTemp.appName, infoTemp.iconBytes
                                            ?: ByteArray(0), infoTemp.info.name, infoTemp.info.packageName).toMap())
                                }
                            }
                        }).show(fragmentActivity.supportFragmentManager)

                    call.method == "getTaskList" -> {
                        val tasks = TaskModel.getTaskList()
                        result.success(tasks)
                    }
                    call.method == "addTask" -> {
                        val task = JsonUtil.mapToObj(call.arguments as Map<*, *>, Task::class.java)
                                ?: return@runBlocking

                        //添加到日历中
                        val eventId = CalendarUtil.insertTask(fragmentActivity, task)
                                ?: return@runBlocking
                        task.time.calendarId = eventId.toLong()

                        //放到数据库中
                        val id = TaskModel.insert(task)
                        task.id = id

                        //返回给UI端

                        result.success(task.toMap())
                    }
                    call.method == "updateTask" -> {
                        val task = JsonUtil.mapToObj(call.arguments as Map<*, *>, Task::class.java)
                                ?: return@runBlocking

                        CalendarUtil.updateTask(fragmentActivity, task)
                        TaskModel.update(task)
                    }
                    call.method == "deleteTask" -> {
                        val id = (call.arguments as Map<*, *>)["id"] as Number
                        val task = TaskModel.query(id.toLong())

                        if (task != null) {
                            CalendarUtil.deleteTask(fragmentActivity, task.time.calendarId)
                            TaskModel.delete(task)
                        }
                    }

                    else -> result.notImplemented()
                }
            }


        }
    }
}