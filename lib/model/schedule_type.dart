class ScheduleType {
  final int id;
  String name;

  ScheduleType({
    this.id,
    this.name,
  });

  factory ScheduleType.fromMap(Map<String, dynamic> data) => ScheduleType(
        id: data['id'],
        name: data['name'],
      );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': this.name,
    };

    if (id != null) map['id'] = id;

    return map;
  }
}
