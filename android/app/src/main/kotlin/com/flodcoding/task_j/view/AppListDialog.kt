package com.flodcoding.task_j.view

import android.app.Dialog
import android.content.Context
import android.content.DialogInterface
import android.graphics.Point
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import android.widget.ProgressBar
import android.widget.TextView
import androidx.annotation.NonNull
import androidx.appcompat.widget.AppCompatImageView
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.FragmentManager
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.flodcoding.task_j.R
import com.flodcoding.task_j.data.AppInfoTempBean
import com.flodcoding.task_j.utils.TaskUtil
import kotlinx.coroutines.*

/**
 * SimpleDes:
 * Creator: Flood
 * Date: 2019-08-06
 * UseDes: TODO 搜索功能
 */
class AppListDialog constructor(private val onAppSelectedListener: OnAppSelectedListener) : DialogFragment(), CoroutineScope by MainScope() {
    private lateinit var mAdapter: Adapter
    //private lateinit var onAppSelectedListener:OnAppSelectedListener


    override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
        setStyle(STYLE_NO_TITLE, R.style.Theme_AppCompat_Light_Dialog)
        return super.onCreateDialog(savedInstanceState)
    }

    override fun onStart() {
        super.onStart()
        //设置大小只有在这里可以生效，具体原因还不清楚
        val wm = requireContext().getSystemService(Context.WINDOW_SERVICE) as WindowManager
        val display = wm.defaultDisplay
        val point = Point()
        display.getSize(point)

        dialog?.setCanceledOnTouchOutside(true)
        dialog?.window?.setLayout((point.x * 0.9).toInt(), (point.y * 0.9).toInt())


    }


    fun show(@NonNull manager: FragmentManager) {
        val remain = manager.findFragmentByTag("AppListDialog")
        if (remain != null) return
        try {
            showNow(manager, "AppListDialog")
        } catch (e: Exception) {
            e.printStackTrace()
        }

    }


    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        val root = inflater.inflate(R.layout.dialog_applist, container)
        val progressBar = root.findViewById<ProgressBar>(R.id.progress_circular)
        val recyclerView = root.findViewById<RecyclerView>(R.id.recyclerView)
        recyclerView.layoutManager = LinearLayoutManager(requireContext())


        mAdapter = Adapter()
        recyclerView.adapter = mAdapter

        GlobalScope.launch(Dispatchers.IO) {
            val list = TaskUtil.getSimpleInstalledAppInfoList(requireContext())
            withContext(Dispatchers.Main) {
                mAdapter.setDate(list)
                progressBar.visibility = View.GONE
            }

        }

        return root
    }


    private inner class Adapter : RecyclerView.Adapter<Adapter.Holder>() {
        var mInfoTempList: List<AppInfoTempBean> = ArrayList()
        override fun getItemCount(): Int {
            return mInfoTempList.size
        }


        fun setDate(list: List<AppInfoTempBean>) {
            this.mInfoTempList = list;
            notifyDataSetChanged()
        }

        @NonNull
        override fun onCreateViewHolder(@NonNull viewGroup: ViewGroup, i: Int): Holder {
            val v = LayoutInflater.from(viewGroup.context).inflate(R.layout.item_applist, viewGroup, false)
            return Holder(v)
        }

        override fun onBindViewHolder(@NonNull holder: Holder, i: Int) {
            val info = mInfoTempList[i]
            holder.imIcon.setImageDrawable(info.appIcon)
            holder.tvTitle.text = info.appName
            holder.itemView.setOnClickListener {
                onAppSelectedListener.onSelected(info)
                dismiss()
            }
        }

        internal inner class Holder(@NonNull itemView: View) : RecyclerView.ViewHolder(itemView) {
            val imIcon: AppCompatImageView = itemView.findViewById(R.id.imAppIcon)
            val tvTitle: TextView = itemView.findViewById(R.id.tvAppName)

        }
    }

    override fun onDestroy() {
        super.onDestroy()
        cancel()
    }


    override fun onCancel(dialog: DialogInterface) {
        super.onCancel(dialog)
        onAppSelectedListener.onCancel()
    }


    interface OnAppSelectedListener {
        fun onSelected(appInfoTempBean: AppInfoTempBean?)
        fun onCancel()
    }


}
