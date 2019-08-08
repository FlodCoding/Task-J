import 'package:flutter/material.dart';
import 'package:task_j/model/bean/TaskItemBean.dart';
import 'package:task_j/plugins/CallNative.dart';
import 'package:task_j/widget/TaskItem.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  List<TaskItemBean> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(""),
        brightness: Brightness.light,
        actionsIconTheme: IconThemeData(color: Colors.black),
        actions: <Widget>[
          PopupMenuButton(onSelected: (int) {
            switch (int) {
              case 0:
                //TODO 去设置
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text("设置"),
                      );
                    });
                break;
              case 1:
                //TODO 去关于
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text("关于"),
                      );
                    });
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
      body: ListView.separated(
          itemBuilder: (context, index) {
            return TaskItem();
          },
          separatorBuilder: (context, index) => Divider(
                indent: 55,
                endIndent: 20,
                color: Colors.grey[400],
              ),
          itemCount: list.length),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await CallNative.getSavedList();
          setState(() {
            // list.add(TaskItemBean());`
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
