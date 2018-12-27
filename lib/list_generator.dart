import 'package:flutter/material.dart';
import 'task.dart';
import 'dart:io';
import 'dart:convert';
import 'main.dart';

class ListCreator {

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
          padding: const EdgeInsets.all(32.0),
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
}

/*

 */
