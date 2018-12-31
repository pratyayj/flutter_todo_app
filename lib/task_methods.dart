import 'task.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';

Future<List<Todo>> fetchTodos() async {
  final response =
  await http.get('http://prattodo.us-east-2.elasticbeanstalk.com/api/displayAllTodo');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return compute(parseData, response.body);
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

List<Todo> parseData(String response) {
  final parsed = json.decode(response);

  return (parsed["data"] as List).map<Todo>((json) =>
  new Todo.fromJson(json)).toList();
}