class Badge {
  final int id;
  final String name;
  final String description;
  final DateTime receivedAt;

  Badge({
    this.id,
    this.name,
    this.description,
    this.receivedAt,
  });

  factory Badge.fromMap(Map<String, dynamic> data) => Badge(
        id: data['id'],
        name: data['name'],
        description: data['description'],
        receivedAt: data['received_at'],
      );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': this.name,
      'description': this.description,
      'received_at': this.receivedAt,
    };

    if (id != null) map['id'] = id;

    return map;
  }
}
