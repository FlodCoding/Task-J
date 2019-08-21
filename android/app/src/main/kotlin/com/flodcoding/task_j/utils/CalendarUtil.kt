package com.flodcoding.task_j.utils

import android.content.ContentUris
import android.content.ContentValues
import android.content.Context
import android.provider.CalendarContract
import com.flodcoding.task_j.data.database.Task
import java.util.*


/**
 * SimpleDes:
 * Creator: Flood
 * Date: 2019-08-21
 * UseDes:
 */
object CalendarUtil {

    private val Rule_ByDay = arrayOf("MO", "TU", "WE", "TH", "FR", "SA", "SU")

    fun insertTask(context: Context, task: Task): String? {
        val contentValues = buildContentValues(task)
        //插入日历中
        val eventId = context.contentResolver.insert(CalendarContract.Events.CONTENT_URI, contentValues)?.lastPathSegment

        return eventId ?: return null
    }


    fun updateTask(context: Context, task: Task) {
        val contentValues = buildContentValues(task)

        context.contentResolver.update(ContentUris.withAppendedId(CalendarContract.Events.CONTENT_URI, task.time.calendarId),
                contentValues, null, null)


    }

    fun deleteTask(context: Context, eventId: Long) {
        context.contentResolver.delete(ContentUris.withAppendedId(CalendarContract.Events.CONTENT_URI, eventId), null, null)
    }


    private fun buildContentValues(task: Task): ContentValues {
        val contentValues = ContentValues()
        contentValues.put(CalendarContract.Events.CALENDAR_ID, 1)
        contentValues.put(CalendarContract.Events.EVENT_TIMEZONE, TimeZone.getDefault().id)

        contentValues.put(CalendarContract.Events.TITLE, "打开 " + task.appInfo.appName)
        contentValues.put(CalendarContract.Events.DESCRIPTION, "此事件用来触发打开软件，请勿删除")

        contentValues.put(CalendarContract.Events.DTSTART, task.time.dateTime)
        contentValues.put(CalendarContract.Events.DTEND, task.time.dateTime + 600000)
        if (task.time.repeat) {
            //重复规则
            contentValues.put(CalendarContract.Events.RRULE, getFreqRule(task.time.repeatInWeek))
        }

        return contentValues
    }


    private fun getFreqRule(repeatInWeek: List<Boolean>): String {
        val rule = StringBuilder("FREQ=WEEKLY;WKST=MO;BYDAY=")
        for ((index, repeat) in repeatInWeek.withIndex()) {
            if (repeat) {
                rule.append(Rule_ByDay[index])
                if (index != repeatInWeek.size - 1)
                    rule.append(",")
            }

        }
        return rule.toString()

    }


}
