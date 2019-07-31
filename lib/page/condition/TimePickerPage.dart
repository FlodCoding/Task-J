import 'package:flutter/material.dart';


class TimePickerPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return TimePickerPageState();
  }

}

class TimePickerPageState extends State<TimePickerPage>{
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
        children: <Widget>[

        ],
      ),
    );
  }

}


class TimePickerDialog extends _TimePickerDialog{}