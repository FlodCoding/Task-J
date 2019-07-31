import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TaskItemState();
  }
}

class _TaskItemState extends State<TaskItem> {
  bool _switchValue = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        //TODO 任务详情
        Navigator.pushNamed(context, "/TaskDetailPage")
      },
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 20),
              width: 25,
              height: 25,
              color: Colors.blue,
            ),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "任务名称",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "任务内容",
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )),
            CupertinoSwitch(
              value: _switchValue,
              activeColor: Colors.blue,
              onChanged: (bool) {
                setState(() {
                  _switchValue = !_switchValue;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
