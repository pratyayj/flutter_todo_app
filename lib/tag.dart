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