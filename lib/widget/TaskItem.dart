import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_j/model/bean/TaskItemBean.dart';

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
    final itemBean = widget._taskItemBean;
    return Card(
        color: Colors.white,
        semanticContainer: true,
        elevation: 0,
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, "/TaskDetailPage"),
          onLongPress: () => {widget._onDeleteCallback(widget._showDeleteIcon, false)},
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
                        backgroundImage: MemoryImage(itemBean.appInfoBean.appIconBytes),
                      ),
                      label: Text(itemBean.appInfoBean.appName),
                      backgroundColor: Colors.grey[100],
                    ),
                    widget._showDeleteIcon
                        ? IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              widget._onDeleteCallback(widget._showDeleteIcon, true);
                            },
                          )
                        : Transform.scale(
                            scale: 0.7,
                            child: CupertinoSwitch(
                              value: itemBean.start,
                              activeColor: Colors.blue,
                              onChanged: (bool) {
                                setState(() {
                                  itemBean.start = bool;
                                });
                              },
                            ),
                          ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                Text("重复: 周一 周二 周一 周一 周一 周六 "),
                Padding(padding: EdgeInsets.only(top: 10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "10:50上午",
                      style: TextStyle(fontSize: 25),
                    ),
                    Text("打开应用")
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
