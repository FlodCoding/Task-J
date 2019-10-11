package com.flodcoding.task_j.data

import android.content.pm.ActivityInfo
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.Drawable
import java.io.ByteArrayOutputStream
import java.io.Serializable

/**
 * SimpleDes:
 * Creator: Flood
 * Date: 2019-08-06
 * UseDes:
 */
class AppInfoTempBean(val appIcon: Drawable?, val appName: String, val info: ActivityInfo,val bitmap: Bitmap) : Serializable {


    internal val iconBytes: ByteArray?
        get() {
            if (appIcon == null) return null
            return getBytes(appIcon)
        }


    fun getBytes(drawable: Drawable): ByteArray{
        val bitmap = Bitmap.createBitmap(drawable.intrinsicWidth, drawable.intrinsicHeight, Bitmap.Config.ARGB_8888)
        drawable.draw(Canvas(bitmap))
        val baos = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, baos)
        return baos.toByteArray()
    }
}