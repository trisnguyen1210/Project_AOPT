import 'package:beans/database/database_provider.dart';
import 'package:beans/model/challenge.dart';

class ChallengeDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> create(Challenge challenge) async {
    final db = await dbProvider.database;
    return db.insert(challengesTable, challenge.toMap());
  }

  Future<List<Challenge>> getList({List<String> columns, String query}) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result;
    if (query != null && query.isNotEmpty) {
      result = await db.query(
        challengesTable,
        columns: columns,
        where: 'name LIKE ?',
        whereArgs: ['%$query%'],
      );
    } else {
      result = await db.query(challengesTable, columns: columns);
    }

    List<Challenge> challenges = result.isNotEmpty
        ? result.map((item) => Challenge.fromMap(item)).toList()
        : [];
    return challenges;
  }

  Future<Challenge> getRandom() async {
    final db = await dbProvider.database;

    final result = await db.query(
      challengesTable,
      orderBy: 'RANDOM()',
      limit: 1,
    );

    return Challenge.fromMap(result.first);
  }

  Future<Challenge> get(int id) async {
    final db = await dbProvider.database;

    final result = await db.query(
      challengesTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    return Challenge.fromMap(result.first);
  }

  Future<int> update(Challenge challenge) async {
    final db = await dbProvider.database;

    return await db.update(
      challengesTable,
      challenge.toMap(),
      where: 'id = ?',
      whereArgs: [challenge.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbProvider.database;

    return await db.delete(
      challengesTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
