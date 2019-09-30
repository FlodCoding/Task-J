package com.flodcoding.task_j.data

import android.content.pm.ActivityInfo
import android.graphics.Bitmap
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import java.io.ByteArrayOutputStream

/**
 * SimpleDes:
 * Creator: Flood
 * Date: 2019-08-06
 * UseDes:
 */
class AppInfoTempBean(val appIcon: Drawable?, val appName: String, val info: ActivityInfo) {



    internal val iconBytes: ByteArray?
        get() {
            if (appIcon is BitmapDrawable) {
                val baos = ByteArrayOutputStream()
                val bitmap = appIcon.bitmap
                bitmap.compress(Bitmap.CompressFormat.PNG, 100, baos)
                return baos.toByteArray()
            }
            return null
        }


}