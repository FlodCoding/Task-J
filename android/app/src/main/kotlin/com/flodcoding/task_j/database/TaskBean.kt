package com.flodcoding.task_j.database

import com.google.gson.JsonDeserializationContext
import com.google.gson.JsonObject
import io.objectbox.annotation.Convert
import io.objectbox.annotation.Entity
import io.objectbox.annotation.Id
import io.objectbox.converter.PropertyConverter
import io.objectbox.relation.ToOne
import java.util.*


/**
 * SimpleDes:
 * Creator: Flood
 * Date: 2019-08-08
 * UseDes:
 */
@Entity
data class TaskBean(@Id var id: Long = 0, var isStart: Boolean): JsonBox() {


    lateinit var appInfo: ToOne<AppInfoBean>
    lateinit var time: ToOne<TimeBean>

    override fun fromJson(jo: JsonObject, context: JsonDeserializationContext) {
        //filling(appInfo,AppInfoBean::class.java,jo.get("time"),context)
    }
}

@Entity
data class AppInfoBean(
        @Id var id: Long = 0,
        var appName: String,
        var appIconBytes: ByteArray
)

@Entity
data class TimeBean(
        @Id var id: Long = 0,
        var repeat: Boolean,
        @Convert(converter = ListToString::class, dbType = String::class)
        var repeatInWeek: List<Boolean>,
        val dateTime: Date
)

class ListToString : PropertyConverter<List<Boolean>, String> {
    override fun convertToEntityProperty(databaseValue: String): List<Boolean> {
        return databaseValue.split(",").toList().map { it.toBoolean() }
    }

    override fun convertToDatabaseValue(entityProperty: List<Boolean>): String {
        val stringBuilder = StringBuilder()
        for (b in entityProperty) {
            stringBuilder.append(b).append(",")
        }

        return stringBuilder.toString()
    }

}

/*class TaskBeanDeserializer : JsonDeserializer<TaskBean> {
    override fun deserialize(json: JsonElement?, typeOfT: Type?, context: JsonDeserializationContext?): TaskBean {
        val taskJson = json?.asJsonObject
        val taskBean = TaskBean(id = taskJson?.get("id")!!.asLong, isStart = taskJson.get("isStart")!!.asBoolean)

        val appInfoBean = context?.deserialize<AppInfoBean>(taskJson.getAsJsonObject("appInfo"), AppInfoBean::class.java)
        val timeBean = context?.deserialize<TimeBean>(taskJson.getAsJsonObject("time"), TimeBean::class.java)
        taskBean.appInfo.target = appInfoBean
        taskBean.time.target = timeBean

        return taskBean
    }

}

class TaskBeanSerializer :JsonSerializer<TaskBean> {
    override fun serialize(src: TaskBean?, typeOfSrc: Type?, context: JsonSerializationContext?): JsonElement {
        val json = JsonPrimitive()
    }*/
}