class Schedule {
  final int id;
  int scheduleTypeId;
  String description;
  String location;
  DateTime time;

  Schedule({
    this.id,
    this.scheduleTypeId,
    this.description,
    this.location,
    this.time,
  });

  factory Schedule.fromMap(Map<String, dynamic> data) => Schedule(
        id: data['id'],
        scheduleTypeId: data['schedule_type_id'],
        description: data['description'],
        location: data['location'],
        time: data['time'],
      );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'schedule_type_id': this.scheduleTypeId,
      'description': this.description,
      'location': this.location,
      'time': this.time?.toIso8601String(),
    };

    if (id != null) map['id'] = id;

    return map;
  }
}
