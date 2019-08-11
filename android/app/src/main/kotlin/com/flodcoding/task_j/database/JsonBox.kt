package com.flodcoding.task_j.database

import com.google.gson.JsonDeserializationContext
import com.google.gson.JsonElement
import com.google.gson.JsonObject
import io.objectbox.relation.ToOne
import java.lang.reflect.Type

/**
 * SimpleDes:
 * Creator: Flood
 * Date: 2019-08-11
 * UseDes:
 */
abstract class JsonBox {
    internal abstract fun fromJson(jo: JsonObject, context: JsonDeserializationContext)
    protected fun <T> filling(toMany: MutableList<T>?, type: Class<T>, jsonElement: JsonElement, context: JsonDeserializationContext) {
        if (toMany == null)
            return
        toMany.clear()
        if (jsonElement.isJsonArray) {
            val array = jsonElement.asJsonArray
            for (i in 0 until array.size()) {
                val element = array.get(i)
                val item = context.deserialize<T>(element, type)
                toMany.add(item)
            }
        }
    }

    protected fun <T : JsonBox> filling(toOne: ToOne<T>, typeOfT: Type, jsonElement: JsonElement, context: JsonDeserializationContext) {
        if (toOne == null)
            return
        try {
            val one = (typeOfT as Class<T>).newInstance()
            one.fromJson(jsonElement.asJsonObject, context)
            toOne.setTarget(one)
        } catch (e: InstantiationException) {
            e.printStackTrace()
        } catch (e: IllegalAccessException) {
            e.printStackTrace()
        }

    }
}