package com.flodcoding.task_j

import android.os.Bundle
import com.flodcoding.task_j.applist.AppInfoTempBean
import com.flodcoding.task_j.channel.FlutterMethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity : FlutterFragmentActivity() {

    private lateinit var mCurSelectAppTemp: AppInfoTempBean


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        FlutterMethodChannel.registerMethodCallBack(this)

    }

}


