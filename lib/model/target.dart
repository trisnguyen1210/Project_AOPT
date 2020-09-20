class Target {
  final int id;
  int greenCount;
  int blackCount;
  DateTime dueAt;

  Target({
    this.id,
    this.greenCount,
    this.blackCount,
    this.dueAt,
  });

  factory Target.fromMap(Map<String, dynamic> data) => Target(
        id: data['id'],
        greenCount: data['green_count'],
        blackCount: data['black_count'],
        dueAt: data['due_at'],
      );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'green_count': this.greenCount,
      'black_count': this.blackCount,
      'due_at': this.dueAt,
    };

    if (id != null) map['id'] = id;

    return map;
  }
}
