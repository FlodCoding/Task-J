package com.flodcoding.task_j.utils

import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import com.flodcoding.task_j.data.AppInfoTempBean

/**
 * SimpleDes:
 * Creator: Flood
 * Date: 2019-08-06
 * UseDes:
 */
object TaskUtil {

    private val Rule_ByDay = arrayOf("MO", "TU", "WE", "TH", "FR", "SA", "SU")

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



}
