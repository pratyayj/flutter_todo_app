import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';

  Future<String> apiDeleteRequest(String url, String todoName, BuildContext
  context) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.deleteUrl(Uri.parse(url));
    HttpClientResponse response = await request.close();
    String reply;
    if (response.statusCode == 200) {
      reply = await response.transform(utf8.decoder).join();
      Scaffold.of(context).showSnackBar(new SnackBar(
          content: Text("You have successfully deleted the todo: " +
              todoName)));
    } else {
      reply = "Delete for the todo " + todoName + "failed. Please try again.";
      Scaffold.of(context).showSnackBar(new SnackBar(
          content: Text(reply)));
    }
    httpClient.close();
    print(reply);
    return reply;
  }

  Future<int> apiCreateRequest(String url, Map jsonMap, GlobalKey<ScaffoldState>
  key)
  async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    String reply;
    reply = await response.transform(utf8.decoder).join();
    if (response.statusCode == 201) {
      key.currentState.showSnackBar(new SnackBar(content: Text("Todo was" +
          " added.")));
    } else {
      key.currentState.showSnackBar(new SnackBar(content: Text("Todo add" +
          " failed.")));
    }
    httpClient.close();
    print (reply);
    // print ("The response code is " + response.statusCode.toString());
    return response.statusCode;
  }
