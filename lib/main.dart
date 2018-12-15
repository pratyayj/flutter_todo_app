import 'dart:async';

import 'package:flutter/material.dart';
import 'task.dart';
import 'task_methods.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

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

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    Future<Task> task = fetchTask();

    // Widget that holds the title section
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

    return MaterialApp(
      title: 'learning',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Pratyay'),
        ),
        body: ListView(
          children: [
            Image.asset(
              'images/lake.jpg',
              width: 600.0,
              height: 240.0,
              fit: BoxFit.cover,
            ),
            titleSection,
            ClickHereWidget(),
          ],
        )
      )
    );
  }

}
