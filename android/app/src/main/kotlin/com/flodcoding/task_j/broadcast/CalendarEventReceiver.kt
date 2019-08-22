package com.flodcoding.task_j.broadcast

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.provider.CalendarContract
import android.widget.Toast
import com.flodcoding.task_j.data.database.Task
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext


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

        val alertTime = intent.data?.lastPathSegment ?: return

        queryTask(context, alertTime)


        GlobalScope.launch {
            withContext(Dispatchers.Main) {
                Toast.makeText(context!!.applicationContext, "我活了", Toast.LENGTH_SHORT).show()
            }
        }


    }


    private fun queryTask(context: Context, alertTime: String): Task? {
        val selection = CalendarContract.CalendarAlerts.ALARM_TIME + "=?"

        //通过提醒的时间查询到相应的EventId
        val cursor = context.contentResolver.query(CalendarContract.CalendarAlerts.CONTENT_URI_BY_INSTANCE, arrayOf(CalendarContract.CalendarAlerts.EVENT_ID), selection, arrayOf(alertTime), null)
        cursor ?: return null

        while (cursor.moveToNext()){

        }


        cursor.close()

        return null

    }
}