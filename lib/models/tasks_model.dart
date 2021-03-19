class Tasks {
  int id;
  String title;
  String priority;
  DateTime date;
  int status; //to check complete or incomplete

  Tasks({this.title, this.priority, this.status, this.date});
  Tasks.withId({this.id, this.title, this.priority, this.status, this.date});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['priority'] = priority;
    map['date'] = date.toIso8601String();
    map['status'] = status;
    return map;
  }

  factory Tasks.fromMap(Map<String, dynamic> map) {
    return Tasks.withId(
        id: map['id'],
        title: map['title'],
        priority: map['priority'],
        date: DateTime.parse(map['date']),
        status: map['status']);
  }
}
