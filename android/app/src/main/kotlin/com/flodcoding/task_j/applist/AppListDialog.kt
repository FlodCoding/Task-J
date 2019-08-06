package com.flodcoding.task_j.applist

/**
 * SimpleDes:
 * Creator: Flood
 * Date: 2019-08-06
 * UseDes:
 */
class AppListDialog {
    /*: DialogFragment()*/

    /*@NonNull
    fun onCreateDialog(@Nullable savedInstanceState: Bundle): Dialog {
        setStyle(STYLE_NO_TITLE, 0)
        return super.onCreateDialog(savedInstanceState)
    }


    fun onStart() {
        super.onStart()
        //设置大小只有在这里可以生效，具体原因还不清楚
        val wm = requireContext().getSystemService(Context.WINDOW_SERVICE) as WindowManager
        if (wm != null) {
            val display = wm.defaultDisplay
            val point = Point()
            display.getSize(point)
            if (getDialog() != null) {
                val window = getDialog().getWindow()
                if (window != null) {
                    window!!.setLayout((point.x * 0.9).toInt(), ViewGroup.LayoutParams.WRAP_CONTENT)
                }
            }

        }
    }


    fun show(@NonNull manager: FragmentManager) {

        //如果能找到就说明还在显示，那么就不显示
        val remain = manager.findFragmentByTag("AppListDialog") as AppListDialog
        if (remain != null) return
        //显示一个新的
        val dialog = AppListDialog()
        try {
            dialog.showNow(manager, "AppListDialog")
        } catch (e: Exception) {
            e.printStackTrace()
        }

    }


    @Nullable
    fun onCreateView(@NonNull inflater: LayoutInflater, @Nullable container: ViewGroup, @Nullable savedInstanceState: Bundle): View {
        val root = inflater.inflate(R.layout.dialog_applist, container)
        val recyclerView = root.findViewById(R.id.recyclerView)
        recyclerView.setLayoutManager(LinearLayoutManager(requireContext()))

        val adapter = Adapter(AppListUtil.getSimpleInstalledAppInfoList(requireContext()))

        recyclerView.setAdapter(adapter)

        return root
    }


    private inner class Adapter internal constructor(private val mInfoList: List<AppInfoBean>) : RecyclerView.Adapter<Adapter.Holder>() {

        val itemCount: Int
            get() = mInfoList.size

        @NonNull
        fun onCreateViewHolder(@NonNull viewGroup: ViewGroup, i: Int): Holder {
            val v = LayoutInflater.from(viewGroup.context).inflate(R.layout.item_applist, viewGroup, false)
            return Holder(v)
        }

        fun onBindViewHolder(@NonNull holder: Holder, i: Int) {
            val info = mInfoList[i]
            holder.imIcon.setImageDrawable(info.icon)
            holder.tvTitle.text = info.appName
            holder.itemView.setOnClickListener(View.OnClickListener { requireActivity().startActivity(info.getStartIntent()) })
        }

        internal inner class Holder(@NonNull itemView: View) : RecyclerView.ViewHolder(itemView) {
            private val imIcon: AppCompatImageView
            private val tvTitle: TextView

            init {
                imIcon = itemView.findViewById(R.id.imIcon)
                tvTitle = itemView.findViewById(R.id.tvTitle)
            }
        }
    }*/


}
