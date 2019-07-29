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
      },
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        /* elevation: 5,
        margin: EdgeInsets.only(left: 10, right: 10, top: 8),*/
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 20),
              width: 25,
              height: 25,
              color: Colors.blue,
            ),
            /*   Icon(
              Icons.person,

              size: 50,
            ),*/
            Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "任务名称",
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "触发条件",
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
