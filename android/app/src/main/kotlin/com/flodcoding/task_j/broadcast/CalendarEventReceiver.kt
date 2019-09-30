package com.flodcoding.task_j.broadcast

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import android.widget.Toast
import com.flodcoding.task_j.data.database.TaskModel
import com.flodcoding.task_j.utils.TaskUtil
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

        val startTime = intent.data?.lastPathSegment?.toLong() ?: return
        Log.d("start_time", "BroadcastReceiver:$startTime")

        runBlocking {
            val task = TaskModel.queryByTime(startTime)
            if (task != null) {
                context.startActivity(TaskUtil.launchAppIntent(task.appInfo.launchPackage, task.appInfo.launchName))
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