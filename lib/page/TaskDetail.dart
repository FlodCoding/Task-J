import 'package:flutter/material.dart';

class TaskDetailPage extends StatefulWidget {
  @override
  TaskDetailPageState createState() => TaskDetailPageState();
}

class TaskDetailPageState extends State<TaskDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        centerTitle: true,
        elevation: 0,
        actionsIconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        leading: IconButton(
            color: Colors.black,
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 17, right: 17),
              child: TextField(
                maxLines: 1,
                autofocus: false,
                style: TextStyle(fontSize: 30),
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.assignment,
                      color: Colors.black54,
                      size: 30,
                    ),
                    hintText: "输入一个任务名吧",
                    border: InputBorder.none),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10, left: 17),
              child: Text("触发条件",
                  style: TextStyle(color: Colors.black87, fontSize: 18)),
            ),
            RaisedButton(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              color: Colors.blue[300],
              onPressed: () {},
              child: Text(
                "添加触发条件",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            )
          ],
        ),
      ),
    );
  }
}
