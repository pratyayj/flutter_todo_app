import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
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
  List _todoList = new List<Task>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  String post_url =
      'http://prattodo.us-east-2.elasticbeanstalk.com/api/createTodo';

  final myController = TextEditingController();

  Future<String> apiCreateRequest(String url, Map jsonMap) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    return reply;
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 1));
    return fetchTask().then((_tasks) {
      setState(() => _todoList = _tasks);

    });
  }

  createList(List<Task> todoList) {
    final _biggerFont = const TextStyle(fontSize: 18.0);

    String delete_url =
        'http://prattodo.us-east-2.elasticbeanstalk.com/api/delete/';

    Future<String> apiDeleteRequest(String url) async {
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.deleteUrl(Uri.parse(url));
      HttpClientResponse response = await request.close();
      // todo - you should check the response.statusCode
      String reply = await response.transform(utf8.decoder).join();
      httpClient.close();
      print(reply);
      return reply;
    }

    Widget _buildTodoList() {
      return ListView.separated(
          physics: const ScrollPhysics(),
          itemCount: todoList == null ? 0 : todoList.length,
          separatorBuilder: (BuildContext, int index) => Divider(),
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 0.0),
          itemBuilder: (context, i) {
            return ListTile(
              title: Text(
                  todoList[i].getTask(),
                  style: _biggerFont
              ),
              trailing: GestureDetector(
                onTap: () {
                  String name = todoList[i].getId();
                  Scaffold.of(context).showSnackBar(new SnackBar(
                      content: Text("You want to delete this " + name)));
                  String final_delete_url = delete_url + name;
                  apiDeleteRequest(final_delete_url);
                  refreshList();
                },
                child: new Icon(
                  Icons.delete,
                  color: Colors.grey,

                ),
              ),
            );
          }
      );
    }

    return _buildTodoList();
  }

  @override
  Widget build(BuildContext context) {
    // Widget that holds the title section
    return MaterialApp(
        title: 'learning',
        home: Scaffold(
          bottomNavigationBar: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            32.0, 16.0, 0.0, 16.0),
                        child: TextField(
                          controller: myController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Please enter a todo task',
                          ),
                        ))),
                Padding(
                    padding: const EdgeInsets.fromLTRB(
                        0.0, 16.0, 32.0, 16.0),
                    child: RaisedButton(
                      child: const Text('Submit'),
                      color: Colors.red,
                      highlightColor: Colors.blue,
                      elevation: 4.0,
                      onPressed: () {
                        String temp = myController.text;
                        myController.clear();
                        Map map = {'task': temp};
                        // add logging message or display HTTP response
                        apiCreateRequest(post_url, map);
                      },
                    ))
              ]),
            appBar: AppBar(
              title: Text('Pratyay\'s Todo list'),
            ),
            body: RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: refreshList,
                child: ListView(
                  children: [
                    Image.asset(
                      'images/lake.jpg',
                      width: 600.0,
                      height: 240.0,
                      fit: BoxFit.cover,
                    ),
                    buildListViewWidget(),
                    ],
                )
            )
        )
    );
  }

  FutureBuilder<List<Task>> buildListViewWidget() {
    return new FutureBuilder<List<Task>>(
        future: fetchTask(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("Data is present");
            _todoList = snapshot.data;
            return createList(_todoList);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return Container(width: 0.0, height: 0.0);

        });
  }
}
