package com.flodcoding.task_j

import android.os.Bundle
import com.flodcoding.task_j.applist.AppInfoBean
import com.flodcoding.task_j.applist.AppListDialog
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity : FlutterFragmentActivity() {
    private val CHANNEL = "com.flod.task_j.android/applist"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "showInstallAppList") {
                AppListDialog(object : AppListDialog.OnAppSelectedListener {
                    override fun onSelected(appInfoBean: AppInfoBean?) {
                        if (appInfoBean != null) {

                            result.success(mapOf(
                                    "appName" to appInfoBean.appName,
                                    "appIconBytes" to appInfoBean.appIconBase64Str

                            ))
                        } else {

                        }
                    }

                }).show(supportFragmentManager);
            } else {
                result.notImplemented()
            }
        }
    }
    /* private fun getBatteryLevel(): Int {
         val batteryLevel: Int
         if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
             val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
             batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
         } else {
             val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
             batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
         }

         return batteryLevel
     }*/


}


