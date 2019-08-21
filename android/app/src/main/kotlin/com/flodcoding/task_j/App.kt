package com.flodcoding.task_j

import com.flodcoding.task_j.data.database.AppDatabase
import com.flodcoding.task_j.utils.PrefsUtil
import io.flutter.app.FlutterApplication

/**
 * SimpleDes:
 * Creator: Flood
 * Date: 2019-08-08
 * UseDes:
 *
 */
class App : FlutterApplication() {

    override fun onCreate() {
        super.onCreate()
        PrefsUtil.init(this)
        AppDatabase.init(this)
    }
}