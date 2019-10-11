package com.flodcoding.task_j.utils

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.Drawable
import com.flodcoding.task_j.data.AppInfoTempBean




/**
 * SimpleDes:
 * Creator: Flood
 * Date: 2019-08-06
 * UseDes:
 */
object TaskUtil {

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


                val appInfoBean = AppInfoTempBean(iconDraw, title, info, getBitmapFromDrawable(iconDraw)!!)
                appInfoBeans.add(appInfoBean)
            }

        }

        return appInfoBeans
    }


   /* private fun getBitmapFromDrawable(drawable: Drawable): Bitmap? {
        if (drawable is BitmapDrawable) {
            return drawable.bitmap
        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O
                && (drawable is AdaptiveIconDrawable)) {
            val backgroundDr = drawable.background
            val foregroundDr = drawable.foreground
            val layerDrawable = LayerDrawable(arrayOf(backgroundDr, foregroundDr))

            val bitmap = Bitmap.createBitmap(layerDrawable.intrinsicWidth, layerDrawable.intrinsicHeight, Bitmap.Config.ARGB_8888)
            val canvas = Canvas(bitmap)
            layerDrawable.setBounds(0, 0, canvas.width, canvas.height)
            layerDrawable.draw(canvas)

            return bitmap
        }

        return null
    }*/

    private fun getBitmapFromDrawable(drawable: Drawable): Bitmap {
        val bmp = Bitmap.createBitmap(drawable.intrinsicWidth, drawable.intrinsicHeight, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bmp)
        drawable.setBounds(0, 0, canvas.width, canvas.height)
        drawable.draw(canvas)
        return bmp
    }

    fun launchAppIntent(launchPackage: String, launchName: String): Intent {
        val intent = Intent(Intent.ACTION_MAIN)
        intent.addCategory(Intent.CATEGORY_LAUNCHER)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        val cn = ComponentName(launchPackage, launchName)
        intent.component = cn
        return intent
    }

}
