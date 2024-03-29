import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_j/model/bean/TaskItemBean.dart';
import 'package:task_j/plugins/CallNative.dart';

import 'condition/TimePickerPage.dart';

class TaskDetailPage extends StatefulWidget {
  final TaskBean _bean;

  TaskDetailPage(this._bean);

  @override
  TaskDetailPageState createState() => TaskDetailPageState();
}

class TaskDetailPageState extends State<TaskDetailPage> {
  TaskBean _taskItemBean;

  @override
  void initState() {
    super.initState();
    if (widget._bean == null) {
      _taskItemBean = TaskBean(time: null, appInfo: null);
    } else {
      _taskItemBean = widget._bean;
    }
  }

  void selectApp() async {
    AppInfoBean appInfo = await CallNative.selectApp();
    if (appInfo != null) {
      setState(() {
        if (_taskItemBean.appInfoBean != null &&
            !_taskItemBean.appInfoBean.launchPackage.endsWith(appInfo.launchPackage)) {
          //更换了App，重置手势
          _taskItemBean.gesture = null;
        }

        _taskItemBean.appInfoBean = appInfo;
      });
    }
  }

  void addGesture() async {
    Gesture gesture = await CallNative.addGesture(_taskItemBean.appInfoBean);
    if (gesture != null) {
      setState(() {
        _taskItemBean.gesture = gesture;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _timeBean = _taskItemBean.timeBean;
    final _appInfoBean = _taskItemBean.appInfoBean;

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: AppBar(
              brightness: Brightness.light,
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
                      _timeBean == null ? "添加触发时间" : _timeBean.toString(),
                      style: TextStyle(fontSize: 20),
                    )),
                    FloatingActionButton(
                      elevation: 0,
                      onPressed: () async {
                        dynamic result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TimePickerPage(
                                      _timeBean,
                                    )));
                        if (result is TimeBean) {
                          setState(() {
                            _taskItemBean.timeBean = result;
                          });
                        }
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                        onPressed: () {
                          selectApp();
                        },
                        child: Row(
                          children: <Widget>[
                            //app图标
                            Container(
                              child: _appInfoBean == null
                                  ? null
                                  : Image.memory(
                                      _appInfoBean.appIconBytes,
                                      width: 40,
                                      height: 40,
                                    ),
                            ),
                            Text(
                              _appInfoBean == null ? "添加应用" : "  ${_appInfoBean.appName}",
                              style: TextStyle(fontSize: 20, color: Colors.black),
                            )
                          ],
                        )),
                    FloatingActionButton(
                      elevation: 0,
                      onPressed: () async {
                        //去选择App
                        if (_taskItemBean.appInfoBean == null) {
                          selectApp();
                        } else {
                          //去录制手势
                          addGesture();
                        }
                      },
                      heroTag: "fab2",
                      child: Icon(_taskItemBean.appInfoBean == null
                          ? Icons.add
                          : (_taskItemBean.gesture == null ? Icons.video_call : Icons.videocam)),
                      backgroundColor: Color.fromARGB(0xFF, 114, 132, 156),
                      mini: true,
                    )
                  ],
                )),
          ],
        ),
      ),
      floatingActionButton: _timeBean != null && _appInfoBean != null
          ? Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pop(context, _taskItemBean);
                },
                isExtended: false,
                child: Icon(Icons.done),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
