import 'dart:async';
import 'package:flutter/material.dart';
import 'todo.dart';
import 'api_methods.dart';
import 'todos_by_tags.dart';

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

  final String title;

  @override
  _TodoHomePageState createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  /// The list that holds all the Todos retrieved from the AWS webserver
  List _todoList = new List<Todo>();

  /// The POST url for adding new Todos
  final String POST_URL =
      'http://prattodo.us-east-2.elasticbeanstalk.com/api/createTodo';

  /// The DELETE url for deleting Todos
  final String DELETE_URL =
      'http://prattodo.us-east-2.elasticbeanstalk.com/api/deleteTodo/';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 1));
    return fetchTodos().then((_tasks) {
      setState(() => _todoList = _tasks);
    });
  }

  /// The TextEditingControl that handles changes in TextField
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myController.dispose();
    super.dispose();
  }

  /// Method that creates the ListView Widget
  /// based on the List of Todos passed in.
  createTodoListViewWidget(List<Todo> todoList) {
    final _BIGGER_FONT = const TextStyle(fontSize: 18.0);

    return ListView.separated(
        physics: const ScrollPhysics(),
        itemCount: todoList == null ? 0 : todoList.length,
        separatorBuilder: (BuildContext context, int index) => Divider(),
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 0.0),
        itemBuilder: (context, i) {
          return ListTile(
            title: Text(todoList[i].getTaskName(), style: _BIGGER_FONT),
            trailing: GestureDetector(
              onTap: () {
                String todoName = todoList[i].getTaskName();
                String todoId = todoList[i].getId();
                String finalDeleteUrl = DELETE_URL + todoId;
                apiDeleteRequest(finalDeleteUrl, todoName, context);
                refreshList();
                _refreshIndicatorKey.currentState.show();
              },
              child: new Icon(
                Icons.delete,
                color: Colors.grey,
              ),
            ),
          );
        });
  }

  Widget _buildTodoCreatorForm() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(32.0, 16.0, 0.0, 16.0),
                  child: TextField(
                    cursorColor: Colors.green,
                    controller: myController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Please enter a todo task',
                    ),
                  ))),
          Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 16.0, 32.0, 16.0),
              child: RaisedButton(
                child: const Text('Submit'),
                color: Colors.red,
                highlightColor: Colors.blue,
                elevation: 4.0,
                onPressed: () {
                  String taskName = myController.text;
                  myController.clear();
                  Map map = {'task': taskName};
                  // add logging message or display HTTP response
                  refreshList();
                  apiCreateRequest(POST_URL, map, _scaffoldKey);
                },
              ))
        ]);
  }

  /// This method retrieves all the Todos and
  /// assigns them to the list _todoList.
  FutureBuilder<List<Todo>> retrieveTodoAndCreateList() {
    return new FutureBuilder<List<Todo>>(
        future: fetchTodos(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("Data is present");
            _todoList = snapshot.data;
            return createTodoListViewWidget(_todoList);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return Container(width: 0.0, height: 0.0);
        });
  }

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'learning',
        home: Scaffold(
            key: _scaffoldKey,
            // bottomSheet: _buildTodoCreatorForm(),
            drawer: Drawer(
                child: ListView(
              children: <Widget>[
                DrawerHeader(child: Text("Menu")),
                ListTile(
                  title: Text('View Todos by tag'),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => TodosByTags()));
                    // Navigator.pop(context);
                  },
                )
              ],
            )),
            bottomNavigationBar: _buildTodoCreatorForm(),
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
                    retrieveTodoAndCreateList()
                  ],
                ))));
  }
}
