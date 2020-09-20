import 'package:beans/database/database_provider.dart';
import 'package:beans/model/challenge_log.dart';

class ChallengeLogDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> create(ChallengeLog challengeLog) async {
    final db = await dbProvider.database;
    return db.insert(challengeLogsTable, challengeLog.toMap());
  }

  Future<List<ChallengeLog>> getList({List<String> columns}) async {
    final db = await dbProvider.database;

    final result = await db.query(challengeLogsTable, columns: columns);

    List<ChallengeLog> challengeLogs = result.isNotEmpty
        ? result.map((item) => ChallengeLog.fromMap(item)).toList()
        : [];
    return challengeLogs;
  }

  Future<ChallengeLog> get(int id) async {
    final db = await dbProvider.database;

    final result = await db.query(
      challengeLogsTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    return ChallengeLog.fromMap(result.first);
  }

  Future<ChallengeLog> getLatest() async {
    final db = await dbProvider.database;

    final result = await db.query(
      challengeLogsTable,
      orderBy: 'id DESC',
      limit: 1,
    );

    return ChallengeLog.fromMap(result.first);
  }

  Future<int> update(ChallengeLog challengeLog) async {
    final db = await dbProvider.database;

    return await db.update(
      challengeLogsTable,
      challengeLog.toMap(),
      where: 'id = ?',
      whereArgs: [challengeLog.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbProvider.database;
    return await db.delete(
      challengeLogsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
