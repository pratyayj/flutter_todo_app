import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:logging/logging.dart';

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
              FutureBuilder<List<Tag>> (
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
                            Scaffold.of(context).showSnackBar(new SnackBar(content: Text(selectedTag.tagName)));
                          });
                        },
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
