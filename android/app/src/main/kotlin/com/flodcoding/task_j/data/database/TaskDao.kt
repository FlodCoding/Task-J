package com.flodcoding.task_j.data.database

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
    @Query("SELECT * FROM task where id = :id LIMIT 1")
    suspend fun getTaskById(id: Long): Task?

    @Query("SELECT * FROM task where eventId = :eventId LIMIT 1")
    suspend fun getTaskByEventId(eventId: Long): Task?


    @Query("SELECT * FROM task")
    suspend fun getAll(): List<Task>

    @Query("SELECT * FROM task where dateTime = :time")
    suspend fun getTaskByTime(time: Long): List<Task>

    @Delete
    suspend fun delete(vararg task: Task)

    @Query("DELETE FROM task where id = :id ")
    suspend fun deleteById(vararg id: Long)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(vararg task: Task): Array<Long>

    @Update
    suspend fun update(vararg task: Task)

}