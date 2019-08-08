package com.flodcoding.task_j.database

import io.objectbox.annotation.Entity
import io.objectbox.annotation.Id

/**
 * SimpleDes:
 * Creator: Flood
 * Date: 2019-08-08
 * UseDes:
 */
@Entity
data class AppInfoBean (
        @Id var id: Long = 0,
        var appName: String,
        var appIconBytes: ByteArray?



)
