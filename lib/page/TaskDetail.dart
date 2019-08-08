import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_j/model/bean/TaskItemBean.dart';
import 'package:task_j/plugins/CallNative.dart';

class TaskDetailPage extends StatefulWidget {
  @override
  TaskDetailPageState createState() => TaskDetailPageState();
}

class TaskDetailPageState extends State<TaskDetailPage> {
  bool _conditionSet = false;
  bool _taskSet = false;

  String _conditionStr;

  //String _taskStr;

  Uint8List _appIconBytes = Uint8List(0);
  String _appName;
  String _appImagePath;

  @override
  void initState() {
    _conditionStr = "添加触发时间";
    _appName = "选择应用";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: AppBar(
              brightness: Brightness.light,
              title: TextField(
                maxLines: 1,
                autofocus: false,
                style: TextStyle(fontSize: 25),
                decoration: InputDecoration(hintText: "输入一个任务名", border: InputBorder.none),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: Padding(
                padding: EdgeInsets.only(top: 0),
                child: IconButton(
                    color: Colors.black,
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
            ),
          )),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //标题"触发条件"
            Padding(
                padding: EdgeInsets.only(bottom: 10, top: 50),
                child: RaisedButton(
                  padding: EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 10),
                  disabledColor: Color.fromARGB(0xFF, 53, 186, 243),
                  onPressed: null,
                  child: Text(
                    "触发时间",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8))),
                )),
            Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                      _conditionStr,
                      style: TextStyle(fontSize: 20),
                    )),
                    FloatingActionButton(
                      elevation: 0,
                      onPressed: () async {
                        dynamic result = await Navigator.pushNamed(context, "/TimePickerPage");
                        if (result != null && result is TimeBean) {
                          setState(() {
                            _conditionSet = true;
                            _conditionStr = result.format(context);
                          });
                        }
                        // showConditionDialog(context);
                      },
                      heroTag: "fab1",
                      backgroundColor: Color.fromARGB(0xFF, 53, 186, 243),
                      child: Icon(Icons.add),
                      mini: true,
                    )
                  ],
                )),

            //标题"执行任务"
            Padding(
                padding: EdgeInsets.only(bottom: 10, top: 50),
                child: RaisedButton(
                  padding: EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 10),
                  disabledColor: Color.fromARGB(0xFF, 114, 132, 156),
                  onPressed: null,
                  child: Text(
                    "选择应用",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8))),
                )),
            Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: <Widget>[
                    Visibility(
                      child: Image.memory(
                        _appIconBytes,
                        width: 40,
                        height: 40,
                      ),
                      visible: _taskSet,
                    ),
                    _appImagePath == null
                        ? SizedBox()
                        : Image.file(
                            File(_appImagePath),
                            width: 40,
                            height: 40,
                          ),
                    Expanded(
                        child: Text(
                      _taskSet ? "  $_appName" : "添加应用",
                      style: TextStyle(fontSize: 20),
                    )),
                    FloatingActionButton(
                      elevation: 0,
                      onPressed: () async {
                        AppInfoBean appInfo = await CallNative.selectApp();
                        if (appInfo != null) {
                          setState(() {
                            _taskSet = true;
                            _appName = appInfo.appName;
                            _appIconBytes = appInfo.appIconBytes;
                          });
                        }
                      },
                      heroTag: "fab2",
                      child: Icon(Icons.add),
                      backgroundColor: Color.fromARGB(0xFF, 114, 132, 156),
                      mini: true,
                    )
                  ],
                )),
          ],
        ),
      ),
      floatingActionButton: _conditionSet && _taskSet
          ? Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: FloatingActionButton(
                onPressed: () async {
                  if (_appImagePath == null) {
                    CallNative.saveImage();
                    _appImagePath = "";
                  } else {
                    //String path = await CallNative.getSavedList();
                    //print(path);
                    setState(() {
                      //_appImagePath = path;
                    });
                  }
                },
                isExtended: false,
                child: Icon(Icons.done),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  showConditionDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: Text("触发类型", style: TextStyle(fontSize: 22)),
              children: <Widget>[
                SimpleDialogOption(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[Text("定时", style: TextStyle(fontSize: 18))],
                  ),
                  onPressed: () {
                    //选择一个时间
                    Navigator.pop(context, 1);
                  },
                ),
                SimpleDialogOption(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "施工中...",
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                ),
              ],
            )).then((value) async {
      if (value == 1) {
        //时间选择的弹窗
        /*showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );*/
        Future va = await Navigator.pushNamed(context, "/TimePickerPage");
      }
    });
  }
}
