package com.flodcoding.task_j

import android.os.Bundle
import com.flodcoding.task_j.data.channel.FlutterMethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity : FlutterFragmentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        FlutterMethodChannel.registerMethodCallBack(this)

    }

}


