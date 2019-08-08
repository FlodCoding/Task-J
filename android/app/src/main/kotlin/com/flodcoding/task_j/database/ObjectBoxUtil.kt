package com.flodcoding.task_j.database

import android.content.Context
import com.flodcoding.task_j.utils.PrefsUtil
import io.objectbox.Box
import io.objectbox.BoxStore
import java.util.*

/**
 * SimpleDes:
 * Creator: Flood
 * Date: 2019-08-08
 * UseDes:
 *
 */
object ObjectBoxUtil {
    private var boxStore: BoxStore? = null

    fun init(context: Context) {
        val version = PrefsUtil.getInt("ObjectBoxVersion", 0)
        try {
            boxStore = buildObjectBox(context, version)
        } catch (e: Exception) {
            e.printStackTrace()
            //初始化失败 重新创建一个

            //出现和旧entity冲突的问题，删除所有数据库,但是会出现TimeoutException，https://github.com/objectbox/objectbox-java/issues/617
            //BoxStore.deleteAllFiles()

            //目前方案：重新创建一个数据库//
            boxStore = buildObjectBox(context, version + 1)
            PrefsUtil.putInt("ObjectBoxVersion", version + 1)

        }
    }


    private fun buildObjectBox(context: Context, version: Int): BoxStore? {
        return MyObjectBox.builder()
                .name("ObjectBox_" + version)
                .androidContext(context.getApplicationContext())
                .build()
    }


    fun get(): BoxStore? {
        return boxStore
    }

    fun <T> boxFor(entityClass: Class<T>): Box<T>? {
        return if (boxStore == null) null else boxStore!!.boxFor(entityClass)
    }


    fun <T> getAll(entityClass: Class<T>): List<T> {
        return if (boxStore == null) ArrayList() else boxStore!!.boxFor(entityClass).all
    }

    fun <T> removeAll(entityClass: Class<T>) {
        if (boxStore == null)
            return
        boxStore!!.boxFor(entityClass).removeAll()
    }

    fun <T> put(entityClass: Class<T>, entities: Collection<T>?) {
        if (boxStore == null)
            return
        boxStore!!.boxFor(entityClass).put(entities)
    }
}