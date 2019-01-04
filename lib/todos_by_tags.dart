import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'tag.dart';
import 'api_methods.dart';
import 'todo.dart';

class TodosByTags extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodosByTagsHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class TodosByTagsHomePage extends StatefulWidget {
  TodosByTagsHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TodosByTagsHomePageState createState() => _TodosByTagsHomePageState();
}

class _TodosByTagsHomePageState extends State<TodosByTagsHomePage> {
  Tag selectedTag;

  Future<List<Tag>> _tagsList;
  List _todoList = new List<Todo>();

  @override
  void initState() {
    _tagsList = fetchTags();
    super.initState();
  }

  final Logger log = new Logger('TodosByTags');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Second Screen"),
        ),
        body: ListView(
            children: <Widget>[
              FutureBuilder<List<Tag>>(
                  future: _tagsList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return DropdownButton<Tag>(
                        value: selectedTag,
                        items: snapshot.data.map((value) {
                          return new DropdownMenuItem<Tag>(
                            value: value,
                            child: Text(value.tagName),
                          );
                        }).toList(),
                        hint: Text("Select tag"),
                        onChanged: (Tag chosenTag) {
                          setState(() {
                            log.info("In set state");
                            selectedTag = chosenTag;
                            Scaffold.of(context).showSnackBar(new SnackBar(
                                content: Text(selectedTag.tagName)));
                          });
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    return Container(width: 0.0, height: 0.0);
                  }),
              createSimpleWidget(),
            ])
    );
  }

  Widget createSimpleWidget() {
    return (selectedTag == null)
        ? Container()
        : retrieveSelectedTodoAndCreateList(selectedTag.tagName);
  }

  FutureBuilder<List<Todo>> retrieveSelectedTodoAndCreateList(String tagName) {
    return new FutureBuilder<List<Todo>>(
        future: fetchSelectedTodos(tagName),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.hasData);
            _todoList = snapshot.data;
            return createSelectedTodoListViewWidget(_todoList);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return Container(width: 0.0, height: 0.0);
        });
  }

  createSelectedTodoListViewWidget(List<Todo> todoList) {
    final _BIGGER_FONT = const TextStyle(fontSize: 18.0);

    Widget _buildTodoList() {
      return ListView.separated(
          physics: const ScrollPhysics(),
          itemCount: todoList == null ? 0 : todoList.length,
          separatorBuilder: (BuildContext context, int index) => Divider(),
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 0.0),
          itemBuilder: (context, i) {
            return ListTile(
              title: Text(todoList[i].getTaskName(), style: _BIGGER_FONT),
            );
          });
    }

    return _buildTodoList();
  }


}
