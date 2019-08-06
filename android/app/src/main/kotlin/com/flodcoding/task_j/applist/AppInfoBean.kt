package com.flodcoding.task_j.applist

import android.content.ComponentName
import android.content.Intent
import android.content.pm.ActivityInfo
import android.graphics.drawable.Drawable

/**
 * SimpleDes:
 * Creator: Flood
 * Date: 2019-08-06
 * UseDes:
 */
class AppInfoBean(val icon: Drawable?, val appName: CharSequence, val info: ActivityInfo) {

    internal val startIntent: Intent
        get() {
            val intent = Intent(Intent.ACTION_MAIN)
            intent.addCategory(Intent.CATEGORY_LAUNCHER)
            val cn = ComponentName(info.packageName, info.name)
            intent.component = cn
            return intent
        }
}
