package com.flodcoding.task_j.database

import androidx.room.*

/**
 * SimpleDes:
 * Creator: Flood
 * Date: 2019-08-12
 * UseDes:
 *
 */
@Dao
interface TaskDao {
    @Query("SELECT * from task where id = :id LIMIT 1")
    suspend fun getTasById(id: Long): Task

    @Query("SELECT * FROM task")
    suspend fun getAll(): List<Task>

    @Delete
    suspend fun delete(vararg task: Task)

    @Query("DELETE FROM task where id = :id ")
    suspend fun deleteById(vararg id: Long)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(vararg task: Task)


}