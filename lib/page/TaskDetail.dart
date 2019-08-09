import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_j/model/bean/TaskItemBean.dart';
import 'package:task_j/plugins/CallNative.dart';

class TaskDetailPage extends StatefulWidget {
  @override
  TaskDetailPageState createState() => TaskDetailPageState();
}

class TaskDetailPageState extends State<TaskDetailPage> {
  //String _conditionStr;

  //String _taskStr;

  TimeBean _timeBean;
  AppInfoBean _appInfoBean;

  /*String _appName;
  Uint8List _appIconBytes = Uint8List(0);*/

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
                      _timeBean == null ? "添加触发时间" : _timeBean.format(context),
                      style: TextStyle(fontSize: 20),
                    )),
                    FloatingActionButton(
                      elevation: 0,
                      onPressed: () async {
                        dynamic result = await Navigator.pushNamed(context, "/TimePickerPage");
                        if (result is TimeBean) {
                          setState(() {
                            _timeBean = result;
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

                    //appName
                    Expanded(
                        child: Text(
                      _appInfoBean == null ? "添加应用" : "  ${_appInfoBean.appName}",
                      style: TextStyle(fontSize: 20),
                    )),
                    FloatingActionButton(
                      elevation: 0,
                      onPressed: () async {
                        AppInfoBean appInfo = await CallNative.selectApp();
                        if (appInfo != null) {
                          setState(() {
                            _appInfoBean = appInfo;
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
      floatingActionButton: _timeBean != null && _appInfoBean != null
          ? Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: FloatingActionButton(
                onPressed: () async {
                  CallNative.saveTask();
                  Navigator.pop(context, TaskItemBean(time: _timeBean, appInfo: _appInfoBean));
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
