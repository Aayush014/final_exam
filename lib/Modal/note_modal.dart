class Note {
  int? id;
  String title;
  String content;
  String time;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'time': time,
    };
  }
}
