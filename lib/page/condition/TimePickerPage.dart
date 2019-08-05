import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_j/model/bean/TaskItemBean.dart';
import 'package:task_j/style/CommonStyle.dart';

class TimePickerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TimePickerPageState();
  }
}

class TimePickerPageState extends State<TimePickerPage> with SingleTickerProviderStateMixin {
  //Repeat Option

  static const _Str_NO_REPEAT = "只执行一次";
  static const _Str_Tomorrow = "明天";
  static const _Str_Today = "今天";
  Animation _optionIconAnim;
  AnimationController _optionIconAnimController;
  List<bool> _repeatInWeekList = List(7);
  String _weekSelectedText = _Str_NO_REPEAT;

  //Select Date
  TimeOfDay _timeOfDay;
  DateTime _dateTime;
  DateTime _dateTimeNow;
  String _daySelectedText;

  @override
  void initState() {
    //init Animation
    super.initState();
    _optionIconAnimController = new AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _optionIconAnim = new Tween(begin: 0.0, end: 0.125).animate(_optionIconAnimController);

    //init weekSelectedList
    _repeatInWeekList.fillRange(0, _repeatInWeekList.length, false);
    _weekSelectedText = _Str_NO_REPEAT;

    //init SelectDate
    _daySelectedText = _Str_Tomorrow;
    _dateTimeNow = DateTime.now();
    _dateTime = _dateTimeNow.add(Duration(days: 1));
    _timeOfDay = TimeOfDay.fromDateTime(_dateTime);
  }

  @override
  void dispose() {
    _optionIconAnimController.dispose();
    super.dispose();
  }

  _onTimeSelected(TimeOfDay value) {
    if (_weekSelectedText == _Str_NO_REPEAT) {
      //不重复
      if (_totalMinute(value) > _totalMinute(TimeOfDay.now())) {
        //选择时间 > 当前时间：今天
        _daySelectedText = _Str_Today;
        _dateTime = _dateTimeNow;
      } else {
        //选择时间 < 当前时间：明天
        _daySelectedText = _Str_Tomorrow;
        _dateTime = _dateTimeNow.add(Duration(days: 1));
      }
    }
    setState(() {
      _timeOfDay = value;
    });
  }

  int _totalMinute(TimeOfDay timeOfDay) {
    return timeOfDay.hour * 60 + timeOfDay.minute;
  }

  _onRepeatOpExpand(bool expand) {
    setState(() {
      if (expand) {
        _optionIconAnimController.forward();
      } else {
        _optionIconAnimController.reverse();
      }
    });
  }

  _onWeekSelected(int index, bool b) {
    _repeatInWeekList[index] = b;
    _weekSelectedText = TimeBean.repeatInWeekStr(_repeatInWeekList);

    if (_weekSelectedText.isEmpty) {
      _weekSelectedText = _Str_NO_REPEAT;
      _onTimeSelected(_timeOfDay);
      //_onTimeSelected 里面会刷新，所以返回
      return;
    } else if (_weekSelectedText.length > 15) {
      _weekSelectedText =
          _weekSelectedText.substring(0, 15) + "\n" + _weekSelectedText.substring(15, _weekSelectedText.length);
    }
    setState(() {});
  }

  _onDateSelected(DateTime dateTime) {
    setState(() {
      _dateTime = dateTime;
      DateTime now = _dateTimeNow;
      if (dateTime.day == now.day + 1) {
        _daySelectedText = _Str_Tomorrow;
      } else if (dateTime.day == now.day) {
        _daySelectedText = _Str_Today;
      } else {
        _daySelectedText = "${dateTime.year}-${dateTime.month}-${dateTime.day}";
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
                    showTimePicker(context: context, initialTime: _timeOfDay).then((timeOfDay) {
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
                        '${_timeOfDay.hour == 12 || _timeOfDay.hour == 0 ? 12 : _timeOfDay.hourOfPeriod}:${_timeOfDay.minute}',
                        style: TextStyle(fontSize: 80, letterSpacing: 4, color: Colors.black),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 15, left: 5),
                        child: Text(
                          _timeOfDay.period == DayPeriod.am ? "AM" : "PM",
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
                    _weekSelectedText,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                )
              ],
            ),
            trailing: RotationTransition(
                turns: _optionIconAnim,
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
                        style: _changeChipTextStyle(_repeatInWeekList[0]),
                      ),
                      selected: _repeatInWeekList[0],
                      onSelected: (b) {
                        _onWeekSelected(0, b);
                      },
                    ),
                    ChoiceChip(
                        selectedColor: CommonColors.lightBlue,
                        label: Text(
                          "周二",
                          style: _changeChipTextStyle(_repeatInWeekList[1]),
                        ),
                        selected: _repeatInWeekList[1],
                        onSelected: (b) {
                          _onWeekSelected(1, b);
                        }),
                    ChoiceChip(
                        selectedColor: CommonColors.lightBlue,
                        label: Text(
                          "周三",
                          style: _changeChipTextStyle(_repeatInWeekList[2]),
                        ),
                        selected: _repeatInWeekList[2],
                        onSelected: (b) {
                          _onWeekSelected(2, b);
                        }),
                    ChoiceChip(
                        selectedColor: CommonColors.lightBlue,
                        label: Text(
                          "周四",
                          style: _changeChipTextStyle(_repeatInWeekList[3]),
                        ),
                        selected: _repeatInWeekList[3],
                        onSelected: (b) {
                          _onWeekSelected(3, b);
                        }),
                    ChoiceChip(
                        selectedColor: CommonColors.lightBlue,
                        label: Text(
                          "周五",
                          style: _changeChipTextStyle(_repeatInWeekList[4]),
                        ),
                        selected: _repeatInWeekList[4],
                        onSelected: (b) {
                          _onWeekSelected(4, b);
                        }),
                    ChoiceChip(
                        selectedColor: CommonColors.lightBlue,
                        label: Text(
                          "周六",
                          style: _changeChipTextStyle(_repeatInWeekList[5]),
                        ),
                        selected: _repeatInWeekList[5],
                        onSelected: (b) {
                          _onWeekSelected(5, b);
                        }),
                    ChoiceChip(
                        selectedColor: CommonColors.lightBlue,
                        label: Text(
                          "周日",
                          style: _changeChipTextStyle(_repeatInWeekList[6]),
                        ),
                        selected: _repeatInWeekList[6],
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
            offstage: _weekSelectedText != _Str_NO_REPEAT,
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Text(
                      "日期",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Text(
                      _daySelectedText,
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
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 50),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pop(
                context, TimeBean(repeatInWeek: _repeatInWeekList, dateTime: _dateTime, timeOfDay: _timeOfDay));
          },
          isExtended: false,
          child: Icon(Icons.done),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
