import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';

class TodoByTags extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Second Screen"),
        ),
        body: ListView(
            children: <Widget>[
              FutureBuilder<List<Tag>> (
                  future: fetchTags(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print("Tag is present");
                      _tagsList = snapshot.data;
                      return DropdownButton<String>(
                        value: null,
                        items: _tagsList.map((value) {
                          return new DropdownMenuItem<String>(
                            value: value.tagName,
                            child: Text(value.tagName),
                          );
                        }).toList(),
                        hint: Text("Select tag"),
                        onChanged: (_) {Scaffold.of(context).showSnackBar(new SnackBar(content: Text("Hello")));},
                      ) ;
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    return Container(width: 0.0, height: 0.0);
                  }),
            ])
    );
  }

  Future<List<Tag>> fetchTags() async {
    final response =
    await http.get('http://prattodo.us-east-2.elasticbeanstalk.com/api/displayAllTags');

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      var result = compute(parseData, response.body);
      print(response.body);
      return result;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  static List<Tag> parseData(String response) {
    final parsed = json.decode(response);

    return (parsed["data"] as List).map<Tag>((json) =>
    new Tag.fromJson(json)).toList();
  }

  List<Tag> _tagsList = new List<Tag>();

}

class Tag {
  final String tagName;
  final String id;
  final int v;

  Tag({this.id, this.tagName, this.v});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return new Tag(
      id: json['_id'],
      tagName: json['tagName'],
      v: json['__v'],
    );
  }
}
