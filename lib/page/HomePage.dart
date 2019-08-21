import 'package:flutter/material.dart';
import 'package:task_j/model/bean/TaskItemBean.dart';
import 'package:task_j/plugins/CallNative.dart';
import 'package:task_j/widget/TaskItem.dart';

import 'TaskDetail.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  List<TaskItemBean> _list = [];
  bool _showDeleteIcon = false;

  @override
  void initState() {
    super.initState();
    CallNative.getSavedList().then((result) {
      if (result != null && result.isNotEmpty) {
        setState(() => _list = result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(""),
        brightness: Brightness.light,
        actionsIconTheme: IconThemeData(color: Colors.black),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.format_list_bulleted),
            onPressed: () {},
          ),
          PopupMenuButton(onSelected: (int) async {
            switch (int) {
              case 0:
                //TODO 去设置

                break;
              case 1:
                //TODO 去关于
                var result = await CallNative.getSavedList();
                if (result != null) {
                  setState(() {
                    _list = result;
                  });
                }

                break;
            }
          }, itemBuilder: (context) {
            return <PopupMenuEntry<int>>[
              PopupMenuItem(
                child: Text("设置"),
                value: 0,
              ),
              PopupMenuItem(
                child: Text("关于"),
                value: 1,
              )
            ];
          })
        ],
      ),
      body: ListView.builder(
          itemBuilder: (context, index) {
            return TaskItem(
              showDeleteIcon: _showDeleteIcon,
              taskBean: _list[index],
              onDelete: (index, task) {
                CallNative.deleteTask(task.id);
                setState(() {
                  _list.remove(task);
                });
              },
              onLongPress: (showDeleteIcon) {
                setState(() {
                  _showDeleteIcon = showDeleteIcon;
                });
              },
              onUpdate: (index, task) {
                CallNative.updateTask(task);
              },
            );
          },
          itemCount: _list.length),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          dynamic result = await Navigator.push(context, MaterialPageRoute(builder: (context) => TaskDetailPage(null)));
          TaskItemBean taskItemBean = await CallNative.addTask(result);

          if (taskItemBean != null) {
            setState(() {
              _list.add(taskItemBean);
            });
          }
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
