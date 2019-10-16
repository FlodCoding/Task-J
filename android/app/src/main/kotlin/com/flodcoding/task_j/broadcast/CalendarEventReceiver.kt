package com.flodcoding.task_j.broadcast

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import android.widget.Toast
import com.flodcoding.task_j.data.database.TaskModel
import com.flodcoding.task_j.utils.CalendarUtil
import com.flodcoding.task_j.utils.AppUtil
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

        runBlocking {
            val task = TaskModel.queryByEventId(eventIds[0])
            if (task != null) {
                context.startActivity(AppUtil.getLaunchAppIntent(task.appInfo.launchPackage, task.appInfo.launchName))
            }



        }



        GlobalScope.launch {
            withContext(Dispatchers.Main) {
                Toast.makeText(context.applicationContext, "我活了", Toast.LENGTH_SHORT).show()
            }
        }


    }


    /* private fun queryEventId(context: Context, alertTime: String){
         val selection = CalendarContract.CalendarAlerts.ALARM_TIME + "=?"

         //通过提醒的时间查询到相应的EventId
         val cursor = context.contentResolver.query(CalendarContract.CalendarAlerts.CONTENT_URI_BY_INSTANCE, arrayOf(CalendarContract.CalendarAlerts.EVENT_ID), selection, arrayOf(alertTime), null)
         cursor ?: return

         while (cursor.moveToNext()) {

         }
     }*/
}