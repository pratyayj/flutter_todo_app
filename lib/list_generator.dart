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

    Widget _buildTodoItemRow(Task task) {
      return ListTile(
        title: Text(
            task.getTask(),
            style: _biggerFont
        ),
        trailing: new Icon(
            Icons.delete,
            color: Colors.grey
        ),
      );
    }

    Widget _buildTodoList() {
      return ListView.builder(
          itemCount: widget.todoList == null ? 0 : widget.todoList.length,
          shrinkWrap: true,
          padding: const EdgeInsets.all(32.0),
          itemBuilder: (context, i) {
            if (i.isOdd) return Divider();
            final index = i ~/ 2;
            return _buildTodoItemRow(widget.todoList[index]);
          }
      );
    }
  }

}