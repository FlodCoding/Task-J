package com.flodcoding.task_j.utils

import android.app.Activity
import android.app.ActivityManager
import android.content.ComponentName
import android.content.Context
import android.content.Context.ACTIVITY_SERVICE
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
object AppUtil {

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
                //info.iconResource
                val iconDraw = info.applicationInfo.loadIcon(packageManager)
                val title = info.applicationInfo.loadLabel(packageManager).toString()

                val appInfoBean = AppInfoTempBean(iconDraw, title, info)
                appInfoBeans.add(appInfoBean)
            }
        }

        return appInfoBeans
    }


    /*private fun getBitmapFromDrawable(drawable: Drawable): Bitmap {
        val bmp = Bitmap.createBitmap(drawable.intrinsicWidth, drawable.intrinsicHeight, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bmp)
        drawable.setBounds(0, 0, canvas.width, canvas.height)
        drawable.draw(canvas)
        return bmp
    }*/

    fun getLaunchAppIntent(launchPackage: String, launchName: String): Intent {
        val intent = Intent(Intent.ACTION_MAIN)
        intent.addCategory(Intent.CATEGORY_LAUNCHER)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        val cn = ComponentName(launchPackage, launchName)
        intent.component = cn
        return intent
    }


    fun moveActivtyToFront(context: Activity) {
        val activityManager = context.getSystemService(ACTIVITY_SERVICE) as ActivityManager
        activityManager.moveTaskToFront(context.taskId, 0)
    }


}
