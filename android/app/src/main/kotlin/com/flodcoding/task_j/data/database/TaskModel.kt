package com.flodcoding.task_j.data.database

/**
 * SimpleDes:
 * Creator: Flood
 * Date: 2019-08-12
 * UseDes:
 *
 */
object TaskModel {
    suspend fun getTaskList(): List<Map<String, Any>> {
        return AppDatabase.getInstance().taskDao().getAll().map { it.toMap() }.toList()
    }

    suspend fun update(task: Task) {
        AppDatabase.getInstance().taskDao().update(task)
    }

    suspend fun insert(task: Task): Long {
        return AppDatabase.getInstance().taskDao().insert(task)[0]
    }

    suspend fun query(id: Long): Task? {
        return AppDatabase.getInstance().taskDao().getTasById(id)
    }

    suspend fun delete(id: Long) {
        AppDatabase.getInstance().taskDao().deleteById(id)
    }

    suspend fun delete(task: Task) {
        AppDatabase.getInstance().taskDao().delete(task)
    }
}