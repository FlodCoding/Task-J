package com.flodcoding.task_j.data.channel

import com.flod.view.GestureInfo
import com.flodcoding.task_j.FlutterFragmentActivity
import com.flodcoding.task_j.data.AppInfoTempBean
import com.flodcoding.task_j.data.GestureBundle
import com.flodcoding.task_j.data.database.AppInfo
import com.flodcoding.task_j.data.database.Gesture
import com.flodcoding.task_j.data.database.Task
import com.flodcoding.task_j.data.database.TaskModel
import com.flodcoding.task_j.service.GestureAccessibility
import com.flodcoding.task_j.service.GestureRecorderWatcher
import com.flodcoding.task_j.utils.CalendarUtil
import com.flodcoding.task_j.utils.JsonUtil
import com.flodcoding.task_j.view.AppListDialog
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
                            override fun onCancel() {
                                result.success(null)
                            }

                            override fun onSelected(appInfoTempBean: AppInfoTempBean?) {
                                if (appInfoTempBean != null) {
                                    result.success(AppInfo(appInfoTempBean.appName, appInfoTempBean.iconBytes
                                            ?: ByteArray(0), appInfoTempBean.info.name, appInfoTempBean.info.packageName).toMap())
                                }
                            }
                        }).show(fragmentActivity.supportFragmentManager)

                    call.method == "getTaskList" -> {
                        val tasks = TaskModel.getTaskList()
                        result.success(tasks)
                    }

                    call.method == "addGesture" -> {
                        GestureAccessibility.startServiceWithRecord(fragmentActivity)
                        GestureAccessibility.INSTANCE?.setGestureRecorderWatcher(
                                object : GestureRecorderWatcher.SimpleListener() {
                                    override fun onStopRecord(gestureInfoList: ArrayList<GestureInfo>) {
                                        if (gestureInfoList.isNotEmpty()) {
                                            result.success(Gesture(GestureBundle(gestureInfoList).toBytes()).toMap())
                                        } else {
                                            result.success(null)
                                        }

                                        GestureAccessibility.INSTANCE?.setGestureRecorderWatcher(null)
                                    }

                                    override fun onCancelRecord() {
                                        result.success(null)
                                        GestureAccessibility.INSTANCE?.setGestureRecorderWatcher(null)
                                    }


                                })
                    }

                    call.method == "addTask" -> {
                        val task = JsonUtil.mapToObj(call.arguments as Map<*, *>, Task::class.java)
                                ?: return@runBlocking

                        //添加到日历中
                        val eventId = CalendarUtil.insertTask(fragmentActivity, task)
                                ?: return@runBlocking
                        task.time.calendarId = eventId.toLong()

                        //TODO 出错处理

                        //放到数据库中
                        val id = TaskModel.insert(task)
                        task.id = id

                        //TODO 出错处理
                        //返回给UI端
                        result.success(task.getIdMap())
                    }
                    call.method == "updateTask" -> {
                        val task = JsonUtil.mapToObj(call.arguments as Map<*, *>, Task::class.java)
                                ?: return@runBlocking

                        CalendarUtil.updateTask(fragmentActivity, task)
                        TaskModel.update(task)
                    }
                    call.method == "deleteTask" -> {
                        val id = (call.arguments as Map<*, *>)["id"] as Number
                        val task = TaskModel.queryById(id.toLong())

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


    fun EventChannelCall() {

        //EventChannel()

    }
}