class RelationalItem {
  final int id;
  final DateTime createdAt;

  RelationalItem({
    this.id,
    this.createdAt,
  });

  factory RelationalItem.fromMap(Map<String, dynamic> data) => RelationalItem(
        id: data['id'],
        createdAt: DateTime.tryParse(data['created_at']),
      );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'created_at': this.createdAt.toIso8601String(),
    };

    if (id != null) map['id'] = id;

    return map;
  }
}
