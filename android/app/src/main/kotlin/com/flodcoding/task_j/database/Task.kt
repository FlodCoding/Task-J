package com.flodcoding.task_j.database

import androidx.room.*
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken


/**
 * SimpleDes:
 * Creator: Flood
 * Date: 2019-08-08
 * UseDes:
 */
@Entity
data class Task(@PrimaryKey(autoGenerate = true) var id: Long = 0, var isStart: Boolean, @Embedded var appInfo: AppInfo, @Embedded var time: Time) {


    fun toMap(): Map<String, Any> {
        return mapOf(
                "id" to id,
                "isStart" to isStart,
                "appInfo" to appInfo.toMap(),
                "time" to time.toMap()
        )
    }
}

@Suppress("ArrayInDataClass")
@Entity
data class AppInfo(var appName: String, var appIconBytes: ByteArray) {
    fun toMap(): Map<String, Any> {
        return mapOf(
                "appName" to appName,
                "appIconBytes" to appIconBytes
        )
    }
}

@Entity
@TypeConverters(Converter::class)
data class Time(
        var repeat: Boolean,
        var repeatInWeek: List<Boolean>,
        val dateTime: Long
) {
    fun toMap(): Map<String, Any> {
        return mapOf(
                "repeat" to repeat,
                "repeatInWeek" to repeatInWeek,
                "dateTime" to dateTime
        )
    }
}

class Converter {

    @TypeConverter
    fun listBooleanToString(obj: List<Boolean>): String {
        return Gson().toJson(obj)
    }

    @TypeConverter
    fun jsonToListBoolean(json: String): List<Boolean> {
        val type = object : TypeToken<List<Boolean>>() {}.type
        return Gson().fromJson(json, type)
    }
}