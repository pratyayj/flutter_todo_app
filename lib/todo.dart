class Todo {
  final String taskName;
  final String id;
  final List<dynamic> tags;
  final int v;

  Todo({this.id, this.taskName, this.v, this.tags});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return new Todo(
      id: json['_id'],
      taskName: json['taskName'],
      v: json['__v'],
      tags: json['tag']
    );
  }

  String getTaskName() {
    return taskName;
  }

  String getId() {
    return id;
  }
}