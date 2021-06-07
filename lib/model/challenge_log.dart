class ChallengeLog {
  final int id;
  final int challengeId;
  bool isDone;
  final DateTime createdAt;
  DateTime get dueAt => this.createdAt.add(Duration(hours: 24));



  ChallengeLog({
    this.id,
    this.challengeId,
    this.isDone,
    this.createdAt,
  });

  factory ChallengeLog.fromMap(Map<String, dynamic> data) => ChallengeLog(
    id: data['id'],
    challengeId: data['challenge_id'],
    isDone: data['is_done'] == 1 ? true : false,
    createdAt: DateTime.parse("${data['created_at']}"),
  );

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'challenge_id': this.challengeId,
      'is_done': this.isDone ? 1 : 0,
      'created_at': this.createdAt.toIso8601String(),
      'due_at': this.dueAt.toIso8601String(),
    };

    if (id != null) map['id'] = id;

    return map;
  }
}
