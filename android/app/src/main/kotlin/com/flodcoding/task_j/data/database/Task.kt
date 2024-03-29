@file:Suppress("ArrayInDataClass")

package com.flodcoding.task_j.data.database

import androidx.room.*
import com.flodcoding.task_j.data.GestureBundle
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import java.io.Serializable


/**
 * SimpleDes:
 * Creator: Flood
 * Date: 2019-08-08
 * UseDes:
 */
@Entity
@TypeConverters(Converter::class)
data class Task(
        @PrimaryKey(autoGenerate = true)
        var id: Long = 0,
        var enable: Boolean,
        @Embedded
        var appInfo: AppInfo,
        @Embedded
        var time: Time,
        @Embedded
        var gesture: Gesture?) {


    fun toMap(): Map<String, Any?> {
        return mapOf(
                "id" to id,
                "enable" to enable,
                "appInfo" to appInfo.toMap(),
                "time" to time.toMap(),
                "gesture" to gesture?.toMap()

        )
    }


    fun getIdMap(): Map<String, Any> {
        return mapOf(
                "id" to id,
                "eventId" to time.eventId
        )
    }
}

@Entity
data class AppInfo(var appName: String,
                   var appIconBytes: ByteArray,
                   var launchName: String,
                   var launchPackage: String) {
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
        var eventId: Long,
        var repeat: Boolean,
        var repeatInWeek: List<Boolean>,
        var dateTime: Long) {
    fun toMap(): Map<String, Any> {
        return mapOf(
                "eventId" to eventId,
                "repeat" to repeat,
                "repeatInWeek" to repeatInWeek,
                "dateTime" to dateTime
        )
    }
}

@Entity
data class Gesture(var gestureBundleBytes: ByteArray) : Serializable {
    fun toMap(): Map<String, Any> {
        return mapOf(
                "gestureBundleBytes" to gestureBundleBytes
        )
    }

    fun buildGestureBundle(): GestureBundle {
        return GestureBundle.fromBytes(gestureBundleBytes)
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
