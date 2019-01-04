import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'todo.dart';
import 'tag.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

Future<List<Todo>> fetchTodos() async {
  final response = await http
      .get('http://prattodo.us-east-2.elasticbeanstalk.com/api/displayAllTodo');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return compute(parseTodoData, response.body);
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

List<Todo> parseTodoData(String response) {
  final parsed = json.decode(response);

  return (parsed["data"] as List)
      .map<Todo>((json) => new Todo.fromJson(json))
      .toList();
}

Future<List<Todo>> fetchSelectedTodos(String tagName) async {
  String url = 'http://prattodo.us-east-2.elasticbeanstalk.com/api/sortByTag/' + tagName;

  print(url);

  final response = await http
      .get(url);

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return compute(parseFilteredData, response.body);
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

List<Todo> parseFilteredData(String response) {
  final parsed = json.decode(response);

  return (parsed["message"] as List)
      .map<Todo>((json) => new Todo.fromJson(json))
      .toList();
}

Future<List<Tag>> fetchTags() async {
  final response =
  await http.get(
      'http://prattodo.us-east-2.elasticbeanstalk.com/api/displayAllTags');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    var result = compute(parseTagsData, response.body);
    return result;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

List<Tag> parseTagsData(String response) {
  final parsed = json.decode(response);

  return (parsed["data"] as List)
      .map<Tag>((json) => new Tag.fromJson(json))
      .toList();
}

Future<String> apiDeleteRequest(
    String url, String todoName, BuildContext context) async {
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.deleteUrl(Uri.parse(url));
  HttpClientResponse response = await request.close();
  String reply;
  if (response.statusCode == 200) {
    reply = await response.transform(utf8.decoder).join();
    Scaffold.of(context).showSnackBar(new SnackBar(
        content: Text("You have successfully deleted the todo: " + todoName)));
  } else {
    reply = "Delete for the todo " + todoName + "failed. Please try again.";
    Scaffold.of(context).showSnackBar(new SnackBar(content: Text(reply)));
  }
  httpClient.close();
  print(reply);
  return reply;
}

Future<int> apiCreateRequest(
    String url, Map jsonMap, GlobalKey<ScaffoldState> key) async {
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
  request.headers.set('content-type', 'application/json');
  request.add(utf8.encode(json.encode(jsonMap)));
  HttpClientResponse response = await request.close();
  String reply;
  reply = await response.transform(utf8.decoder).join();
  if (response.statusCode == 201) {
    key.currentState
        .showSnackBar(new SnackBar(content: Text("Todo was" + " added.")));
  } else {
    key.currentState
        .showSnackBar(new SnackBar(content: Text("Todo add" + " failed.")));
  }
  httpClient.close();
  print(reply);
  // print ("The response code is " + response.statusCode.toString());
  return response.statusCode;
}
