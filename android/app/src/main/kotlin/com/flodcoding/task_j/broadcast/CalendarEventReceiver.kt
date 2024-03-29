package com.flodcoding.task_j.broadcast

import android.app.KeyguardManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.PowerManager
import android.util.Log
import android.widget.Toast
import com.flodcoding.task_j.data.database.TaskModel
import com.flodcoding.task_j.service.GestureAccessibility
import com.flodcoding.task_j.utils.AppUtil
import com.flodcoding.task_j.utils.CalendarUtil
import com.flodcoding.task_j.utils.DeviceUtil
import kotlinx.coroutines.*


/**
 * SimpleDes:
 * Creator: Flood
 * Date: 2019-08-22
 * UseDes:
 *
 */
class CalendarEventReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {

        context ?: return
        intent ?: return


        //TODO 不可执行耗时操作，是否需要开启Service
        val startTime = intent.data?.lastPathSegment?.toLongOrNull() ?: return

        Log.d("start_time", "BroadcastReceiver:$startTime")

        val eventIds = CalendarUtil.queryEventIdByTime(context, startTime.toString())
        if (eventIds.isEmpty()) return


        //TODO 判断当前是否是熄屏状态，然后唤醒亮屏再执行解锁手势
        if (!DeviceUtil.isDeviceSecure(context)) {
            //没有密码的
            DeviceUtil.tryWakeUpAndUnlock(context)
        } else {
            //有密码

            //唤醒屏幕
            val wakeLock = DeviceUtil.newWakeLock(context)
            //acquire 的timeout作用是如果不手动release 则以超时时间release
            //亮屏30s
            wakeLock.acquire(30000)


            // wakeLock.release()
        }

        val km = context.getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager
        val pm = context.getSystemService(Context.POWER_SERVICE) as PowerManager

        //熄屏
        if (!pm.isInteractive) {
            @Suppress("DEPRECATION")
            val wakeLock = pm.newWakeLock(PowerManager.SCREEN_BRIGHT_WAKE_LOCK or
                    PowerManager.ACQUIRE_CAUSES_WAKEUP, "CalendarEventReceiver:WakeLock")

            //acquire 的timeout作用是如果不手动release 则以超时时间release
            //唤醒亮屏30s
            wakeLock.acquire(30000)

            //有滑动锁
            if (km.isKeyguardLocked) {
                km.newKeyguardLock("CalendarEventReceiver:KeyguardLock").disableKeyguard()
            }



        }


        runBlocking {
            val task = TaskModel.queryByEventId(eventIds[0])
            if (task != null) {
                context.startActivity(AppUtil.getLaunchAppIntent(task.appInfo.launchPackage, task.appInfo.launchName))

                if (task.gesture != null) {
                    val gestures = task.gesture?.buildGestureBundle()?.gestureInfoList!!
                    GestureAccessibility.startGestures(context, ArrayList(gestures))
                }


            }


        }



        GlobalScope.launch {
            withContext(Dispatchers.Main) {
                Toast.makeText(context.applicationContext, "我活了", Toast.LENGTH_SHORT).show()
            }
        }


    }

}