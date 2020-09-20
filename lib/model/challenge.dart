import 'dart:core';

class Challenge {
  final int id;
  final String name;

  Challenge({
    this.id,
    this.name,
  });

  factory Challenge.fromMap(Map<String, dynamic> data) => Challenge(
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
