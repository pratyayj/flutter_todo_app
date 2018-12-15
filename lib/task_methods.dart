import 'task.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

Future<Task> fetchTask() async {
  final response =
  await http.get('http://prattodo.us-east-2.elasticbeanstalk.com/api/retrieve5c113d8987e6d70fc8ba21cc');

  if (response.statusCode == 200) {
    print(response.body);
    // If the call to the server was successful, parse the JSON
    return Task.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}