package com.flodcoding.task_j.service

import android.annotation.SuppressLint
import android.app.Service
import android.content.Context
import android.content.Intent
import android.gesture.GesturePoint
import android.graphics.Color
import android.graphics.PixelFormat
import android.os.Binder
import android.os.Build
import android.os.IBinder
import android.os.SystemClock
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager

import com.flod.view.GestureCatchView
import com.flod.view.GestureInfo
import com.flod.view.GestureType
import com.flodcoding.task_j.R
import com.flodcoding.task_j.view.MovableLayout
import kotlinx.android.synthetic.main.layout_record_btn.view.*

/**
 * SimpleDes:
 * Creator: Flood
 * Date: 2019-09-22
 * UseDes:
 *
 */
@SuppressLint("InflateParams")
class GestureRecordService : Service() {

    private val windowManager by lazy { getSystemService(Context.WINDOW_SERVICE) as WindowManager }


    private val gestureView: GestureCatchView by lazy {
        val gestureCatchView = GestureCatchView(this)
        gestureCatchView.setBackgroundColor(Color.WHITE)
        gestureCatchView.alpha = 0.5f
        var isAfterGesture: Boolean
        gestureCatchView.onGestureListener = object : GestureCatchView.OnGestureListener {
            override fun onGesturing(gesturePoint: GesturePoint) {

            }

            override fun onGestureFinish(gestureType: GestureType, gestureInfo: GestureInfo) {
                //TODO 是否有可能不断 enable GestureCatchView
                Log.d("GestureAccessibility", "onGestureFinish")
                isAfterGesture = true
                gestureInfo.delayTime = 0
                //由於 updateViewLayout會有延遲，所以添加一個監聽器，一旦更新完狀態就分發手勢給AccessibilityService
                gestureCatchView.addOnLayoutChangeListener(object : View.OnLayoutChangeListener {
                    override fun onLayoutChange(v: View?, left: Int, top: Int, right: Int, bottom: Int, oldLeft: Int, oldTop: Int, oldRight: Int, oldBottom: Int) {
                        if (isAfterGesture) {
                            dispatchGesture(gestureInfo)
                            isAfterGesture = false
                        }
                        gestureCatchView.removeOnLayoutChangeListener(this)
                    }
                })

                enableGestureCatchView(false)
            }
        }


        gestureCatchView
    }

    private val gestureViewParams by lazy {
        val params = WindowManager.LayoutParams()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            params.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
        } else {
            params.type = WindowManager.LayoutParams.TYPE_TOAST;
        }


        params.format = PixelFormat.RGBA_8888
        params.flags = WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE or
                WindowManager.LayoutParams.FLAG_FULLSCREEN or
                WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN
        params.width = WindowManager.LayoutParams.MATCH_PARENT
        params.height = WindowManager.LayoutParams.MATCH_PARENT
        params
    }

    private val recordBtn by lazy {
        val recordBtn = LayoutInflater.from(this).inflate(
            R.layout.layout_record_btn,
            null
        ) as MovableLayout
        val layRecord = recordBtn.layRecord
        val tvRecord = recordBtn.tvRecord
        val imRecord = recordBtn.imRecord
        val layClose = recordBtn.layClose;
        tvRecord.text = "开始"

        layRecord.setOnClickListener {
            it.isActivated = !it.isActivated
            if (it.isActivated) {
                //Start
                imRecord.setImageResource(R.drawable.ic_stop_white)
                tvRecord.base = SystemClock.elapsedRealtime()
                tvRecord.start()
                startRecord()


            } else {
                //STOP
                imRecord.setImageResource(R.drawable.ic_circle_white)
                tvRecord.stop()
                stopRecord()
            }
        }

        layClose.setOnClickListener {
            tvRecord.stop()
            cancelRecord()
        }
        recordBtn
    }

    //開放給客戶端的接口
    inner class IGestureRecordBinder : Binder() {

        fun getService(): GestureRecordService {
            return this@GestureRecordService
        }

        fun setOnGestureRecordedListener(listener: OnGestureRecordServiceListener?) {
            onGestureRecordServiceListener = listener
        }

        fun onResult(isCancel: Boolean) {
            enableGestureCatchView(true)
        }

    }

    private var onGestureRecordServiceListener: OnGestureRecordServiceListener? = null

    //反饋給客戶端的接口
    interface OnGestureRecordServiceListener {
        fun onStartRecord()
        fun onRecorded(gestureInfo: GestureInfo)
        fun onStopRecord(gestureInfoList: ArrayList<GestureInfo>)
        fun onUnbindRecordService()
    }


    override fun onRebind(intent: Intent?) {
        Log.d("GestureAccessibility", "onRebind")
        super.onRebind(intent)
    }


    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d("GestureAccessibility", "onStartCommand")
        return super.onStartCommand(intent, flags, startId)
    }

    override fun onUnbind(intent: Intent?): Boolean {
        Log.d("GestureAccessibility", "onUnbind")
        return super.onUnbind(intent)
    }

    override fun onDestroy() {
        Log.d("GestureAccessibility", "onDestroy")
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? {
        windowManager.addView(gestureView, gestureViewParams)
        windowManager.addView(recordBtn, recordBtn.windowLayoutParams)
        return IGestureRecordBinder()
    }


    private fun dispatchGesture(gestureInfo: GestureInfo) {
        onGestureRecordServiceListener?.onRecorded(gestureInfo)
    }

    private fun startRecord() {
        enableGestureCatchView(true)
        gestureView.startRecord()
        onGestureRecordServiceListener?.onStartRecord()
    }

    private fun stopRecord() {
        enableGestureCatchView(false)
        val result = gestureView.stopRecord()
        onGestureRecordServiceListener?.onStopRecord(result)
    }

    private fun cancelRecord() {
        windowManager.removeView(recordBtn)
        windowManager.removeView(gestureView)
        onGestureRecordServiceListener?.onUnbindRecordService()
    }


    private fun enableGestureCatchView(enable: Boolean) {
        if (enable) {
            gestureViewParams.flags = WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL or
                    WindowManager.LayoutParams.FLAG_FULLSCREEN or
                    WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN
            gestureView.alpha = 0.3f
        } else {
            gestureViewParams.flags = WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE or
                    WindowManager.LayoutParams.FLAG_FULLSCREEN or
                    WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN
            gestureView.alpha = 0.6f
        }
        windowManager.updateViewLayout(gestureView, gestureViewParams)
    }
}