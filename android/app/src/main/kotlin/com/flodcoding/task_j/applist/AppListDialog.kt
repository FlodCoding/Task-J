package com.flodcoding.task_j.applist

import android.app.Dialog
import android.content.Context
import android.graphics.Point
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import android.widget.TextView
import androidx.annotation.NonNull
import androidx.appcompat.widget.AppCompatImageView
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.FragmentManager
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.flodcoding.task_j.R

/**
 * SimpleDes:
 * Creator: Flood
 * Date: 2019-08-06
 * UseDes:
 */
class AppListDialog : DialogFragment(){

    override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
        setStyle(STYLE_NO_TITLE, 0)
        return super.onCreateDialog(savedInstanceState)
    }

    override fun onStart() {
        super.onStart()
        //设置大小只有在这里可以生效，具体原因还不清楚
        val wm = requireContext().getSystemService(Context.WINDOW_SERVICE) as WindowManager
            val display = wm.defaultDisplay
            val point = Point()
            display.getSize(point)
            if (getDialog() != null) {
                val window = getDialog().getWindow()
                if (window != null) {
                    window.setLayout((point.x * 0.9).toInt(), ViewGroup.LayoutParams.WRAP_CONTENT)
                }
            }


    }


    fun show(@NonNull manager: FragmentManager) {
        val remain = manager.findFragmentByTag("AppListDialog")
        if (remain != null) return
        val dialog = AppListDialog()
        try {
            dialog.showNow(manager, "AppListDialog")
        } catch (e: Exception) {
            e.printStackTrace()
        }

    }



    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        val root = inflater.inflate(R.layout.dialog_applist, container)
        val recyclerView = root.findViewById(R.id.recyclerView) as RecyclerView
        recyclerView.setLayoutManager(LinearLayoutManager(requireContext()))

        val adapter = Adapter(AppListUtil.getSimpleInstalledAppInfoList(requireContext()))

        recyclerView.adapter = adapter
        return root
    }


    private inner class Adapter internal constructor(private val mInfoList: List<AppInfoBean>) : RecyclerView.Adapter<Adapter.Holder>() {
        override fun getItemCount(): Int {
           return mInfoList.size
        }

        @NonNull
        override fun onCreateViewHolder(@NonNull viewGroup: ViewGroup, i: Int): Holder {
            val v = LayoutInflater.from(viewGroup.context).inflate(R.layout.item_applist, viewGroup, false)
            return Holder(v)
        }

        override fun onBindViewHolder(@NonNull holder: Holder, i: Int) {
            val info = mInfoList[i]
            //holder.imIcon.setImageDrawable(info.icon)
            holder.tvTitle.text = info.appName
            holder.itemView.setOnClickListener { requireActivity().startActivity(info.startIntent) }
        }

        internal inner class Holder(@NonNull itemView: View) : RecyclerView.ViewHolder(itemView) {
             val imIcon: AppCompatImageView = itemView.findViewById(R.id.imAppIcon)
            val tvTitle: TextView = itemView.findViewById(R.id.tvAppName)

        }
    }


}
