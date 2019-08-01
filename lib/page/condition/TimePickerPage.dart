import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimePickerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TimePickerPageState();
  }
}

class TimePickerPageState extends State<TimePickerPage> with SingleTickerProviderStateMixin {
  var mTimeOfDay = TimeOfDay.now();

  //Repeat Option
  bool isRepeatOptionExpanded = false;
  Animation optionIconAnim;
  AnimationController optionIconAnimController;
  List<bool> weekSelectedList = List(7);
  String weekSelectedText;

  @override
  void initState() {
    //init Animation
    super.initState();
    optionIconAnimController = new AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    optionIconAnim = new Tween(begin: 0.0, end: 0.125).animate(optionIconAnimController);

    //init weekSelectedList
    print(weekSelectedList.length);
    weekSelectedList.fillRange(0, weekSelectedList.length, false);
    weekSelectedText = "";
  }

  _onRepeatOpExpand(bool expand) {
    isRepeatOptionExpanded = expand;
    setState(() {
      if (expand) {
        optionIconAnimController.forward();
      } else {
        optionIconAnimController.reverse();
      }
    });
  }

  _onWeekSelected(int index) {
    setState(() {
      weekSelectedList[index] = !weekSelectedList[index];
      weekSelectedText =
          "${weekSelectedList[0] ? '周一 ' : ''}${weekSelectedList[1] ? '周二 ' : ''}${weekSelectedList[2] ? '周三 ' : ''}"
          "${weekSelectedList[3] ? '周四 ' : ''}${weekSelectedList[4] ? '周五 ' : ''}"
          "${weekSelectedList[5] ? '周六 ' : ''}${weekSelectedList[6] ? "周日 " : ''}";

      if (weekSelectedList.length > 5) {
       // weekSelectedText.startsWith(pattern)
      }
    });
  }

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //时间
          Center(
              child: FlatButton(
                  onPressed: () {
                    showTimePicker(context: context, initialTime: mTimeOfDay).then((timeOfDay) {
                      if (timeOfDay != null) {
                        setState(() {
                          mTimeOfDay = timeOfDay;
                          print(mTimeOfDay.toString());
                        });
                      }
                    }).catchError((err) {
                      print(err.toString());
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        '${mTimeOfDay.hour == 12 || mTimeOfDay.hour == 0 ? 12 : mTimeOfDay.hourOfPeriod}:${mTimeOfDay.minute}',
                        style: TextStyle(fontSize: 70, letterSpacing: 4, color: Colors.black),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 15, left: 5),
                        child: Text(
                          mTimeOfDay.period == DayPeriod.am ? "AM" : "PM",
                          style: TextStyle(fontSize: 30, color: Colors.black),
                        ),
                      )
                    ],
                  ))),

          //重复选项
          ExpansionTile(
            backgroundColor: Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Text(
                    "重复",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Text(
                    "${weekSelectedList[0] ? '周一 ' : ''}${weekSelectedList[1] ? '周二 ' : ''}${weekSelectedList[2] ? '周三 ' : ''}"
                    "${weekSelectedList[3] ? '周四 ' : ''}${weekSelectedList[4] ? '周五 ' : ''}"
                    "${weekSelectedList[5] ? '周六 ' : ''}${weekSelectedList[6] ? "周日 " : ''}",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                )
              ],
            ),
            trailing: RotationTransition(
                turns: optionIconAnim, child: Icon(Icons.add, size: 30, color: Color.fromARGB(0xFF, 53, 186, 243))),
            onExpansionChanged: (bool) {
              _onRepeatOpExpand(bool);
            },
            initiallyExpanded: true,
            children: <Widget>[
              ListTile(
                title: Text('周一'),
                trailing: Checkbox(value: weekSelectedList[0], onChanged: null),
                onTap: () {
                  setState(() {
                    weekSelectedList[0] = !weekSelectedList[0];
                  });
                },
              ),
              ListTile(
                title: Text('周二'),
                trailing: Checkbox(value: weekSelectedList[1], onChanged: null),
                onTap: () {
                  setState(() {
                    weekSelectedList[1] = !weekSelectedList[1];
                  });
                },
              ),
              ListTile(
                title: Text('周三'),
                trailing: Checkbox(value: weekSelectedList[2], onChanged: null),
                onTap: () {
                  setState(() {
                    weekSelectedList[2] = !weekSelectedList[2];
                  });
                },
              ),
              ListTile(
                title: Text('周四'),
                trailing: Checkbox(value: weekSelectedList[3], onChanged: null),
                onTap: () {
                  setState(() {
                    weekSelectedList[3] = !weekSelectedList[3];
                  });
                },
              ),
              ListTile(
                title: Text('周五'),
                trailing: Checkbox(value: weekSelectedList[4], onChanged: null),
                onTap: () {
                  setState(() {
                    weekSelectedList[4] = !weekSelectedList[4];
                  });
                },
              ),
              ListTile(
                title: Text('周六'),
                trailing: Checkbox(value: weekSelectedList[5], onChanged: null),
                onTap: () {
                  setState(() {
                    weekSelectedList[5] = !weekSelectedList[5];
                  });
                },
              ),
              ListTile(
                title: Text('周日'),
                trailing: Checkbox(value: weekSelectedList[6], onChanged: null),
                onTap: () {
                  setState(() {
                    weekSelectedList[6] = !weekSelectedList[6];
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
