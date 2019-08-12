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
data class Task(@PrimaryKey(autoGenerate = true) var id: Long = 0, var isStart: Boolean, @Embedded var appInfo: AppInfo, @Embedded var time: Time)

@Suppress("ArrayInDataClass")
@Entity
data class AppInfo(
        var appName: String,
        var appIconBytes: ByteArray
)

@Entity
@TypeConverters(Converter::class)
data class Time(
        var repeat: Boolean,
        var repeatInWeek: List<Boolean>,

        val dateTime: Long
)

class Converter{

        @TypeConverter
         fun listBooleanToString(obj:  List<Boolean>): String {
                return Gson().toJson(obj)
        }

        @TypeConverter
         fun  jsonToListBoolean(json:String):List<Boolean>{
                val type = object : TypeToken<List<Boolean>>(){}.type
                return Gson().fromJson(json,type)
        }
}