package com.flodcoding.task_j.utils

import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import com.flodcoding.task_j.applist.AppInfoTempBean
import com.flodcoding.task_j.database.ObjectBoxUtil
import com.flodcoding.task_j.database.TaskBean
import com.google.gson.Gson

/**
 * SimpleDes:
 * Creator: Flood
 * Date: 2019-08-06
 * UseDes:
 */
object AppInstalledUtil {

    //获取用户安装的APP
    fun getInstalledApplication(context: Context, needSysAPP: Boolean): List<ResolveInfo> {
        val packageManager = context.packageManager
        val intent = Intent(Intent.ACTION_MAIN)
        intent.addCategory(Intent.CATEGORY_LAUNCHER)
        val resolveInfos = packageManager.queryIntentActivities(intent, 0)

        //排除系统应用
        if (!needSysAPP) {
            for (i in resolveInfos.indices) {
                val resolveInfo = resolveInfos[i]
                try {
                    if (isSysApp(context, resolveInfo.activityInfo.packageName)) {
                        resolveInfos.remove(resolveInfo)
                    }
                } catch (e: PackageManager.NameNotFoundException) {
                    e.printStackTrace()
                    resolveInfos.remove(resolveInfo)
                }

            }
        }
        return resolveInfos
    }

    //判断是否系统应用
    @Throws(PackageManager.NameNotFoundException::class)
    fun isSysApp(context: Context, packageName: String): Boolean {
        val packageInfo = context.packageManager.getPackageInfo(packageName, 0)
        return packageInfo.applicationInfo.flags and ApplicationInfo.FLAG_SYSTEM != 0
    }


    fun getSimpleInstalledAppInfoList(context: Context): List<AppInfoTempBean> {
        val resolveInfos = getInstalledApplication(context, true)
        val packageManager = context.packageManager
        val appInfoBeans = ArrayList<AppInfoTempBean>()
        for (resolveInfo in resolveInfos) {
            val info = resolveInfo.activityInfo
            if (info != null) {
                val iconDraw = resolveInfo.activityInfo.applicationInfo.loadIcon(packageManager)
                val title = resolveInfo.activityInfo.applicationInfo.loadLabel(packageManager).toString()
                val appInfoBean = AppInfoTempBean(iconDraw, title, info)
                appInfoBeans.add(appInfoBean)
            }

        }

        return appInfoBeans
    }


    fun put(taskBean: TaskBean?): Boolean {
        if (taskBean == null)
            return false
        ObjectBoxUtil.get().boxFor(TaskBean::class.java).put(taskBean)
        return true
    }

    fun delete(id: Int){
        ObjectBoxUtil.get().boxFor(TaskBean::class.java).remove(id.toLong())
    }


    fun getSaveListToFlutter(): String {
        val appInfoList = ObjectBoxUtil.get().boxFor(TaskBean::class.java).all
        /*val list = ArrayList<Map<String, Any?>>()
        appInfoList?.forEach {
            list.add(taskBeanToArg(it))
        }*/
        return Gson().toJson(appInfoList)
    }


/*
    fun jsonToTaskBean(arg: String): TaskBean? {

        var taskBean = TaskBean(isStart = true,id = 0)
        taskBean.appInfo.target = AppInfoBean("s",)
        taskBean.time.target = TimeBean(false,)

        return

           *//* return TaskBean(id = (arg["id"] as Int).toLong(),
                    appName = arg["appName"] as String,
                    appIconBytes = arg["appIconBytes"] as ByteArray,
                    repeat = arg["repeat"] as Boolean,
                    repeatInWeek = arg["repeatInWeek"] as List<Boolean>,
                    dateTime = Date(arg["dateTime"] as Long),
                    isStart = arg["isStart"] as Boolean
            )*//*

    }

    fun taskBeanTojson(taskBean: TaskBean): Map<String, Any?> {
        return mapOf(
                "id" to taskBean.id,
                "appName" to taskBean.appName,
                "appIconBytes" to taskBean.appIconBytes,
                "repeat" to taskBean.repeat,
                "repeatInWeek" to taskBean.repeatInWeek,
                "dateTime" to taskBean.dateTime.time,
                "isStart" to taskBean.isStart
        )
    }*/

    fun beanToJson(taskBean: TaskBean):String{
       return Gson().toJson(taskBean)
    }

}
