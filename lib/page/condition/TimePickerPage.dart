import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_j/model/bean/TaskItemBean.dart';
import 'package:task_j/style/CommonStyle.dart';

class TimePickerPage extends StatefulWidget {
  final TimeBean _timeBean;

  TimePickerPage(this._timeBean);

  @override
  State<StatefulWidget> createState() {
    return TimePickerPageState();
  }
}

class TimePickerPageState extends State<TimePickerPage> with SingleTickerProviderStateMixin {
  //Repeat Option
  Animation _optionIconAnim;
  AnimationController _optionIconAnimController;

  TimeBean _timeBean;
  final _today = DateTime.now();
  bool isDateSet;
  String _weekSelectedText;
  String _daySelectedText;

  @override
  void initState() {
    super.initState();
    //init Animation
    _optionIconAnimController = new AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _optionIconAnim = new Tween(begin: 0.0, end: 0.125).animate(_optionIconAnimController);

    if (widget._timeBean != null) {
      var bean = widget._timeBean;
      _timeBean = TimeBean(
          calendarId: bean.calendarId, repeat: bean.repeat, repeatInWeek: bean.repeatInWeek, dateTime: bean.dateTime);
      isDateSet = true;
    } else {
      _timeBean = TimeBean(dateTime: _today);
      _timeBean.dateTime = _today.add(Duration(days: 1));
      isDateSet = false;
    }

    _weekSelectedText = _timeBean.repeatInWeekStr();
    _daySelectedText = _timeBean.dateToString();
  }

  @override
  void dispose() {
    _optionIconAnimController.dispose();
    super.dispose();
  }

  _onTimeSelected(TimeOfDay value) {
    setState(() {
      if (!isDateSet && !_timeBean.repeat) {
        //如果还没有选择日期，那么选择的时间如果小于当前时间，就把日期自动加一天
        if (_isTimeAfter(TimeOfDay.now(), value)) {
          _timeBean.dateTime = _today.add(Duration(days: 1));
        } else {
          _timeBean.dateTime = _today;
        }

        _daySelectedText = _timeBean.dateToString();
      }

      _timeBean.timeOfDay = value;
    });
  }

  /// if timeOfDay1 >= timeOfDay2 => return true
  bool _isTimeAfter(TimeOfDay timeOfDay1, TimeOfDay timeOfDay2) {
    return _totalMinute(timeOfDay1) >= _totalMinute(timeOfDay2);
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
    setState(() {
      _timeBean.repeatInWeek[index] = b;
      _weekSelectedText = _timeBean.repeatInWeekStr();

      if (_weekSelectedText.length > 15) {
        _weekSelectedText =
            _weekSelectedText.substring(0, 15) + "\n" + _weekSelectedText.substring(15, _weekSelectedText.length);
      }
    });
  }

  _onDateSelected(DateTime dateTime) {
    setState(() {
      isDateSet = true;
      var timeOfDay = _timeBean.timeOfDay;
      _timeBean.dateTime = dateTime;
      _timeBean.timeOfDay = timeOfDay;
      _daySelectedText = _timeBean.dateToString();
    });
  }

  TextStyle _changeChipTextStyle(bool isSelect) {
    return TextStyle(color: isSelect ? Colors.white : Colors.black54);
  }

  @override
  Widget build(BuildContext context) {
    final repeatInWeekList = _timeBean.repeatInWeek;

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
                    showTimePicker(
                      context: context,
                      initialTime: _timeBean.timeOfDay,
                      builder: (BuildContext context, Widget child) {
                        return MediaQuery(
                          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                          child: child,
                        );
                      },
                    ).then((timeOfDay) {
                      print(timeOfDay.format(context));
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
                        _timeBean.timeOfDayToString(),
                        style: TextStyle(fontSize: 80, letterSpacing: 4, color: Colors.black),
                      ),
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
                        style: _changeChipTextStyle(repeatInWeekList[0]),
                      ),
                      selected: repeatInWeekList[0],
                      onSelected: (b) {
                        _onWeekSelected(0, b);
                      },
                    ),
                    ChoiceChip(
                        selectedColor: CommonColors.lightBlue,
                        label: Text(
                          "周二",
                          style: _changeChipTextStyle(repeatInWeekList[1]),
                        ),
                        selected: repeatInWeekList[1],
                        onSelected: (b) {
                          _onWeekSelected(1, b);
                        }),
                    ChoiceChip(
                        selectedColor: CommonColors.lightBlue,
                        label: Text(
                          "周三",
                          style: _changeChipTextStyle(repeatInWeekList[2]),
                        ),
                        selected: repeatInWeekList[2],
                        onSelected: (b) {
                          _onWeekSelected(2, b);
                        }),
                    ChoiceChip(
                        selectedColor: CommonColors.lightBlue,
                        label: Text(
                          "周四",
                          style: _changeChipTextStyle(repeatInWeekList[3]),
                        ),
                        selected: repeatInWeekList[3],
                        onSelected: (b) {
                          _onWeekSelected(3, b);
                        }),
                    ChoiceChip(
                        selectedColor: CommonColors.lightBlue,
                        label: Text(
                          "周五",
                          style: _changeChipTextStyle(repeatInWeekList[4]),
                        ),
                        selected: repeatInWeekList[4],
                        onSelected: (b) {
                          _onWeekSelected(4, b);
                        }),
                    ChoiceChip(
                        selectedColor: CommonColors.lightBlue,
                        label: Text(
                          "周六",
                          style: _changeChipTextStyle(repeatInWeekList[5]),
                        ),
                        selected: repeatInWeekList[5],
                        onSelected: (b) {
                          _onWeekSelected(5, b);
                        }),
                    ChoiceChip(
                        selectedColor: CommonColors.lightBlue,
                        label: Text(
                          "周日",
                          style: _changeChipTextStyle(repeatInWeekList[6]),
                        ),
                        selected: repeatInWeekList[6],
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
            offstage: _weekSelectedText != TimeBean.strNoRepeat,
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
                DateTime firstDate = _today;
                //如果选择时间早于现在时间，那么就定位到明天
                if (_isTimeAfter(TimeOfDay.now(), _timeBean.timeOfDay)) {
                  firstDate = firstDate.add(Duration(days: 1));
                }

                DateTime lastDate = DateTime(_today.year + 1);
                var initialDate = firstDate;

                showDatePicker(context: context, initialDate: initialDate, firstDate: firstDate, lastDate: lastDate)
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
            Navigator.pop(context, _timeBean);
          },
          isExtended: false,
          child: Icon(Icons.done),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
