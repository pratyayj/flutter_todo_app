import 'task.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'list_generator.dart';

Future<List<Task>> fetchTask() async {
  final response =
  await http.get('http://prattodo.us-east-2.elasticbeanstalk.com/api/display');

  if (response.statusCode == 200) {
    print(response.body);
    // If the call to the server was successful, parse the JSON
    return compute(parseData, response.body);
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

List<Task> parseData(String response) {
  final parsed = json.decode(response);

  return (parsed["data"] as List).map<Task>((json) =>
  new Task.fromJson(json)).toList();
}