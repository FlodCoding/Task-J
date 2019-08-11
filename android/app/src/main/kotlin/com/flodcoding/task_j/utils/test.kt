package com.flodcoding.task_j.utils

import com.flodcoding.task_j.database.ObjectBoxUtil
import com.flodcoding.task_j.database.TaskBean

/**
 * SimpleDes:
 * Creator: Flood
 * Date: 2019-08-11
 * UseDes:
 */
class test {

    internal fun text(vararg a: Long) {
        ObjectBoxUtil.get().boxFor(TaskBean::class.java).remove(*a)
    }
}
