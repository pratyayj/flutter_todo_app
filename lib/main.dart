import 'dart:async';

import 'package:flutter/material.dart';
import 'task.dart';
import 'list_generator.dart';
import 'task_methods.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class TodoHomePage extends StatefulWidget {
  TodoHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.
  // Fields in a Widget subclass are always marked "final".

  final String title;

  @override
  _TodoHomePageState createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {

  final _todoList = <Task>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {

    // Widget that holds the title section


    return MaterialApp(
        title: 'learning',
        home: Scaffold(
            appBar: AppBar(
              title: Text('Pratyay\'s Todo list'),
            ),
            body: ListView(
              children: [
                Image.asset(
                  'images/lake.jpg',
                  width: 600.0,
                  height: 240.0,
                  fit: BoxFit.cover,
                ),
                new FutureBuilder<List<Task>>(
                  future: fetchTask(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print("Data is present");
                      return new ListGenerator(todoList: snapshot.data);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    // By default, show a loading spinner
                    return CircularProgressIndicator();
                  }
                )
                //titleSection,
                //ClickHereWidget(),
              ],
            )
        )
    );
  }


}

/*
Widget titleSection = new Container(
  padding: const EdgeInsets.all(32.0),
  child: Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: FutureBuilder<Task>(
                  future: task,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text("Your task is " + snapshot.data.task,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    // By default, show a loading spinner
                    return CircularProgressIndicator();
                  },
                )
            ),
            Text(
                'Do not forget to do it.',
                style: TextStyle(
                  color: Colors.grey[500],
                )
            ),
          ],
        ),
      ),
      Icon (
        Icons.star,
        color: Colors.red[500],
      ),
      Text('41')
    ],
  ),
);
*/



class ClickHereWidget extends StatefulWidget {

  @override
  _ClickHereState createState() => _ClickHereState();
}

class _ClickHereState extends State<ClickHereWidget> {

  bool _isOn = false;

  void _toggleOn() {
    setState(() {
      // If the lake is currently favorited, unfavorite it.
      if (_isOn) {
        _isOn = false;
        // Otherwise, favorite it.
      } else {
        _isOn = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    // Method that builds the button column
    Widget buildButtonColumn(IconData icon, String label) {
      Color red = Colors.red;

      Widget column = new GestureDetector(
        onTap: () {
          _toggleOn();
        },
          child: new Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.blue),
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: Text(
              label,
              style: _isOn ? TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: red,)
                  : TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      )
      );

      return column;
    }

    return new Container(
        padding: const EdgeInsets.all(8.0),
        child: Row (
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            buildButtonColumn(Icons.airline_seat_recline_extra, "Click here"),
          ],
        )
    );;
  }
}

