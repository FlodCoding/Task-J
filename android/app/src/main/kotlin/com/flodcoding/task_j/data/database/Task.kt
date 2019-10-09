package com.flodcoding.task_j.data.database

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
@Suppress("ArrayInDataClass")
@TypeConverters(Converter::class)
data class Task(
        @PrimaryKey(autoGenerate = true)
        var id: Long = 0, var enable: Boolean,
        @Embedded
        var appInfo: AppInfo,
        @Embedded
        var time: Time,
        var gestures: ByteArray?) {


    fun toMap(): Map<String, Any?> {
        return mapOf(
                "id" to id,
                "enable" to enable,
                "appInfo" to appInfo.toMap(),
                "time" to time.toMap(),
                "gestures" to gestures

        )
    }
}

@Suppress("ArrayInDataClass")
@Entity
data class AppInfo(var appName: String, var appIconBytes: ByteArray, var launchName: String, var launchPackage: String) {
    fun toMap(): Map<String, Any> {
        return mapOf(
                "appName" to appName,
                "appIconBytes" to appIconBytes,
                "launchName" to launchName,
                "launchPackage" to launchPackage
        )
    }
}


@Entity
data class Time(
        var calendarId: Long,
        var repeat: Boolean,
        var repeatInWeek: List<Boolean>,
        var dateTime: Long) {
    fun toMap(): Map<String, Any> {
        return mapOf(
                "calendarId" to calendarId,
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

    /*  @TypeConverter
      fun parcelToBytes(gestures: GestureInfoBundle): ByteArray {
          return ParcelableUtil.marshall(gestures)
      }
  
      @TypeConverter
      fun bytesToParcel(bytes: ByteArray): GestureInfoBundle {
          return ParcelableUtil.unmarshall(bytes, GestureInfoBundle.CREATOR)
      }*/
}
