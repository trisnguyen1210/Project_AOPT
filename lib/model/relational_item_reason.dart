class RelationalItemReason {
  final int id;
  final int relationalReasonId;
  final int relationalItemId;

  RelationalItemReason({
    this.id,
    this.relationalReasonId,
    this.relationalItemId,
  });

  factory RelationalItemReason.fromMap(Map<String, dynamic> data) =>
      RelationalItemReason(
        id: data['id'],
        relationalReasonId: data['relational_reason_id'],
        relationalItemId: data['relational_item_id'],
      );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'relational_reason_id': this.relationalReasonId,
      'relational_item_id': this.relationalItemId,
    };

    if (id != null) map['id'] = id;

    return map;
  }
}
