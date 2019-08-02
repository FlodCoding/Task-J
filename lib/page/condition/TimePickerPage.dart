import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_j/style/CommonStyle.dart';

class TimePickerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TimePickerPageState();
  }
}

class TimePickerPageState extends State<TimePickerPage> with SingleTickerProviderStateMixin {
  var mTimeOfDay = TimeOfDay.now();

  //Repeat Option
  static const STRING_NO_REPEAT = "只执行一次";
  bool isRepeatOptionExpanded = false;
  Animation optionIconAnim;
  AnimationController optionIconAnimController;
  List<bool> weekSelectedList = List(7);
  String weekSelectedText = STRING_NO_REPEAT;

  //Select Date
  DateTime mDateTime;
  String mDaySelectedText;

  @override
  void initState() {
    //init Animation
    super.initState();
    optionIconAnimController = new AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    optionIconAnim = new Tween(begin: 0.0, end: 0.125).animate(optionIconAnimController);

    //init weekSelectedList
    print(weekSelectedList.length);
    weekSelectedList.fillRange(0, weekSelectedList.length, false);
    weekSelectedText = STRING_NO_REPEAT;

    //init SelectDate
    mDaySelectedText = "今天";
  }

  @override
  void dispose() {
    optionIconAnimController.dispose();
    super.dispose();
  }

  _onTimeSelected(TimeOfDay value) {
    if (mDateTime == null) {
      var nowTime = TimeOfDay.now();
      if (value.hour > nowTime.hour) {
        mDaySelectedText = "今天";
        mDateTime = DateTime.now();
      } else {
        mDaySelectedText = "明天";
        mDateTime = DateTime.now().add(Duration(days: 1));
      }
    }
    setState(() {
      mTimeOfDay = value;
    });
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

  _onWeekSelected(int index, bool b) {
    setState(() {
      weekSelectedList[index] = b;
      weekSelectedText =
          "${weekSelectedList[0] ? '周一 ' : ''}${weekSelectedList[1] ? '周二 ' : ''}${weekSelectedList[2] ? '周三 ' : ''}"
          "${weekSelectedList[3] ? '周四 ' : ''}${weekSelectedList[4] ? '周五 ' : ''}"
          "${weekSelectedList[5] ? '周六 ' : ''}${weekSelectedList[6] ? "周日 " : ''}";

      if (weekSelectedText.isEmpty) {
        weekSelectedText = STRING_NO_REPEAT;
      } else if (weekSelectedText.length > 15) {
        // weekSelectedText.startsWith(pattern)
        weekSelectedText =
            weekSelectedText.substring(0, 15) + "\n" + weekSelectedText.substring(15, weekSelectedText.length);
      }
    });
  }

  _onDateSelected(DateTime dateTime) {
    setState(() {
      mDateTime = dateTime;
      DateTime now = DateTime.now();
      if (dateTime.day == now.day) {
        mDaySelectedText = "今天";
      } else if (dateTime.day == now.day + 1) {
        mDaySelectedText = "明天";
      } else {
        mDaySelectedText = formatDate(dateTime, [yyyy, '-', mm, '-', dd]);
      }
    });
  }

  TextStyle _changeChipTextStyle(bool isSelect) {
    return TextStyle(color: isSelect ? Colors.white : Colors.black54);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          title: Text(""),
          centerTitle: true,
          elevation: 0,
          brightness: Brightness.light,
          actionsIconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          leading: Padding(
            padding: EdgeInsets.only(top: 15),
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
                        _onTimeSelected(timeOfDay);
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
                        style: TextStyle(fontSize: 80, letterSpacing: 4, color: Colors.black),
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

          Padding(padding: EdgeInsets.only(top: 30)),

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
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Text(
                    weekSelectedText,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                )
              ],
            ),
            trailing: RotationTransition(
                turns: optionIconAnim,
                child: Icon(
                  Icons.add,
                  size: 30,
                )),
            onExpansionChanged: (bool) {
              _onRepeatOpExpand(bool);
            },
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.end,
                  spacing: 8,
                  children: <Widget>[
                    ChoiceChip(
                      selectedColor: CommonColors.lightBlue,
                      label: Text(
                        "周一",
                        style: _changeChipTextStyle(weekSelectedList[0]),
                      ),
                      selected: weekSelectedList[0],
                      onSelected: (b) {
                        _onWeekSelected(0, b);
                      },
                    ),
                    ChoiceChip(
                        selectedColor: CommonColors.lightBlue,
                        label: Text(
                          "周二",
                          style: _changeChipTextStyle(weekSelectedList[1]),
                        ),
                        selected: weekSelectedList[1],
                        onSelected: (b) {
                          _onWeekSelected(1, b);
                        }),
                    ChoiceChip(
                        selectedColor: CommonColors.lightBlue,
                        label: Text(
                          "周三",
                          style: _changeChipTextStyle(weekSelectedList[2]),
                        ),
                        selected: weekSelectedList[2],
                        onSelected: (b) {
                          _onWeekSelected(2, b);
                        }),
                    ChoiceChip(
                        selectedColor: CommonColors.lightBlue,
                        label: Text(
                          "周四",
                          style: _changeChipTextStyle(weekSelectedList[3]),
                        ),
                        selected: weekSelectedList[3],
                        onSelected: (b) {
                          _onWeekSelected(3, b);
                        }),
                    ChoiceChip(
                        selectedColor: CommonColors.lightBlue,
                        label: Text(
                          "周五",
                          style: _changeChipTextStyle(weekSelectedList[4]),
                        ),
                        selected: weekSelectedList[4],
                        onSelected: (b) {
                          _onWeekSelected(4, b);
                        }),
                    ChoiceChip(
                        selectedColor: CommonColors.lightBlue,
                        label: Text(
                          "周六",
                          style: _changeChipTextStyle(weekSelectedList[5]),
                        ),
                        selected: weekSelectedList[5],
                        onSelected: (b) {
                          _onWeekSelected(5, b);
                        }),
                    ChoiceChip(
                        selectedColor: CommonColors.lightBlue,
                        label: Text(
                          "周日",
                          style: _changeChipTextStyle(weekSelectedList[6]),
                        ),
                        selected: weekSelectedList[6],
                        onSelected: (b) {
                          _onWeekSelected(6, b);
                        }),
                  ],
                ),
              ),
            ],
          ),

          //选择日期
          Offstage(
            offstage: weekSelectedText != STRING_NO_REPEAT ,
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Text(
                      "选择日期",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Text(
                      mDaySelectedText,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  )
                ],
              ),
              trailing: Icon(
                Icons.add,
                size: 30,
              ),
              onTap: () {
                DateTime dateNow = DateTime.now();
                DateTime firstDate = dateNow.subtract(Duration(days: 1));
                DateTime lastDate = DateTime(dateNow.year + 1);
                showDatePicker(context: context, initialDate: dateNow, firstDate: firstDate, lastDate: lastDate)
                    .then((value) {
                  if (value != null) {
                    _onDateSelected(value);
                  }
                });
              },
            ),
          ),
        ],
      ),
      floatingActionButton:  Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: FloatingActionButton(
                onPressed: () {},
                isExtended: false,
                child: Icon(Icons.done),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
