import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_j/model/bean/TaskItemBean.dart';
import 'package:task_j/page/TaskDetail.dart';
import 'package:task_j/style/CommonStyle.dart';

typedef OnLongPress(bool showDeleteIcon);
typedef OnDelete(int index, TaskBean task);
typedef OnUpdate(int index, TaskBean task);

class TaskItem extends StatefulWidget {
  final bool showDeleteIcon;
  final OnDelete onDelete;
  final OnLongPress onLongPress;
  TaskBean taskBean;
  final OnUpdate onUpdate;
  final int index;

  TaskItem({this.index, this.showDeleteIcon, @required this.taskBean, this.onLongPress, this.onDelete, this.onUpdate})
      : assert(taskBean != null);

  @override
  State<StatefulWidget> createState() {
    return _TaskItemState();
  }
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    final task = widget.taskBean;
    final appInfo = task.appInfoBean;
    final time = task.timeBean;
    return Card(
        color: Colors.white,
        semanticContainer: true,
        elevation: 0,
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          onTap: () async {
            dynamic result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
              return TaskDetailPage(task);
            }));
            if (result is TaskBean) {
              widget.onUpdate(widget.index, result);

              setState(() {
                widget.taskBean = result;
              });
            }
          },
          onLongPress: () => {widget.onLongPress(!widget.showDeleteIcon)},
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Chip(
                      avatar: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: MemoryImage(appInfo.appIconBytes),
                      ),
                      label: Text(appInfo.appName),
                      backgroundColor: Colors.grey[100],
                    ),
                    widget.showDeleteIcon
                        ? IconButton(
                            icon: Icon(
                              Icons.close,
                              color: CommonColors.commonGrey,
                            ),
                            onPressed: () {
                              widget.onDelete(widget.index, task);
                            },
                          )
                        : Transform.scale(
                            scale: 0.7,
                            child: CupertinoSwitch(
                              value: task.enable,
                              activeColor: Colors.blue,
                              onChanged: (bool) {
                                setState(() {
                                  widget.taskBean.enable = bool;
                                  widget.onUpdate(widget.index, widget.taskBean);
                                });
                              },
                            ),
                          ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                Text(time.repeat ? "${time.repeatInWeekStr()}" : time.dateToString()),
                Padding(padding: EdgeInsets.only(top: 10)),
                Row(
                  children: <Widget>[
                    Text(
                      time.timeOfDayToString(),
                      style: TextStyle(fontSize: 25),
                    ),
                    Expanded(child: Text(" 时打开")),
                    Icon(
                      Icons.keyboard_arrow_right,
                      size: 30,
                      color: CommonColors.commonGrey,
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
