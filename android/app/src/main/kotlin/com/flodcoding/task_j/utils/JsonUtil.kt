package com.flodcoding.task_j.utils

import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import java.lang.reflect.Type
import java.util.*

/**
 * SimpleDes:
 * Creator: Flood
 * Date: 2019-03-11
 * UseDes:
 */
object JsonUtil {


    fun <T> jsonStrToObj(jsonStr: String, type: Type): T? {
        return try {
            Gson().fromJson<T>(jsonStr, type)
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }

    }

    fun <T> jsonStrToObj(jsonStr: String, tClass: Class<T>): T? {
        return try {
            Gson().fromJson(jsonStr, tClass)
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }

    }

    fun <T> jsonStrToObjList(jsonStr: String, tClass: Class<T>): List<T>? {
        return try {
            Arrays.asList(Gson().fromJson<T>(jsonStr, TypeToken.getArray(tClass).type))
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }

    }

    fun <T> objToJsonStr(t: T): String? {
        return try {
            Gson().toJson(t)
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }

    }

    fun <T> mapToObj(map: Map<*, *>, tClass: Class<T>): T? {

        return jsonStrToObj(objToJsonStr(map) ?: return null, tClass)
    }

    fun <T> objectToMap(t: T): Map<*, *> {
        return Gson().fromJson(objToJsonStr(t), Map::class.java)
    }
}
