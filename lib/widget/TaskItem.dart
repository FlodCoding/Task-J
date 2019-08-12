import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_j/model/bean/TaskItemBean.dart';
import 'package:task_j/page/TaskDetail.dart';
import 'package:task_j/plugins/CallNative.dart';
import 'package:task_j/style/CommonStyle.dart';

typedef OnDeleteCallback(bool showDeleteIcon, bool deleteThis);

class TaskItem extends StatefulWidget {
  final bool _showDeleteIcon;
  final OnDeleteCallback _onDeleteCallback;
  final TaskItemBean _taskItemBean;

  TaskItem(this._onDeleteCallback, this._showDeleteIcon, this._taskItemBean);

  @override
  State<StatefulWidget> createState() {
    return _TaskItemState();
  }
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    final taskItemBean = widget._taskItemBean;
    final appInfo = taskItemBean.appInfoBean;
    final time = taskItemBean.timeBean;
    return Card(
        color: Colors.white,
        semanticContainer: true,
        elevation: 0,
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          onTap: () async {
            dynamic result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
              return TaskDetailPage(taskItemBean);
            }));
            //TODO 不一定每次都修改
            if (result is TaskItemBean) {
              CallNative.updateTask(result);
              //TODO
              //修改当前的状态
            }
          },
          onLongPress: () => {widget._onDeleteCallback(!widget._showDeleteIcon, false)},
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
                    widget._showDeleteIcon
                        ? IconButton(
                            icon: Icon(
                              Icons.close,
                              color: CommonColors.commonGrey,
                            ),
                            onPressed: () {
                              widget._onDeleteCallback(widget._showDeleteIcon, true);
                            },
                          )
                        : Transform.scale(
                            scale: 0.7,
                            child: CupertinoSwitch(
                              value: taskItemBean.isStart,
                              activeColor: Colors.blue,
                              onChanged: (bool) {
                                setState(() {
                                  taskItemBean.isStart = bool;
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
