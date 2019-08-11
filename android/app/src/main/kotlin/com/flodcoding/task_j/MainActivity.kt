package com.flodcoding.task_j

import android.os.Bundle
import android.util.Log
import com.flodcoding.task_j.applist.AppInfoTempBean
import com.flodcoding.task_j.channel.FlutterMethodChannel
import com.flodcoding.task_j.database.AppInfoBean
import com.flodcoding.task_j.database.TaskBean
import com.flodcoding.task_j.database.TimeBean
import com.google.gson.Gson
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.*


class MainActivity : FlutterFragmentActivity() {

    private lateinit var mCurSelectAppTemp: AppInfoTempBean


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        FlutterMethodChannel.registerMethodCallBack(this)
        testBeanToJson()
    }



    fun testBeanToJson(){
        val taskBean = TaskBean(id = 1,isStart = true)
        taskBean.time = TimeBean(repeat = true, repeatInWeek = arrayListOf(true),dateTime = Date())
        taskBean.appInfo = AppInfoBean(appName = "APP",appIconBytes = ByteArray(0))

        Log.wtf("MainActivity",Gson().toJson(taskBean))

    }
}


