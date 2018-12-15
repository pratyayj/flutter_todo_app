class Task {
  final String task;
  final String id;
  final int v;

  Task({this.id, this.task, this.v});

  factory Task.fromJson(Map<String, dynamic> json) {
    return new Task(
      id: json['_id'],
      task: json['task'],
      v: json['__v'],
    );
  }

  String getTask() {
    return task;
  }
}