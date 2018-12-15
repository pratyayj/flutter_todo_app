import 'package:flutter/material.dart';
import 'task.dart';

class ListGenerator extends StatefulWidget {
  final List<Task> todoList;

  ListGenerator({Key key, this.todoList}) : super(key: key);

  @override
  _ListGeneratorState createState() => _ListGeneratorState();
}

class _ListGeneratorState extends State<ListGenerator> {

  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget build(BuildContext context) {

    Widget _buildTodoList() {
      return ListView.separated(
          itemCount: widget.todoList == null ? 0 : widget.todoList.length,
          separatorBuilder: (BuildContext, int index) => Divider(),
          shrinkWrap: true,
          padding: const EdgeInsets.all(32.0),
          itemBuilder: (context, i) {
            return ListTile(
              title: Text(
                  widget.todoList[i].getTask(),
                  style: _biggerFont
              ),
              trailing: new Icon(
                  Icons.delete,
                  color: Colors.grey
              ),
            );
          }
      );
    }

    return _buildTodoList();
  }

}