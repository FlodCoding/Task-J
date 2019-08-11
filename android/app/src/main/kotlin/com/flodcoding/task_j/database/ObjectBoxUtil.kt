package com.flodcoding.task_j.database

import android.content.Context
import com.flodcoding.task_j.utils.PrefsUtil
import io.objectbox.BoxStore

/**
 * SimpleDes:
 * Creator: Flood
 * Date: 2019-08-08
 * UseDes:
 *
 */
object ObjectBoxUtil {
    private lateinit var boxStore: BoxStore

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


    private fun buildObjectBox(context: Context, version: Int): BoxStore {
        return MyObjectBox.builder()
                .name("ObjectBox_" + version)
                .androidContext(context.getApplicationContext())
                .build()
    }


    fun get(): BoxStore {
        return boxStore
    }

}