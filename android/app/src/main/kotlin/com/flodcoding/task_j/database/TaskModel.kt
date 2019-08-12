package com.flodcoding.task_j.database

/**
 * SimpleDes:
 * Creator: Flood
 * Date: 2019-08-12
 * UseDes:
 *
 */
object TaskModel {
    suspend fun getTaskList(): List<Task> {
        return AppDatabase.getInstance().taskDao().getAll()
    }

    suspend fun update(task: Task){
        AppDatabase.getInstance().taskDao().insert(task)
    }

    suspend fun delete(id: Long) {
        AppDatabase.getInstance().taskDao().deleteById(id.toLong())
    }
}