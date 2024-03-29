@file:Suppress("unused")

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
class GestureAccessibility : AccessibilityService(), GestureWatcher.Recorder {

    private var mMode: Int = 0

    companion object {
        private const val FLAG_MODE = "FLAG_MODE"
        private const val MODE_DISPATCH_GESTURE = 1
        private const val MODE_GESTURE_RECORD_DEFAULT = 2 //启动后手动开启录制
        private const val MODE_GESTURE_RECORD_AUTO = 3    //启动后立刻开始录制


        private var mWatcher: GestureWatcher.Accessibility? = null

        //由于onBind 在AccessibilityService中被设置为final，无法使用bindService与外界通信
        //目前就先使用静态接口，通过接口将数据回调出去，不太好的做法，后面是否考虑别的方式
        fun setGestureRecorderWatcher(watcher: GestureWatcher.Accessibility?) {
            mWatcher = watcher
        }

        fun startGestures(context: Context, gestures: ArrayList<GestureInfo>) {
            val intent = Intent(context, GestureAccessibility::class.java)
            intent.putExtra(FLAG_MODE, MODE_DISPATCH_GESTURE)
            intent.putParcelableArrayListExtra("gesture", gestures)
            context.startService(intent)
        }

        fun startRecordService(context: Context) {
            val intent = Intent(context, GestureAccessibility::class.java)
            intent.putExtra(FLAG_MODE, MODE_GESTURE_RECORD_DEFAULT)
            context.startService(intent)
        }

        fun startRecord(context: Context) {
            val intent = Intent(context, GestureAccessibility::class.java)
            intent.putExtra(FLAG_MODE, MODE_GESTURE_RECORD_AUTO)
            context.startService(intent)
        }
    }

    override fun onUnbind(intent: Intent?): Boolean {
        mWatcher = null
        return super.onUnbind(intent)
    }


    override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {
        Log.d("GestureAccessibility", "onStartCommand")

        mMode = intent.getIntExtra(FLAG_MODE, 0)
        when (mMode) {
            MODE_DISPATCH_GESTURE -> {
                val gestures = intent.getParcelableArrayListExtra<GestureInfo>("gesture")
                if (gestures != null) {
                    dispatchGestures(gestures)
                }
            }
            //RecordGesture
            MODE_GESTURE_RECORD_DEFAULT or
                    MODE_GESTURE_RECORD_AUTO -> bindGestureRecordService()
        }

        return super.onStartCommand(intent, flags, startId)
    }


    private fun dispatchGestures(gestures: ArrayList<GestureInfo>) {

        var index = 0
        val callBack = object : AccessibilityService.GestureResultCallback() {
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


    private fun startGesture(gestureInfo: GestureInfo,
                             gestureResultCallback: GestureResultCallback,
                             immediately: Boolean) {

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

                //自动开始
                if (mMode == MODE_GESTURE_RECORD_AUTO) {
                    service.performStart()
                }

            }

        }
    }

    private fun bindGestureRecordService() {
        val intent = Intent(this, GestureRecorderService::class.java)
        bindService(intent, mServiceConnection, Context.BIND_AUTO_CREATE)
    }


    //==========================Recorder==================================//


    override fun onStartRecord() {
        mWatcher?.onStartRecord(this)
    }


    override fun onRecording(gestureInfo: GestureInfo) {
        mWatcher?.onRecording(this, gestureInfo)
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
        mWatcher?.onStopRecord(this, gestureInfoList)
        unbindService(mServiceConnection)
    }

    override fun onCancelRecord() {
        mWatcher?.onCancelRecord(this)
        unbindService(mServiceConnection)
    }

    //=======================================================================================//


    override fun onInterrupt() {


    }


    override fun onAccessibilityEvent(event: AccessibilityEvent) {
    }


}