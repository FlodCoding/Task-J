import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TaskItemWidget()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class TaskItemWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _TaskItemWidgetState();
  }

}

class _TaskItemWidgetState extends State<TaskItemWidget>{
  @override
  Widget build(BuildContext context) {
    return null;
  }

}