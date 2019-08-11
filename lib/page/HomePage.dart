import 'dart:typed_data';

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

typedef LongPressCallback();

class _HomePageState extends State<HomePage> {
  List<TaskItemBean> _list = [];
  bool _showDeleteIcon = false;

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
                setState(() {
                  _list.add(TaskItemBean(appInfo: AppInfoBean("sss", Uint8List(0)), time: null));
                });

                break;
              case 1:
                //TODO 去关于
                var result = await CallNative.getSavedList();
                if(result !=null ){
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
            return TaskItem((showDeleteIcon, deleteThis) {
              //OnDeleteCallback
              setState(() {
                _showDeleteIcon = showDeleteIcon;
                if (deleteThis) {
                  _list.removeAt(index);
                  CallNative.deleteTask(_list[index].id);
                }
              });
            }, _showDeleteIcon, _list[index]);
          },
          itemCount: _list.length),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          dynamic result = await Navigator.push(context, MaterialPageRoute(builder: (context) => TaskDetailPage(null)));
          if (result is TaskItemBean) {
            setState(() {
              _list.add(result);
              CallNative.addTask(result);
            });
          }
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
