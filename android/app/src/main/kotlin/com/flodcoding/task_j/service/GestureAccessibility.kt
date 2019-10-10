package com.flodcoding.task_j.service

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.GestureDescription
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.os.IBinder
import android.util.Log
import android.view.accessibility.AccessibilityEvent
import com.flod.view.GestureInfo


/**
 * SimpleDes:
 * Creator: Flood
 * Date: 2019-08-26
 * UseDes:
 *
 */
class GestureAccessibility : AccessibilityService(), GestureRecorderWatcher.Listener {

    private var mGestureRecorderWatcher: GestureRecorderWatcher.Listener? = null
    fun setGestureRecorderWatcher(watcher: GestureRecorderWatcher.Listener?) {
        mGestureRecorderWatcher = watcher
    }

    companion object {
        private const val KEY_IS_RECORD = "KEY_IS_RECORD"

        //由于onBind 在AccessibilityService中被设置为final，无法使用bindService与外界通信
        //目前就先单例这个Service，通过接口将数据回调出去
        var INSTANCE: GestureAccessibility? = null

        fun startGestures(context: Context, gestures: ArrayList<GestureInfo>) {
            val intent = Intent(context, GestureAccessibility::class.java)
            intent.putParcelableArrayListExtra("gesture", gestures)
            context.startService(intent)
        }

        fun startServiceWithRecord(context: Context) {
            val intent = Intent(context, GestureAccessibility::class.java)
            intent.putExtra(KEY_IS_RECORD, true)
            context.startService(intent)
        }
    }

    override fun onServiceConnected() {
        super.onServiceConnected()
        INSTANCE = this
    }

    override fun onUnbind(intent: Intent?): Boolean {
        INSTANCE = null
        return super.onUnbind(intent)
    }


    override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {
        Log.d("GestureAccessibility", "onStartCommand")
        val isRecord = intent.getBooleanExtra(KEY_IS_RECORD, false)
        if (!isRecord) {
            val gestures = intent.getParcelableArrayListExtra<GestureInfo>("gesture")
            if (gestures != null) {
                dispatchGestures(gestures)
            }
        } else {
            //RecordGesture
            bindGestureRecordService()
        }

        return super.onStartCommand(intent, flags, startId)
    }


    private fun dispatchGestures(gestures: ArrayList<GestureInfo>) {

        var index = 0
        val callBack = object : GestureResultCallback() {
            override fun onCancelled(gestureDescription: GestureDescription?) {
                Log.d("GestureAccessibility", "onCancelled")
            }

            override fun onCompleted(gestureDescription: GestureDescription?) {
                Log.d("GestureAccessibility", "onCompleted")

                index++

                if (gestures.size > index) {
                    startGesture(gestures[index], this, false)
                } else {
                    index = 0
                }

            }
        }

        for (gesture in gestures) {
            startGesture(gesture, callBack, false)
        }
    }


    private fun startGesture(gestureInfo: GestureInfo, gestureResultCallback: GestureResultCallback, immediately: Boolean) {
        val builder = GestureDescription.Builder()
        val gesture = gestureInfo.gesture

        var duration = gestureInfo.duration
        if (duration > GestureDescription.getMaxGestureDuration()) {
            duration = GestureDescription.getMaxGestureDuration()
        }

        for (stroke in gesture.strokes.withIndex()) {
            if (stroke.index == GestureDescription.getMaxStrokeCount() - 1)
                break
            val description =
                    GestureDescription.StrokeDescription(
                            stroke.value.path,
                            if (immediately) 0 else gestureInfo.delayTime,
                            duration
                    )

            builder.addStroke(description)
        }

        dispatchGesture(builder.build(), gestureResultCallback, null)
    }


    //=============================== RecordService Part===========================================//
    private var mRecordServiceBinder: GestureRecorderService.IGestureRecordBinder? = null
    private val mServiceConnection = object : ServiceConnection {
        override fun onServiceDisconnected(name: ComponentName?) {
            Log.d("GestureAccessibility", "onServiceDisconnected")
            mRecordServiceBinder?.setOnGestureRecordedListener(null)
            mRecordServiceBinder = null


        }

        override fun onServiceConnected(name: ComponentName?, service: IBinder?) {
            Log.d("GestureAccessibility", "onServiceConnected")
            if (service is GestureRecorderService.IGestureRecordBinder) {
                service.setOnGestureRecordedListener(this@GestureAccessibility)
                mRecordServiceBinder = service

            }

        }
    }

    private fun bindGestureRecordService() {
        bindService(
                Intent(this, GestureRecorderService::class.java),
                mServiceConnection,
                Context.BIND_AUTO_CREATE
        )
    }


    //==========================Listener==================================//


    override fun onStartRecord() {
        mGestureRecorderWatcher?.onStartRecord()
    }


    override fun onRecording(gestureInfo: GestureInfo) {
        mGestureRecorderWatcher?.onRecording(gestureInfo)
        startGesture(gestureInfo, object : GestureResultCallback() {
            override fun onCancelled(gestureDescription: GestureDescription?) {
                mRecordServiceBinder?.onResult(true)
            }

            override fun onCompleted(gestureDescription: GestureDescription?) {
                mRecordServiceBinder?.onResult(false)
            }
        }, true)

    }

    override fun onStopRecord(gestureInfoList: ArrayList<GestureInfo>) {
        mGestureRecorderWatcher?.onStopRecord(gestureInfoList)
        unbindService(mServiceConnection)
    }

    override fun onCancelRecord() {
        mGestureRecorderWatcher?.onCancelRecord()
        unbindService(mServiceConnection)
    }

    //=======================================================================================//


    override fun onInterrupt() {


    }


    override fun onAccessibilityEvent(event: AccessibilityEvent) {


    }


}