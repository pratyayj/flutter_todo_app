class Todo {
  final String task;
  final String id;
  final int v;

  Todo({this.id, this.task, this.v});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return new Todo(
      id: json['_id'],
      task: json['task'],
      v: json['__v'],
    );
  }

  String getTodo() {
    return task;
  }

  String getId() {
    return id;
  }
}